---
title: Chain of responsability with Scala partial functions
description: Chain of responsability with Scala partial functions
layout: post
lang: en
---
## Partial functions

In this article, we will explore a fundamental yet highly useful feature of Scala: partial functions.

A partial function (as opposed to a total function) is a function that is not defined for all possible inputs. 
A partial function `g: A => B` is a function for which there exist some values `a` in the domain `A` such that `g(a)` is not defined.
Scala has a good support of partial functions.

## Chain of responsability
At Devoxx France 2023, [Edson Yanaga](https://twitter.com/yanaga) gave a talk in which he revisits the GoF design patterns using the new features of Java. 
Here is his [implementation of the Chain of Responsability pattern](https://github.com/yanaga/revisiting-design-patterns/blob/main/src/main/java/com/google/developers/wallet/chain/revisited/RevisitedChainOfResponsibility.java). 
During the talk, I thought to myself that it's even easier in Scala.

For illustration purposes, let's take the example of the [FizzBuzz](https://codingdojo.org/kata/FizzBuzz/) kata.

Here is the implementation in Scala:

```scala
object FizzBuzz extends App {
  val multipleOfThree: PartialFunction[Int, String] = {
    case i if i % 3 == 0 => "Fizz"
  }
  val multipleOfFive: PartialFunction[Int, String] = {
    case i if i % 5 == 0 => "Buzz"
  }
  val multipleOfBoth: PartialFunction[Int, String] = {
    case i if i % 3 == 0 && i % 5 == 0 => "FizzBuzz"
  }
  val default: PartialFunction[Int, String] = {
    case i => i.toString
  }

  val fizzBuzz = List(multipleOfBoth, multipleOfThree, multipleOfFive, default)
    .reduce(_ orElse _)

  (1 to 100).foreach(i => println(fizzBuzz(i)))
}
```

The Chain of Responsibility is implemented using the `orElse` method to chain the calls.

I also frequently use this technique to implement my heuristics in bot programming competitions on [codingame](https://www.codingame.com). 
This allows me to easily change the priorities of actions just by changing the order in the list.

## Links

- [scala partial functions without phd](https://blog.bruchez.name/posts/scala-partial-functions-without-phd/)
