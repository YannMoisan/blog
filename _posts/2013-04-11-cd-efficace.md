---
title: Naviguer efficacement depuis le terminal
description: Naviguer efficacement dans l'arborescence, depuis le terminal (uniquement pour bash)
layout: post
lang: fr
---
Voici quelques astuces pour naviguer plus efficacement dans l'arborescence, depuis un terminal bash.

## CDPATH

`CDPATH` permet d'aller facilement dans les sous répertoires d'un répertoire donné. Le cas
d'utilisation classique pour un développeur est le répertoire projects contenant tous ses projets.

Il faut déclarer la variable shell `CDPATH` dans le `.bashrc`, sans oublier d'indiquer le répertoire
courant.

```sh
CDPATH=.:~:/mnt/data/backup/dev/projects/
```

Ainsi, je peux taper depuis n'importe quel répertoire :

```sh
[yamo:/opt] $ cd .vim
/home/yamo/.vim
[yamo:~/.vim] $ 
```

Cela fonctionne avec la complétion (à condition d'avoir installé le paquet `bash-completion`), c'est
d'ailleurs cela qui le rend puissant et addictif.

## cdspell

Il est aussi possible de corriger automatiquement de petites erreurs de frappe, il suffit d'ajouter
dans le `.bashrc` :

```sh
shopt -s cdspell
```

Ainsi, ces erreurs seront automatiquement corrigées.

```sh
[yamo:~] $ cd vim
.vim
[yamo:~/.vim] $
```

```sh
[yamo:~] $ cd .vin
.vim
[yamo:~/.vim] $
```

A noter, cela ne se cumule pas avec `CDPATH`.

## completion-ignore-case

Cette dernière astuce permet d'avoir la complétion insensible à la casse, en ajoutant dans le
`.inputrc`

```sh
set completion-ignore-case
```

Ainsi, on peut commencer à taper :

```sh
cat ~/.xre<Tab>
```

et ce sera corrigé en `.Xresources`

## Conclusion

Tout cela est standard, sans installation de programme supplémentaire, donc utilisable dès
maintenant.

source: http://www.caliban.org/bash/
