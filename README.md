# Image Compression Script

## Table des Matières
- [Introduction](#introduction)
- [Fonctionnalités](#fonctionnalités)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Utilisation](#utilisation)
  - [Options](#options)
  - [Exemples](#exemples)
- [Gestion des Interruptions](#gestion-des-interruptions)
- [Contribution](#contribution)
- [Licence](#licence)
- [Auteur](#auteur)

## Introduction

Bienvenue dans le **Image Compression Script**, un outil Bash conçu pour compresser efficacement des images par lots en utilisant ImageMagick. Ce script est idéal pour réduire la taille des images tout en conservant une qualité optimale, facilitant ainsi la gestion de grandes bibliothèques d'images.

## Fonctionnalités

- **Compression par Lots** : Traite plusieurs fichiers image en une seule exécution.
- **Personnalisation de la Taille Cible** : Définissez la taille maximale souhaitée pour vos images compressées.
- **Options de Copie** : Choisissez de copier les fichiers déjà inférieurs à la taille cible sans les compresser.
- **Barre de Progression Stylisée** : Visualisez l'avancement du processus de compression en temps réel.
- **Gestion des Interruptions** : Interruption sécurisée du script avec gestion des signaux.
- **Support Multiformat** : Prend en charge les formats JPG, JPEG et PNG.

## Prérequis

- **Bash** : Version 5.0 ou supérieure recommandée.
- **ImageMagick** : Nécessaire pour les opérations de compression.
- **bc** : Utilisé pour les calculs arithmétiques.

### Installation des Prérequis

#### Sur Debian/Ubuntu :

```bash
sudo apt update 
sudo apt install imagemagick bc
```

#### Sur macOS (avec Homebrew) :

```bash
brew install imagemagick bc
```

## Installation

1. **Cloner le Dépôt :**

```bash
git clone https://github.com/yourusername/image-compression-script.git
```

2. **Naviguer dans le Répertoire :**

```bash
cd image-compression-script
```

3. **Rendre le Script Exécutable :**

```bash
chmod +x compress_images.sh
```

4. **Installer les Prérequis :**

   Assurez-vous d'avoir toutes les dépendances nécessaires installées. Reportez-vous à la section [Prérequis](#prérequis) pour plus de détails.

   - **Sur Debian/Ubuntu :**

```bash
sudo apt update**  
sudo apt install imagemagick bc
```

   - **Sur macOS (avec Homebrew) :**

```bash
brew install imagemagick bc
```

5. **Vérifier l'Installation :**

   Pour vous assurer que tout est correctement configuré, vous pouvez exécuter le script avec l'option d'aide pour voir les instructions d'utilisation :

```bash
./compress_images.sh -h
```

   Cela devrait afficher la syntaxe d'utilisation et les options disponibles.

## Utilisation

Exécutez le script en fournissant les répertoires d'entrée et de sortie, ainsi que la taille cible souhaitée. Vous pouvez également spécifier une option pour copier les fichiers déjà inférieurs à la taille cible sans les compresser.

### Syntaxe

```bash
./compress_images.sh -i <répertoire_entrée> -o <répertoire_sortie> -t <taille_cible_MB> [-c]
```

### Options

- `-i` : Répertoire contenant les images à compresser (**obligatoire**).
- `-o` : Répertoire où les images compressées seront sauvegardées (**obligatoire**).
- `-t` : Taille cible maximale des images en mégaoctets (**par défaut : 20 MB**).
- `-c` : Option facultative pour copier les fichiers déjà inférieurs à la taille cible sans compression.

### Exemples

1. **Compression Basique :**

   Compresser toutes les images dans `./images` et sauvegarder les images compressées dans `./compressed_images` avec une taille cible de `20 MB`.

```bash
./compress_images.sh -i ./images -o ./compressed_images -t 20
```

2. **Compression avec Copie des Fichiers Plus Petits :**

   Même que ci-dessus, mais les fichiers déjà en dessous de `20 MB` seront copiés sans compression.

```bash
./compress_images.sh -i ./images -o ./compressed_images -t 20 -c
```

## Gestion des Interruptions

Le script gère les interruptions (par exemple, `Ctrl+C`) de manière élégante en affichant un message et en s'arrêtant proprement sans laisser de processus en suspens.

## Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Fork le dépôt.
2. Créez une branche pour votre fonctionnalité (**git checkout -b feature/nom-feature**).
3. Committez vos changements (**git commit -m 'Ajout d'une nouvelle fonctionnalité'**).
4. Pushez vers la branche (**git push origin feature/nom-feature**).
5. Ouvrez une Pull Request.

## Licence

Ce projet est sous licence MIT. Voir le **LICENSE** fichier pour plus de détails.

## Auteur

**Timothy Cuenat**  
[GitHub](https://github.com/timothycuenat) | [LinkedIn](https://www.linkedin.com/in/timothy-cuenat-a71413190)  
© 2024 Timothy Cuenat

---
