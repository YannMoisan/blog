---
title: Librairie Mathématiques
description: Développement d'une petite librairie utilitaire pour les Mathématiques
layout: blog
---
## Le project euler

Tout a commencé par la découverte de ce site internet : [project euler](http://projecteuler.net). Il
s'agit de plusieurs problèmes mathématiques nécessitant un peu de programmation pour être résolu.
Les premiers problèmes sont relativement simples et la difficulté augmente rapidement. J'avoue
m'être laissé prendre au jeu. L'intérêt est de revoir des notions oubliées de manière ludique et de
découvrir de nouveaux concepts.

## Java et les maths

Je choisis évidemment Java pour l'implémentation. Malheureusement, le JDK offre peu de méthodes pour
les mathématiques. En effet, il n'y a que la classe Math, les types primitifs et les wrappers :
Integer, Long, BigInteger, … Cependant, il existe plusieurs librairies, en voici quelques unes :

-   [Google guava](http://code.google.com/p/guava-libraries/)
-   [Apache math](http://commons.apache.org/math/)
-   [Colt](http://acs.lbl.gov/software/colt/index.htm)

## Ma librairie

Aucune de ces librairies ne répond complètement au besoin, notamment dans le domaine de la théorie
des nombres. J'ai donc créé quelques classes qui pourront peut-être vous servir. Voici les
fonctionnalités couvertes :

-   Calcul de la liste des nombre premiers.
-   Décomposition d'un nombre en produit de nombres premiers.
-   Calcul du PPCM (Plus Petit Commun Multiple)
-   Décomposition d'un entier en une liste de chiffres : 123 donne \[1, 2, 3\].
-   Calcul des termes de la suite de Fibonacci.
-   Algèbre combinatoire : calcul de la factorielle et des combinaisons.
-   API de calculs pour les collections. Exemple pour la somme des carrés d'une liste : 1^2 + 2^2 +
    3^2 +…

    ```
    sum(transform(range(1, 10), new Function<Integer, Integer>() {public Integer f(Integer i) {return i * i;}}));
        
    ```

Le code est disponible sur GitHub [ici](https://github.com/YannMoisan/math).

N'hésitez pas à me faire des retours pour faire évoluer ces quelques classes.
