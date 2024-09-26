#!/bin/bash

# Define colors for display (optional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No color (reset)

cat << "EOF"
  _____ __  __          _____ ______    _____ ____  __  __ _____  _____  ______  _____ _____  ____  _____  
 |_   _|  \/  |   /\   / ____|  ____|  / ____/ __ \|  \/  |  __ \|  __ \|  ____|/ ____/ ____|/ __ \|  __ \ 
   | | | \  / |  /  \ | |  __| |__    | |   | |  | | \  / | |__) | |__) | |__  | (___| (___ | |  | | |__) |
   | | | |\/| | / /\ \| | |_ |  __|   | |   | |  | | |\/| |  ___/|  _  /|  __|  \___ \\___ \| |  | |  _  / 
  _| |_| |  | |/ ____ \ |__| | |____  | |___| |__| | |  | | |    | | \ \| |____ ____) |___) | |__| | | \ \ 
 |_____|_|  |_/_/    \_\_____|______|  \_____\____/|_|  |_|_|    |_|  \_\______|_____/_____/ \____/|_|  \_\
                                                                                                                                                                                                                     
EOF

# Timothy Cuenat copyright
echo "Timothy Cuenat - $(date +'%Y')"
echo -e "\n${CYAN}Welcome to the Image Compression Script${NC}"
echo -e "${YELLOW}Please make sure you have ImageMagick installed on your system.${NC}\n"
echo -e "${GREEN}Starting the script...${NC}\n"

# Function to display a stylized progress bar
progressbar() {
  local progress=$1
  local total=$2
  local width=50

  local percent=$((progress * 100 / total))
  local filled=$((progress * width / total))
  local empty=$((width - filled))

  local bar="["
  for ((i = 0; i < filled; i++)); do
    bar+="#"
  done
  for ((i = 0; i < empty; i++)); do
    bar+="-"
  done
  bar+="] $percent%"

  printf "\r${GREEN}%s${NC}" "$bar"
}

# Function to log a message without disrupting the progress bar
log_message() {
  local message="$1"
  local color="${2:-$NC}"

  printf "\r\033[K"
  printf "${color}%s${NC}\n" "$message"
}

# Handler for Ctrl+C
interrupt_handler() {
  log_message ""
  log_message "--- TASK INTERRUPTED ---" "$RED"
  exit 1
}

trap interrupt_handler SIGINT

# Function to compress an image to a target size
compress_image_to_target_size() {
  local input_file="$1"
  local output_file="$2"
  local target_size_mb="$3"
  local quality=98
  local max_attempts=10
  local attempts=0

  cp "$input_file" "$output_file" || { echo "Error copying file: $input_file" >&2; return 1; }
  local current_size
  current_size=$(stat -f%z "$output_file") || { echo "Error getting file size: $output_file" >&2; return 1; }

  while [[ $current_size -gt $target_size_bytes && $quality -gt 10 ]]; do
    quality=$((quality - 1))
    magick "$input_file" -quality "$quality" "$output_file" || { echo "Error compressing file: $output_file" >&2; return 1; }

    local new_size
    new_size=$(stat -f%z "$output_file") || { echo "Error getting file size: $output_file" >&2; return 1; }

    if [[ $new_size -ge $current_size ]]; then
      attempts=$((attempts + 1))
    else
      attempts=0
    fi

    if [[ $attempts -ge $max_attempts ]]; then
      log_message "Failed to compress $output_file to the target size. Moving on." >&2
      break
    fi

    current_size=$new_size
  done

  local size_mb
  size_mb=$(echo "scale=2; $current_size / 1048576" | bc)
  log_message "Compressed image $output_file with quality $quality, final size: ${size_mb} MB" "$BLUE"
}

# Function to copy images without compression
copy_image() {
  local input_file="$1"
  local output_file="$2"

  cp "$input_file" "$output_file" || { echo "Error copying file: $input_file" >&2; return 1; }
  log_message "Copied image $output_file (no compression needed)"
}

# Initialize variables
declare input_dir=""
declare output_dir=""
declare target_size_mb=20
declare copy_smaller_files=false

# Use getopts to parse arguments
while getopts ":i:o:t:c" opt; do
  case ${opt} in
  i)
    input_dir=$OPTARG
    ;;
  o)
    output_dir=$OPTARG
    ;;
  t)
    target_size_mb=$OPTARG
    ;;
  c)
    copy_smaller_files=true
    ;;
  \?)
    echo "Invalid option: -$OPTARG" >&2
    exit 1
    ;;
  :)
    echo "Invalid option: -$OPTARG requires an argument" >&2
    exit 1
    ;;
  esac
done

# Check if input and output directories are provided
if [[ -z "$input_dir" || -z "$output_dir" ]]; then
  echo "Usage: $0 -i <input_dir> -o <output_dir> -t <target_size_mb> [-c]" >&2
  exit 1
fi

# Verify if the output directory exists, if not create it
if [[ ! -d "$output_dir" ]]; then
  if ! mkdir -p "$output_dir"; then
    log_message "Error creating output directory: $output_dir" "$RED" >&2
    exit 1
  fi
fi

# Convert target size to bytes
target_size_bytes=$((target_size_mb * 1000 * 1000))

echo "Input directory: \"$input_dir\""
echo "Output directory: \"$output_dir\""
echo "Target size: $target_size_mb MB"
echo "Copy smaller files: $copy_smaller_files"
echo ""

# List image files (jpg, jpeg, png) in the input directory
image_files=$(find "$input_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))
total_images=$(echo "$image_files" | wc -l)

# Initialize counters
declare total_compressed_images=0
declare total_copied_images=0
declare progress=0

progressbar "$progress" "$total_images"

# Process images in a loop
for image_file in $image_files; do
  [[ -f "$image_file" ]] || continue
  output_file="$output_dir/$(basename "$image_file")"
  current_size=$(stat -f%z "$image_file") || { echo "Error getting file size: $image_file" >&2; continue; }

  if [[ $current_size -lt $target_size_bytes ]]; then
    if $copy_smaller_files; then
      copy_image "$image_file" "$output_file"
      total_copied_images=$((total_copied_images + 1))
    else
      log_message "Skipping file $image_file (already below target size)"
    fi
  else
    compress_image_to_target_size "$image_file" "$output_file" "$target_size_mb"
    total_compressed_images=$((total_compressed_images + 1))
  fi

  progress=$((progress + 1))
  progressbar "$progress" "$total_images"
done

# Display the summary
echo -e "\nTotal compressed images: \"$total_compressed_images\""
echo "Total copied images: \"$total_copied_images\""
echo

log_message "--- COMPRESSION COMPLETED ---" "$GREEN"