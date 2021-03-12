---
title: #1 Dojo Scala
description: Retour d'expérience du premier dojo Scala du 05 juin 2012
layout: post
lang: fr
---
Ce billet est un retour d'expérience du premier dojo Scala qui s'est déroulé le 5/6/2012. Je précise
que je débute en Scala : merci donc de me remonter les erreurs et imprécisions dans mon propos.
C'est la première fois que j'assiste à un évènement dédié à ce langage. Une vingtaine de personnes
ont répondu présent à l'invitation d'Ugo Bourdon, un membre du Paris Scala User Group et Valtech
héberge et sponsorise.

En début de séance, Ugo a rappelé la règle : c'est un format ouvert donc c'est aux participants de
faire vivre la soirée. Rapidement, Jon explique quelques notions théoriques poilues : les monades,
la covariance (+A) et la contravariance (-A), tout en illustrant son propos par une courageuse
session de _live coding_. Il nous préconise ensuite l'utilisation de SBT et nous montre comment
l'installer et l'utiliser : `run`, `console`, `~run` pour le run incrémental. Je repars donc avec une
installation fonctionnelle sur mon laptop.

Il parle ensuite des macros et de quelques projets qui en tirent parti :

-   [expecty](https://github.com/pniederw/expecty) : un framework d'assertion
-   [scalaxy](http://code.google.com/p/scalaxy/) : un framework masquant l'utilisation de scalacl

On parle alors de `Option` et de sa sous classe `None` qui permet de ne pas retourner `null` et
ainsi éviter la fameuse `NullPointerException`. Puis des `case class` qui génèrent automatiquement
tout un tas de méthodes utilitaires : `equals`, `hashCode`, `toString`.

Après la pause pizza, des groupes plus informels se forment pour discuter. Une personne (désolé,
étant nouveau, je ne connais pas les prénoms) fait suite à ma demande et me montre comment faire
cohabiter Java et Scala dans Eclipse et me donne quelques infos sur le `maven-scala-plugin`. On échange alors sur les
pratiques de test et il m'indique l'existence d'un plugin eclipse pour ScalaTest et du projet
[specs2](http://etorreborre.github.com/specs2/) plus orienté BDD.

Avec une autre personne, on regarde les premiers codes Scala que j'ai écrit, et notamment le
problème 8 du projet euler. Il me montre ainsi comment améliorer mon implémentation en tirant parti
de la richesse de l'API Collection de Scala. Voici le code initial :

```scala
println((for (i <- 0 to 1000 - 5) yield (0 to 4).map(j => s.charAt(i + j).getNumericValue).reduceLeft(_ * _)).max)
```

Et le code refactoré :

```scala
println(s.map(_.asDigit).sliding(5).map(_.product).max)
```

Conclusion : Cette soirée était très intéressante. Cela permet de progresser plus rapidement en
posant ses questions à des cadors du langage et de repartir avec des pistes à approfondir…
