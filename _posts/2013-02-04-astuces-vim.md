---
title: Mes astuces Vim
description: Mes astuces Vim
layout: blog
lang: fr
---
Voici quelques astuces que j'ai apprises en jouant à VimGolf

### Gagner une frappe de touche

| long  | court | description                                                |
|-------|-------|------------------------------------------------------------|
| `hx`  | `X`   | supprimer le caractère avant le curseur                    |
| `j^`  | `+`   | aller au premier caractère non vide de la ligne suivante   |
| `k^`  | `-`   | aller au premier caractère non vide de la ligne précédente |
| `d$`  | `D`   | supprimer jusqu'à la fin de la ligne                       |
| `jdd` | `JD`  | supprimer la ligne du dessous                              |
| `2dd` | `dj`  | supprimer la ligne courant et celle du dessous             |
| `f)`  | `%`   | aller à la prochaine parenthèse fermante                   |

### Quelques commandes Ex

Commençons par un rappel historique : Vim est le successeur de Vi qui est lui-même le successeur de
Ex.

| normal  | commande | description                                                |
|---------|----------|------------------------------------------------------------|
| `jdd`   | `:+d`    | supprimer la ligne du dessous                              |
| `yyjp`  | `:t+`    | Copier la ligne courante en dessous de la ligne du dessous |
| `ddggP` | `:m0`    | Déplacer la ligne courante au début du fichier             |

### Opérateurs commençant par g

Avec Vim, il suffit de doubler les opérateurs pour qu'ils s'appliquent à la ligne courante. Par
exemple : `dd`. Et pour certains opérateurs, il existe même une syntaxe raccourcie.

| long   | court | description                           |
|--------|-------|---------------------------------------|
| `gugu` | `guu` | mettre la ligne courante en minuscule |
| `gUgU` | `gUU` | mettre la ligne courante en majuscule |
| `g?g?` | `g??` | mettre la ligne courante en ROT13     |
| `g~g~` | `g~~` | inverser la casse de ligne courante   |

### Recherche et substitution

| long       | court     | description                                          |
|------------|-----------|------------------------------------------------------|
|            | `:g/^/m0` | inverser l'ordre du fichier                          |
| `:s`       | `&`       | répéter la dernière substitution                     |
| `:%s//~/g` | `g&`      | répéter la dernière substitution sur tout le fichier |
|            | `@:`      | répéter la dernière ex commande                      |

### Quelques commandes avec la touche Ctrl

| commande          | description                                                                    |
|-------------------|--------------------------------------------------------------------------------|
| `<C-x><C-l>`      | en mode insertion, complétion pour une ligne entière                           |
| `<C-n>` / `<C-p>` | en mode insertion, insérer le mot suivant/précédent correspondant (complétion) |
| `<C-o>`           | revenir au dernier emplacement visité                                          |
| `<C-a>` / `<C-x>` | en mode normal, incrémenter / décrémenter le prochain nombre sur la ligne      |

### Entourer un mot

Pour entourer un mot avec des parenthèses, nous faisons généralement en mode normal
`i(<Esc>ea)<Esc>`, ce qui fait 7 touches. Mais il existe plus efficace : `cw()<Esc>P`, ce qui fait 6
touches.

Malheureusement, ce n'est pas rejouable avec la commande `.`. Pour pallier cela, on peut faire
`cw(<c-r><c-o>")`

```
:h i_CTRL-R_CTRL-O
```

Dernière possibilité, utiliser le plugin [vim-surround](https://github.com/tpope/vim-surround) de
Tim Pope. Il suffit alors de faire `veS"`.
