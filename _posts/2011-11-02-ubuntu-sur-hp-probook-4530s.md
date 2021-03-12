---
title: Ubuntu sur HP ProBook 4530s
description: Notes d'installation d'Ubuntu sur un ordinateur portable HP ProBook 4530s
layout: post
lang: fr
---
## Un nouveau portable

J'ai acheté un PC portable HP ProBook 4530s, notamment pour un usage professionnel. Les atouts sont
une dalle mate, un disque dur à 7200t et un processeur Intel Core i5 2410M dernière génération.
L'ordinateur est pré installé avec Windows 7 Pro. Après le premier boot, le système consomme 1,8 Go
de RAM. 4 partitions sont utilisées :

-   ntfs SYSTEM 300M boot
-   ntfs (C:) 442G
-   ntfs HP\_RECOVERY 17,9G
-   fat32 HP\_TOOLS 2,87G

## Ubuntu

Je suis un fidèle utilisateur d'Ubuntu, une distribution Linux facile d'accès. J'ai installé la
version 11.04 Desktop AMD64 en dual boot avec Windows. Je partage cette expérience à travers ce
billet car j'ai rencontré différents problèmes.

## 1er problème: le partitionnement

Un disque dur ne peut pas contenir plus de 4 partitions primaires. La solution consiste à supprimer
une partition pour pouvoir créer une partition étendue. Je sauvegarde donc HP\_TOOLS sur une clé
USB, supprime la partition et redimensionne la partition C: Je redémarre alors Windows pour mettre à
jour la table de partition. Je boote alors sur le CD d'installation et sur l'écran 'Preparing to
install Ubuntu', je coche les cases Download updates while installing Install this third-party
software Sur l'écran 'Allocate Drive Space', je choisis Install ubuntu alongside pour le dual-boot
avec Windows. L'installation a créé 3 partitions :

-   une partition étendue
-   une partition pour la racine (/) en ext4
-   une partition de swap

Tous les périphériques fonctionnent correctement : le wifi, la webcam, le microphone, les touches de
fonction, le touchpad. Le seul problème rencontré est que le double tap LED pour désactiver le
touchpad ne fonctionne pas. Les logiciels non libres (flash et MP3) fonctionne aussi après
l'installation.

## 2ème problème : l'amorçage

Pour vérifier le bon fonctionnement du dual boot, je démarre Windows. Pas de problème. Puis je
démarre à nouveau Ubuntu. Le menu de Grub s'affiche bien mais le système reste bloqué pendant le
démarrage… Après recherche, il s'agit d'un problème spécifique à Windows/HP qui écrit dans le MBR au
détriment de Grub 2. Il suffit de désactiver le service HP Software Framework Service (hpqwmiex.exe)
et de restaurer Grub 2. Au menu de grub, sélectionner recovery mode et, au recovery menu,
sélectionner Update grub bootloader.

## 3ème problème : la carte graphique

L'ordinateur possède deux cartes graphiques : une carte intégrée au processeur et une carte AMD
Radeon HD 6470M dédiée. Le but est d'optimiser la consommation d'énergie en basculant sur la carte
dédiée uniquement en cas de besoin. Malheureusement, cette technique fonctionne encore mal sous
Linux car le serveur X a besoin d'un redémarrage pour le switch.

Après une mise à jour du système, le système reste bloqué pendant le démarrage. Après recherche,
c'est lié à la carte graphique. Une solution, assez bourrine, consiste à désactiver Switchable
Graphics dans le BIOS. Ainsi, le système n'utilise que la carte embarquée avec le processeur, comme
l'indique la commande `lspci|grep VGA`.

## 4ème problème: la carte Wifi

La connexion Wifi souffre de lenteurs. C'est dû à l'utilisation du driver ath9k de la carte Atheros
avec un noyau 2.6.38. La solution consiste simplement à exécuter cette commande :

```
sudo -s
echo "options ath9k nohwcrypt=1" > /etc/modprobe.d/ath9k.conf
```

Tous les problèmes étant maintenant résolus, on va faire quelques réglages :

## Paramétrage du BIOS

Par rapport à mon précédent portable, le BIOS offre beaucoup plus de paramètres. C'est en partie lié
au passage à UEFI et HP qui permet la configuration de ses programmes dans le BIOS. Ces programmes
ne sont pas compatibles avec Linux. J'aime désactiver les choses que je n'utilise pas. J'ai donc
décoché les options suivantes :

-   Device Configurations:
    -   USB Legacy Support
    -   HP Day Starter
    -   HP Quick Web
    -   Numlock On (coché), mais malheureusement ça ne fonctionne pas !
-   Built-in Device Options:
    -   Embedded Bluetooth Device
    -   Wake on LAN (disable)
-   Port Options:
    -   Express Card

## Optimisation du démarrage

Comme indiqué précédemment, Ubuntu est une distribution simple. Le revers de la médaille est le
démarrage par défaut de programmes que je n'utilise pas. J'ai donc décoché dans Startup Application
:

-   Bluetooth Manager
-   Check for new hardware drivers
-   GNOME Login Sound
-   Personal File Sharing
-   Remote Desktop
-   Update Notifier
-   Ubuntu One
-   User folders update
-   Visual Assistance
-   Zeitgeist Datahub (mais malheureusement le service démarre quand même)

Après le démarrage, le système consomme 400 Mo de RAM (4 fois moins que Win 7 !!!)

## Quelques pistes à faire après l'installation

La configuration du touchpad : je désactive le clic avec le touchpad (pour éviter l'insupportable
déplacement du curseur pendant la frappe) et j'utilise le scroll à deux doigts.

Installation de `numlockx` afin de verrouiller automatiquement le pavé numérique avant la connection.

## Conclusion

Malheureusement, l'installation fut plus laborieuse que ce que j'imaginais. Mais une fois cette
étape passée, le système fonctionne impeccablement (pas comme Windows…). J'essayerai l'installation
de la version 11.10 prochainement pour voir si la situation s'est améliorée.
