---
title: Solve type erasure
description: How to solve type erasure issue in Scala
layout: blog
---
A common pitfall with JVM languages is type erasure. Let's see an example :

```
List(1).isInstanceOf[List[String]]
```

Hopefully, it's not a problem with Scala. Prior to version 2.10, Scala uses `Manifest`

```
def foo[T](x: List[T])(implicit m: Manifest[T]) = {
  if (m <:< manifest[String])
    println("Hey, this list is full of strings")
  else
    println("Non-stringy list")
}
```

But Scala 2.10 comes with a new reflection API

```
import scala.reflect.runtime.universe._
def foo[T:TypeTag](x: List[T]) = {
  val t = typeOf[T]
  if (t <:< typeOf[String])
    println("Hey, this list is full of strings")
  else
    println("Non-stringy list")
}
```

On contrary to `Manifest`, `TypeTag` handles correctly path dependent type, existential types, … So if
you are using Scala 2.10 and `Manifest`, consider to migrate.
