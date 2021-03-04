---
title: Les pièges à éviter avec Archlinux
description: Les pièges à éviter avec Archlinux
layout: blog
---
update 2014-03-27 : Garmin Forerunner 305 et serveur d'impression Freebox

Je suis passé sur Archlinux, car j'ai été déçu par Ubuntu ([comme je l'ai déjà
expliqué](ubuntu-12-10.html)). Je cherchais une distribution plus configurable et on
([Olivier](https://twitter.com/OlivierCroisier), [Nahir](https://twitter.com/FreakyNadley), Alkino)
m'a conseillé Archlinux. Cela permet de revenir à plus de simplicité. Je profite d'ailleurs de cette
expérience pour tester i3, un tiling window manager.

## beep

La première chose à faire est de désactiver le beep, en ajoutant dans le `.xinitrc`.

```
    xset -b
```

## Vim

Un des premiers programmes que j'installe est Vim. Malheureusement, le presse-papiers `"*p` ne
fonctionne pas. En fait, le paquet est minimal et il faut installer gvim pour avoir le support du
presse-papiers.

## Zathura

Zathura est un lecteur de PDF léger et clavier centric, avec les raccourcis de Vim. Après
l'installation, Zathura affiche un écran noir. A l'instar de Vim, les packageurs de Arch ont le
souci de gérer les dépendances de manière minimale. Les moteurs de rendu pdf sont en dépendances
optionnelles. Il faut donc en installer un à la main.

## IntelliJ Idea

IntelliJ Idea est le meilleur IDE pour Java. Mais il plante au démarrage en affichant l'erreur
suivante :
`Caused by: java.lang.UnsatisfiedLinkError: /usr/lib/jvm/java-7-openjdk/jre/lib/amd64/libsplashscreen.so: libgif.so.4`.
Il faut installer giflib.

## Imprimante

Il faut installer les paquets `cups` (le serveur d'impression) et `gutenprint` (un ensemble de
drivers). Il reste alors à démarrer le service : `systemctl start cups`. J'ai opté pour un démarrage
à la main, uniquement en cas de besoin. On peut alors configurer alors l'imprimante, une Canon PIXMA
360 dans mon cas, dans un navigateur [localhost:631](http://localhost:631) grâce à l'interface web
de cups.

## Touches multimédia

Pour pouvoir régler le volume à l'aide des touches multimédia, il faut installer le paquet
`alsa-utils` qui contient le programme amixer. Puis installer le paquet `xorg-xev` qui contient le
programme xev, qui nous permettra de trouver les codes des touches multimédia. Il reste alors à
configurer i3, voici l'extrait de ma config :

```
bind 123 exec amixer -q set Master 2dB+ unmute
bind 122 exec amixer -q set Master 2dB- unmute
bind 121 exec amixer -q set Master toggle
```

## Réseau

Je gère aussi le réseau à la main. J'utilise le programme wifi-menu pour le wifi et j'utilise la
commande suivante pour me connecter en ethernet `netcfg -u ethernet-dhcp`, ce qui correspond au
profil dans mon répertoire `etc/network.d/`.

## Le serveur d'impression de la Freebox

En tant que possesseur d'une Freebox Révolution et d'une imprimante USB, je peux bénéficier du
serveur d'impression de la Freebox en branchant mon imprimante en USB dessus.

Première étape, activez le **Partage Windows** et le **Partage d'imprimante** dans l'interface de
configuration de la Freebox.

Deuxième étape, qui m'a fait pas mal galérer : configurer cups. Dans l'interface Web de cups, faire
**Administration > Add printer**. Cocher la case **Window Printer via SAMBA**. Et l'URI est
`smb://WORKGROUP/FREEBOX/Canon%20MX360%20series`. La partie Workgroup est obligatoire pour moi,
contrairement à ce que l'on trouve sur le web. Pour vous aider à trouver l'URI, vous pouvez utiliser
la commande suivante :

```
    smbclient -L mafreebox.freebox.fr
```

Dans mon cas, cela affiche:

```
        Sharename       Type      Comment
        ---------       ----      -------
        Disque dur      Disk      AutoShare of fbxhdiskd partition 2
        Canon MX360 series Printer   
        Canon MX360 series FAX Printer   
        IPC$            IPC       IPC Service (Freebox Server)

        Server               Comment
        ---------            -------
        FREEBOX              Freebox Server

        Workgroup            Master
        ---------            -------
        WORKGROUP            FREEBOX
```

## Garmin Forerunner 305

Le Forerunner 305 est une montre GPS pour la pratique de la course à pied. Malheureusement, Garmin
ne fournit pas de pilotes pour Linux, et la montre n'est pas vue comme un simple disque dur quand on
la connecte en USB.

Voici cependant la marche à suivre pour l'utiliser. Tout d'abord, il faut blacklister le module
gps\_garmin. Ensuite, il faut installer [garmintools](https://code.google.com/p/garmintools/) et
[garminplugin](http://www.andreas-diesner.de/garminplugin). Le premier est un ensemble d'outils en
ligne de commande, qui implémente le protocole de communication avec la montre. Le second est un
plugin Firefox, qui utilise le premier, afin de permettre le dialogue avec la montre depuis le
navigateur. On peut alors récupérer automatiquement ses courses sur
[runkeeper](http://runkeeper.com). A noter, le plugin ne fonctionne pas sur le site
[connect.garmin.com](http://connect.garmin.com).

Il subsiste un énorme problème : nous ne possédons pas nos données. Or, on peut y remédier
facilement avec l'option `BackupWorkout`, désactivée par défaut dans le fichier
`$HOME/.config/garminplugin/garminplugin.xml`. Le plugin fera ainsi lors de chaque transfert une
copie en local des données. On a alors un fichier par session, au format
[TCX](http://en.wikipedia.org/wiki/Training_Center_XML), qui est au format XML.
