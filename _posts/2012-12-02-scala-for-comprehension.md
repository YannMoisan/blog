---
title: for-comprehension en Scala 
description: Explication du for-comprehension en Scala par l'exemple
layout: blog
---
Scala possède un mécanisme très puissant mais pas simple à appréhender : for-comprehension. Le but
de ce billet est d'aborder ce sujet par l'exemple avec les `List`. J'illustre le propos avec des
exemples que vous pouvez exécuter dans le REPL pour vous exercer.

## `map`

La méthode `map` permet d'appliquer une fonction à tous les éléments d'une liste.

```
scala> List(1, 2, 3).map(_ * 2)
res0: List[Int] = List(2, 4, 6)
```

Les for-comprehensions ne sont qu'un sucre syntaxique. Voici le cas le plus simple :

`for (x <- e1) yield e2` est équivalent à `e1.map(x => e2)`

Le premier exemple peut donc être réécrit :

```
scala> for (x <- List(1, 2, 3)) yield x * 2
res1: List[Int] = List(2, 4, 6)
```

## flatten

La méthode `flatten` permet d'aplatir une List, c.-à-d. transformer une List de List en List. Le
plus simple est de voir un exemple :

```
scala> List(List(1, 2), List(3, 4), List(5, 6)).flatten
res2: List[Int] = List(1, 2, 3, 4, 5, 6)
```

## flatMap

La méthode `flatMap` permet de combiner les deux méthodes précédentes :

`xs flatMap f` est équivalent à `(xs map f).flatten`

```
scala> List(1, 2, 3).flatMap(i => ((1 to i).toList))
res0: List[Int] = List(1, 1, 2, 1, 2, 3)
```

Revoyons la scène au ralenti :

```
scala> List(1, 2, 3).map(i => (1 to i).toList)
res1: List[List[Int]] = List(List(1), List(1, 2), List(1, 2, 3))

scala> res1.flatten
res2: List[Int] = List(1, 1, 2, 1, 2, 3)
```

## for-comprehension

C'est le moment de venir au cœur du sujet. Un for-comprehension ressemble à une boucle mais le
mécanisme est en fait beaucoup plus puissant.

```
scala> for (x <- List(1, 2); y <- List(3, 4)) yield (x, y)
res0: List[(Int, Int)] = List((1,3), (1,4), (2,3), (2,4))
```

Comme pour le premier exemple, c'est un sucre syntaxique :

`for (x <- e1; y <- e2) yield e3` est équivalent à `e1.flatMap(x => for (y < - e2) yield e3)`

```
scala> List(1, 2).flatMap(x => List(3, 4).map(y => (x, y)))
res1: List[(Int, Int)] = List((1,3), (1,4), (2,3), (2,4))
```

Intéressons-nous à fonction imbriquée :

```
scala> (x: Int) => List(3, 4).map(y => (x, y))
res2: Int => List[(Int, Int)] = 
```

C'est donc une fonction qui prend un Int et renvoie une liste de paires. Voici le résultat de
l'exécution quand on passe 1 en paramètre :

```
scala> res2(1)
res3: List[(Int, Int)] = List((1,3), (1,4))
```

On peut ainsi substituer le résultat dans l'expression initiale, ce qui donne :

```
scala> List(1, 2).flatMap(x => List((x, 3), (x, 4)))
res4: List[(Int, Int)] = List((1,3), (1,4), (2,3), (2,4))
```

Comme précédemment, revoyons la scène au ralenti :

```
scala> List(1, 2).map(x => List((x, 3), (x, 4)))
res5: List[List[(Int, Int)]] = List(List((1,3), (1,4)), List((2,3), (2,4)))
```

```
scala> res5.flatten
res6: List[(Int, Int)] = List((1,3), (1,4), (2,3), (2,4))
```

Il est à noter que for-comprehension permet aussi de filtrer, avec des guards.
