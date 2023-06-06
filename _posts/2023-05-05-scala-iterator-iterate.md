---
title: Iterator.iterate
description: Iterator.iterate
layout: post
lang: en
---
In this article, we will continue exploring some basic yet very useful features of Scala.

## Endofunction

A large number of problems involve a function that calculates the next state from the current state, denoted by `f: S => S`.
Such a function, which takes elements from the same set as input and output, is called an endofunction.

## Example

Let's consider the example of a geometric sequence with a common ratio of 2. It can be defined by the recurrence relation Un+1 = 2*Un. 

Suppose we want to answer these questions:

1. What is the value of the 9th element?
2. What is the value of n for which Un = 256?
3. What is the smallest value greater than 100?

In Scala, you can use the `iterate` function on the `Iterator` object to create an infinite iterator that applies a given function repeatedly to the previous result. 
It takes an endofunction as a parameter. The syntax is shown below:

```scala
def iterate[T](start: T)(f: T => T): Iterator[T]
```

We can create the iterator with `Iterator.iterate(1)(_ * 2)`, and then use the following methods to answer the questions:

1. `it.drop(8).next()`
2. `it.indexOf(256)`
3. `it.find(_ > 100)`

## Conclusion

Iterators are a powerful tool in Scala, and many programming exercises can be elegantly solved using them. 
Separating business logic from iteration logic is a case of a crucial design principle called [separation of concerns](https://en.wikipedia.org/wiki/Separation_of_concerns), and iterators make it possible to achieve this separation. 
For example, iterators are very useful on [Advent of Code](https://adventofcode.com/), as demonstrated by [a search in my repository](https://github.com/YannMoisan/advent-of-code/search?q=Iterator.iterate).

