---
title: Système de recommandation avec Apache Mahout
description: Retour d'expérience sur la conception d'un système de recommandation avec Apache Mahout
layout: blog
---
Sur mon dernier projet, BlueKiwi, j'ai eu la chance de
travailler sur un système de recommandation. C'est une plateforme de gestion de contenu, et donc un
utilisateur peut lire ou noter des articles. Le but est donc de recommander des articles à un
utilisateur, en se basant sur ses interactions passées avec la plateforme. Cela s'appelle du
filtrage collaboratif (*collaborative filtering*). Nous allons voir les quelques difficultés
rencontrées.

La librairie choisie est [Apache Mahout](http://mahout.apache.org/)

## La préférence

Les algorithmes utilisent une collection de triplets : utilisateur, article, préférence. La
préférence est optionnelle, elle indique la préférence de l'utilisateur pour l'article. Dans notre
cas, le produit étant assez riche, un utilisateur peut effectuer plusieurs actions sur un article
donné (lire, commenter, noter, …). La préférence est donc calculée avec une fonction *maison*. Son
choix est très important : cela a un impact sur l'éparpillement des données (par ex., un utilisateur
lit plus qu'il ne commente). La difficulté est qu'il est impossible de comparer les performances de
différentes fonctions car elles modifient le jeu de données en entrée.

## La similarité

Le fonctionnement interne de ces algorithmes utilise une fonction de similarité pour déterminer la
distance entre deux utilisateurs. Il en existe plusieurs, chacune ayant ses avantages et
inconvénients.

Afin d'illustrer notre propos, voici un exemple de fichier CSV d'entrée au format (user, item,
préférence) :

```
1,101,5
1,102,3
1,103,1
2,101,5
2,103,3
2,104,4
2,106,4
```

### Corrélation de Pearson

mesure la tendance de deux utilisateurs a évolué ensemble proportionnellement.

Dans Mahout, pearson et cosine sont identiques car les données sont centrées.

Calcul : première étape, le centrage des vecteurs. Pour chaque vecteur (i.e. utilisateur), on
soustrait la valeur moyenne :

```
1,101,5-3=2
1,102,3-3=0
1,103,1-3=-2
2,101,5-4=1
2,103,3-4=-1
2,104,4-4=0
2,106,4-4=0
```

Deuxième étape, le calcul

|     | x(u1) | y(u2) | xy  | x²  | y²  |
|-----|-------|-------|-----|-----|-----|
| 101 | 2     | 0     | 2   | 4   | 0   |
| 103 | 1     | -1    | -1  | 1   | 1   |
| Σ   |       |       | 1   | 5   | 1   |

Voici la formule : Σxy/V(Σx²\*Σy²), ce qui donne : 1/V5

Inconvénients

-   Le calcul ne prend pas en compte le nombre de préférences en commun, et a donc tendance à
    éloigner des utilisateurs avec beaucoup de préférences communes. Pour pallier cela, il existe
    une implémentation pondérée (*weighted*)
-   Il est impossible de calculer la similarité entre deux utilisateurs ayant une seule préférence
    en commun.

### Indice de Tanimoto

C'est le rapport entre la taille de l'intersection par la taille de l'union. Il ne prend pas en
compte la valeur des préférences.

=2/(3+4-2)=2/5

### Évaluation du système

Il existe des techniques pour évaluer la qualité d'un système de recommandation en entrainant
l'algorithme sur une partie des données et en comparant les résultats obtenus avec le reste des
données.

Inconvénients

-   Elle pénalise les algorithmes qui font de bonnes recommandations, mais pour lesquelles
    l'utilisateur n'a pas encore exprimé de préférences.
-   Nous avons eu des divergences entre la qualité ressentie par les utilisateurs réels et celle
    calculée automatiquement.
-   Cela ne fonctionne pas bien quand les données sont éparpillées. La performance du système varie
    beaucoup entre deux tirs, et parfois elle ne peut pas être calculée :
    `java.lang.IllegalArgumentException: Illegal nDCG: NaN`

### Hadoop vs Taste

Une des forces de Mahout est de fournir deux implémentations (mono machine et distribuée avec
Hadoop) des mêmes algorithmes. Cependant, toutes les possibilités ne sont pas disponibles en
distribuée, comme par ex. l'`IDRescorer` que nous utilisons pour filtrer les données à posteriori.

### Content based

Il est aussi possible d'utiliser un système de recommandation pour faire des recommandations basées
sur le contenu. On parle alors de *content based*. Le fichier d'entrée a alors le format : document,
term, tf idf. Le problème avec l'implémentation de Cosine est que deux documents avec un mot en
commun auront une similarité de 1, c'est-à-dire la valeur maximum.

### Conclusion

Lors de la conception d'un système de recommandation, il faut donc penser à choisir le meilleur
algorithme de similarité, penser à l'évaluation de ce système, penser aux problèmes du démarrage à
froid (*cold start*). Par ailleurs, l'affichage des voisinages calculés permet de comprendre les
recommandations finales, utile en phase de debug.

### Liens

[pearson and
cosine](http://brenocon.com/blog/2012/03/cosine-similarity-pearson-correlation-and-ols-coefficients/)
