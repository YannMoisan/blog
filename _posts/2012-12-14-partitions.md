---
title: Le partitionnement de ma machine
description: Pourquoi et comment je partitionne ma machine
layout: blog
lang: fr
---
Ce billet n'est pas une introduction sur la notion de partition mais explique les choix que j'ai
retenu pour le partitionnement de ma machine.

## Pourquoi avoir plusieurs partitions ?

La montée de version d'un système d'exploitation comporte toujours un risque (régressions, …). Il
est donc plus sur de **réinstaller sur une nouvelle partition**. Ainsi, en cas de problème sur le
nouveau système, il est possible de démarrer sur l'ancien.

Il est aussi intéressant de **faire cohabiter différentes distributions** et dans ce cas, chaque
système est installé sur une partition dédiée.

Plusieurs distributions sont alors installées sur la même machine mais certaines données ne sont pas
spécifiques à une distribution. Il est donc intéressant de les isoler sur des partitions qui seront
accessibles par ces différents systèmes.

## Quelles sont mes partitions ?

Bien qu'il soit possible de mettre l'intégralité du répertoire `/home` sur une partition dédiée, je
le déconseille car le même fichier de configuration peut-être lu/écrit par des versions différentes
du même programme, ce qui peut entrainer des comportements inattendus. L'autre possibilité est
d'avoir une partition `/mnt/data` qui contient les documents, les photos, la musique, …

Je partage la partition de swap.

J'ai une partition `/opt` pour les programmes que j'installe à la main, c.-à-d. dont l'installation
se limite à une simple décompression. Ce sont souvent des outils pour le développement : maven,
eclipse, intellij, sbt, mongodb, …

Voici ma configuration :

```
/dev/sda (500GB)
  /dev/sda7  /mnt/data (100GB ext4)
  /dev/sda6  swap
  /dev/sda5  Ubuntu 12.10 (45GB ext4)
  /dev/sda8  Ubuntu 12.04
  /dev/sda11 /opt (10GB ext4)
```

## Comment configurer ces partitions ?

Afin de monter automatiquement les partitions au démarrage, il suffit de les ajouter au fichier
`/etc/fstab` de chaque distribution. Dans ce fichier, chaque partition est représentée par son UUID,
que l'on obtient grâce à la commande `ls -l /dev/disk/by-uuid/`. À titre d'exemple, voici le contenu
de mon fichier `/etc/fstab`.

```
# / was on /dev/sda5 during installation
UUID=d1a25eba-7e6c-4ecf-83d1-d584b02df81d /               ext4    errors=remount-ro 0       1
# /mnt/data on /dev/sda7
UUID=e42d6404-3c71-4a73-94c2-e2845ca3b8e7 /mnt/data               ext4    defaults 0       2
# /opt on /dev/sda11
UUID=ac3a68e9-6918-4301-9b20-2a22fc5e97fa /opt               ext4    defaults 0       2
# swap was on /dev/sda6 during installation
UUID=8164f48b-96ba-4b1b-8503-1b36368c977c none            swap    sw              0       0
```
