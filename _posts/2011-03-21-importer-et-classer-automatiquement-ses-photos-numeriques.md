---
title: Importer et classer automatiquement ses photos numériques
description: Script shell pour importer et classer automatiquement les photos de son appareil numérique sous Linux
layout: post
lang: fr
---
Update 17/02/2013 : script sur GitHub, script amélioré

## Pourquoi automatiser ?

Le transfert des photos entre un appareil numérique et un ordinateur et le classement induit sont
des tâches répétitives. Et les données Exif présentes dans les images permettent de réaliser le
classement automatiquement. Utilisant Ubuntu, un système d'exploitation convivial, il est tout
naturel d'automatiser ce processus grâce à un script shell.

Je classe mes photos ainsi : un premier niveau de répertoire par an, et un second niveau par
jour. Je ne change pas le nom du fichier créé par l'appareil : `IMGxxxx.jpg`. Ce classement respecte
l'ordre chronologique et il serait fastidieux de nommer chaque photo en fonction de son contenu.

-   2001
    -   2001-01-01 Description 1
    -   2001-02-01 Description 2
-   2002
    -   2002-01-01 Description 3

## Comment automatiser ?

Je suis sous Ubuntu 10.10, mon appareil photo est un Canon IXUS xxx. Il est donc détecté
automatiquement lors que je le connecte à l'ordinateur par USB. Précision importante : à l'ouverture
de la pop-up, cliquer sur Démonter.

Le script utilise les deux programmes suivants : `gphoto` et `exiftool`. Voici le code source du
script :

```sh
#! /bin/sh
# Importe et classe les fichiers (images et videos) de l'appareil photo.
# Ne supprime pas les photos originales de l'appareil.

mydate=`date +%Y%m%d`
DEST_DIR=~/import$mydate

command -v gphoto2 >/dev/null 2>&1 || { echo >&2 "I require gphoto2 but it's not installed.  Aborting."; exit 1; }
command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed.  Aborting."; exit 1; }

mkdir $DEST_DIR
cd $DEST_DIR

gphoto2 --auto-detect|grep Canon
if [ $? -ne 0 ]
then
    echo "Erreur: vérifier que l'appareil est allumé et connecté."
    exit 1
fi

gphoto2 --get-all-files >/dev/null 2>&1
if [ $? -ne 0 ]
then
    echo "Erreur: vérifier que l'appareil n'est pas monté."
    exit 1
fi
exiftool -ext JPG -ext AVI "-Directory<DateTimeOriginal" -d "%Y-%m-%d" .
```

Le script est disponible sur mon
[GitHub](https://github.com/YannMoisan/dotfiles/blob/master/bin/photo-import).
