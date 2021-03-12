---
title: Copier-coller sous Linux
description: Nous allons voir comment copier-coller efficacement sous Linux. Quels sont les presse-papiers disponibles et comment les utiliser avec le terminal, le shell et vim.
layout: post
lang: fr
last_modified_at: 2021-03-11
---
Le but de ce billet est d'expliquer comment copier-coller sous GNU/Linux pour les *hackers*, c.-à-d
de favoriser le clavier.

## Les trois presse-papiers

Il existe 3 presse-papiers sous X : le primaire, le secondaire et le clipboard.

Le presse-papiers primaire est alimenté par une sélection à la souris et son contenu est collé à la
souris avec un clic sur le bouton du milieu ou au clavier avec <kbd>Shift</kbd> + <kbd>Insert</kbd>.

Le presse-papiers clipboard est alimenté par une sélection à la souris suivi de <kbd>Ctrl</kbd> + <kbd>C</kbd> et son contenu
est collé au clavier avec <kbd>Ctrl</kbd> + <kbd>V</kbd>.

Le presse-papiers secondaire ne sert à rien.

## Vim

Vim utilise une terminologie différente : _yank_ `y` pour copier et _put_ `p` pour coller.

De plus, vim n'utilise pas le clipboard mais des registres. 
Un registre peut être précisé avant la commande pour copier ou coller (s'il est omis, le registre unnamed `"` est utilisé). 

- pour copier : `"{register}y{motion}`
- pour coller : `"{register}p`

2 registres spéciaux permettent d'interagir avec le presse-papier : `+` le presse-papier clipboard et `*` le presse-papier primaire
  
Pour copier-coller de Vim vers une autre application, j'utilise la configuration suivante :

```
set clipboard=unnamedplus
```

Cela permet de synchroniser automatiquement le registre `"` (unnamed) avec le registre `+`
(presse-papier clipboard).

## Le shell

`xsel` est un outil en ligne de commande pour interagir avec les presse-papiers.

- `xsel -i -p` copie l'entrée standard dans le presse-papier primaire
- `xsel -i -b` copie l'entrée standard dans le presse-papier clipboard
- `xsel -o -p` colle le presse-papier primaire
- `xsel -o -b` colle le presse-papier clipboard

Remarque : `xclip` est une alternative à `xsel`.

## Le terminal

La plupart des terminaux (par ex. gnome terminal) utilise <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>C</kbd> pour copier et
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>V</kbd> pour coller. En effet, le raccourci <kbd>Ctrl</kbd> + <kbd>C</kbd> est déjà utilisé par le shell pour 
terminer un processus.

Si vous utilisez urxvt, un [plugin](https://github.com/muennich/urxvt-perls) permet de copier/coller en utilisant le
presse-papier clipboard avec <kbd>Ctrl</kbd> + <kbd>C</kbd> et <kbd>Ctrl</kbd> + <kbd>V</kbd>.

## Les cas d'utilisation

-   Firefox vers Vim
    -   Primaire : sélection dans Firefox, `"*p` dans Vim (en mode normal).
    -   Clipboard : sélection et <kbd>Ctrl</kbd> + <kbd>C</kbd> dans Firefox, `p` dans Vim (en mode normal).
-   Vim vers Firefox
    -   Primaire : `"*y{motion}` dans Vim, clic milieu dans Firefox.
    -   Clipboard : `y{motion}` dans Vim, <kbd>Ctrl</kbd> + <kbd>V</kbd> dans Firefox.
-   Firefox vers un terminal (pour coller une commande trouver sur le Net)
    -   Primaire : sélection dans Firefox, <kbd>Shift</kbd> + <kbd>Insert</kbd> dans le terminal.
    -   Clipboard : sélection et <kbd>Ctrl</kbd> + <kbd>C</kbd> dans Firefox, <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>V</kbd> dans le terminal.
-   Terminal vers Firefox (pour montrer un problème sur un forum)
    -   Primaire : sélection dans le terminal, clic milieu dans Firefox car Firefox ne supporte pas
        <kbd>Shift</kbd> + <kbd>Insert</kbd>.
    -   Clipboard : sélection et <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>C</kbd> dans le terminal, <kbd>Ctrl</kbd> + <kbd>V</kbd> dans Firefox. (préféré pour éviter double
        clic sur le touchpad.

## Un gestionnaire de presse-papiers

Il n'est pas possible nativement de mettre plusieurs choses dans le presse-papiers, à l'instar des
registres de Vim. Heureusement, [clipit](http://sourceforge.net/projects/gtkclipit/), un fork de
Parcellite, est un outil GTK pour faire des copier-coller multiples. On colle avec <kbd>Ctrl</kbd> + <kbd>C</kbd> et au
moment de coller, on fait <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>H</kbd> pour choisir dans l'historique puis <kbd>Ctrl</kbd> + <kbd>V</kbd>.

## Conclusion

J'utilise plus souvent le clipboard pour éviter le double clic que je ne trouve pas pratique sur le
touchpad.

## Liens

- [clipboards-latest.txt](http://standards.freedesktop.org/clipboards-spec/clipboards-latest.txt)
- [vim - accéder au presse-papier [en]](https://vim.fandom.com/wiki/Accessing_the_system_clipboard)