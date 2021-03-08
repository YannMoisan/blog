---
title: Carnet d'adresses et ligne de commande
description: Manipulation de son carnet d'adresse avec la ligne de commande
layout: blog
lang: fr
---
Un bon développeur, comme tout bon artisan, doit utiliser les bons outils et les maitriser. L'outil
incontournable, en raison notamment de sa puissance, est la ligne de commande. Afin de m'exercer,
j'ai écrit une commande d'une ligne pour trier mes contacts par jour et mois de naissance. Avant
toute chose, j'exporte le carnet d'adresses de Thunderbird au format CSV : Tools > Adress Book
puis Tools > Export.

Voici le code :

```
cat ~/export.csv | 
  sed '1d' | 
  sed -e 's/"[^"]*"//g' | 
  awk -F, '$31 !~"^$" {print $0}' | 
  cut -d, -f1,2,30-32 | 
  sort -g -t, -k4 -k5 | 
  awk -F, 'BEGIN {OFS=""} {printf "%0.2d/%0.2d/%4d %s %s\n", $5, $4, $3, $1, $2}'
```

-   1: supprime la ligne d'entête
-   2: supprime le texte entre double quotes, car il peut contenir des virgules. Exemple : "25, rue
    de la Pie qui Chante"
-   3: filtre les contacts dont la date de naissance n'est pas renseignée
-   4: supprime les champs inutiles
-   5: trie sur le jour et le mois, en gérant le padding optionnel
-   6: formate joliment la sortie

Ce script fonctionne mais est perfectible. N'hésitez pas à m'envoyer vos idées d'amélioration, je
mettrai à jour le billet.
