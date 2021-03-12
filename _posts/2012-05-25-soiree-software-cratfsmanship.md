---
title: Soirée TDD en pratique - rencontre mensuelle Software Craftsmanship
description: Retour d'expérience de la rencontre mensuelle Software Craftsmanship consacrée à TDD en pratique
layout: post
lang: fr
---
J'ai participé hier à la [7ème
soirée](http://www.meetup.com/paris-software-craftsmanship/events/63398382/?a=ed1_l6) de la
communauté Software Craftsmanship dont le sujet était TDD en pratique. La soirée était sponsorisée
par Arolla et un sympathique buffet permettait de prendre des forces avant la session. Ça commence
par une brève présentation de Joel Costigliola sur le framework d'assertion
[fest-assert](https://github.com/alexruiz/fest-assert-2.x/wiki). Cyrille nous présente alors les
[four element of simple design](http://www.jbrains.ca/permalink/the-four-elements-of-simple-design).

## Kata

Nous votons ensuite entre 2 katas pour retenir celui sur l'écriture en chiffres romains. Le but est
de faire 3 sessions de 30 min en *pair programming* en changeant de binôme à chaque fois
(finalement, le temps ne permettre de ne faire que 2 sessions). Je code avec Yakhya une première
session et nous arrivons à 13, Cyrille rappelle pendant ce temps les bases de TDD : le fameux cycle
Red, Green, Refactor ainsi que l'obligation de ne pas anticiper prématurément la suite. On repart de
zéro avec Loic, ce qui permettra d'aller jusqu'à 39 en utilisant la récursivité. La soirée se
termine par Cyrille et son binôme (je ne connais pas son prénom) qui refont l'exercice en projetant
leur écran. Ils gagnent du temps en mettant le test et l'implémentation dans la même classe et nous
rappellent l'existence des [tests paramétrés de
JUnit](http://junit.sourceforge.net/javadoc/org/junit/runners/Parameterized.html).

## Bilan

Pour ma première participation à cette communauté, c'était très positif. Cela permet de pratiquer
une méthode que l'on n'utilise pas toujours sur les projets. J'ai appris des astuces (merci à Loic
pour le plugin Eclipse mousefeed). J'ai vraiment apprécié le temps économisé grâce au plugin
infinitest. Et j'ai rencontré des gens motivés voire passionnés. Je referais ce kata, en suivant les
pistes lancées par Cyrille : limiter la taille des méthodes à 3 lignes et utiliser exclusivement le
refactoring Eclipse.
