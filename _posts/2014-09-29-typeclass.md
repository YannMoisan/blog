---
title: Simplest typeclass example
description: "Typeclass 101 : Simplest typeclass example in Scala"
layout: blog
lang: en
---
The aim of this post is to present the simplest typeclass example. A typeclass is a kind of design
pattern that allows to add behaviour to a class without extending it (i.e. non intrusively). Let's
use the REPL :

A typeclass is just a regular scala trait

```
scala> trait Show[A] { def show(a: A) : String }
defined trait Show
```

Here is an instance of my typeclass for type Int

```
scala> implicit val IntShow = new Show[Int] { def show(i: Int) = s"'$i' is an int" }
IntShow: Show[Int] = $anon$1@14459d53
```

Last step : use the typeclass by passing it as an implicit parameter

```
scala> def f[A](a:A)(implicit s : Show[A]) = println(s.show(a))
f: [A](a: A)(implicit s: Show[A])Unit
```

Let's call it

```
scala> f(1)
'1' is an int
```
