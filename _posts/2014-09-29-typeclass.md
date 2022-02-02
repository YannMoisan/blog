---
title: How to code a type class in Scala
description: We explain through an example how to simply code a type class in Scala. It only takes three lines of code.
layout: post
lang: en
---
The aim of this post is to present the simplest type class example. A type class is a kind of design
pattern that allows adding behaviour to a class without extending it (i.e. non intrusively). Let's
use the REPL :

A type class is just a regular scala `trait`

```scala
scala> trait Show[A] { def show(a: A) : String }
defined trait Show
```

Here is an instance of my type class for type `Int`

```scala
scala> implicit val IntShow = new Show[Int] { def show(i: Int) = s"'$i' is an int" }
IntShow: Show[Int] = $anon$1@14459d53
```

Last step : use the type class by passing it as an implicit parameter

```scala
scala> def f[A](a:A)(implicit s : Show[A]) = println(s.show(a))
f: [A](a: A)(implicit s: Show[A])Unit
```

Let's call it

```scala
scala> f(1)
'1' is an int
```
