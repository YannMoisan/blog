---
title: Copier-coller sous Linux
description: Copier-coller sous Linux
layout: blog
---
Le but de ce billet est d'expliquer comment copier-coller sous GNU/Linux pour les *hackers*, c.-à-d
de favoriser le clavier.

## Les trois presse-papiers

Il existe 3 presse-papiers sous X : le primaire, le secondaire et le clipboard.

Le presse-papiers primaire est alimenté par une sélection à la souris et son contenu est collé à la
souris avec un clic sur le bouton du milieu ou au clavier avec {s-ins}.

Le presse-papiers clipboard est alimenté par une sélection à la souris suivi de {c-c} et son contenu
est collé au clavier avec {c-v}.

Le presse-papiers secondaire ne sert à rien.

## Vim

Pour copier-coller de Vim vers une autre application, j'utilise la configuration suivante :

```
set clipboard=unnamedplus
```

Cela permet de synchroniser automatiquement le registre `"` (unnamed) avec le registre `+`
(presse-papiers clipboard).

## Urxvt

Un [plugin](https://github.com/muennich/urxvt-perls) permet de copier/coller en utilisant le
presse-papier clipboard dans urxvt avec {c-C} et {c-V}.

xclip est un outil en ligne de commande pour interagir avec les presse-papiers. Il utilise par
défaut le primaire. `xclip -i` est pratique pour copier la sortie standard d'une commande.

Remarque: xsel est une alternative à xclip.

## Les cas d'utilisation

-   Firefox vers Vim
    -   Primaire : sélection dans Firefox, "\*p dans Vim (en mode normal).
    -   Clipboard : sélection et {c-c} dans Firefox, p dans Vim (en mode normal).
-   Vim vers Firefox
    -   Primaire : "\*y{motion} dans Vim, clic milieu dans Firefox.
    -   Clipboard : y{motion} dans Vim, {c-v} dans Firefox.
-   Firefox vers un terminal (pour coller une commande trouver sur le Net)
    -   Primaire : sélection dans Firefox, {s-ins} dans Urxvt.
    -   Clipboard : sélection et {c-c} dans Firefox, {c-V} dans Urxvt.
-   Terminal vers Firefox (pour montrer un problème sur un forum)
    -   Primaire : sélection dans Urxvt, clic milieu dans Firefox car Firefox ne supporte pas
        {s-ins}.
    -   Clipboard : sélection et {c-C} dans Urxvt, {c-V} dans Firefox. (préféré pour éviter double
        clic sur le touchpad.

## Un gestionnaire de presse-papiers

Il n'est pas possible nativement de mettre plusieurs choses dans le presse-papiers, à l'instar des
registres de Vim. Heureusement, [clipit](http://sourceforge.net/projects/gtkclipit/), un fork de
Parcellite, est un outil GTK pour faire des copier-coller multiples. On colle avec {c-c} et au
moment de coller, on fait {c-a-h} pour choisir dans l'historique puis {c-v}.

## Conclusion

J'utilise plus souvent le clipboard pour éviter le double clic que je ne trouve pas pratique sur le
touchpad.

## Liens

[clipboards-latest.txt](http://standards.freedesktop.org/clipboards-spec/clipboards-latest.txt)
