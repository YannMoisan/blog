---
title: "A rant on programming styles : iteration vs recursion"
description: "A rant on programming styles : iteration vs recursion"
layout: blog
---
In computer science, there are often many ways to obtain the same result. And this is true when it
comes to writing a program. Depending on the programming language, different styles could be used.
In this post, we will see how to write a simple program in Scala : decomposing a number using base
10.

## Iteration

The most obvious implementation seems to be a simple loop, because most of us learned to program in
iterative style.

```
def decompose(n: Int): List[Int] = {
  var history = List[Int]()
  var next = n
  while (next > 0) {
    history = next % 10 :: history
    next = next / 10
  }
  history
}
```

What are the cons ?

Immutable programs are easier to reason about. Here, there is mutability but it remains local to the
method. Nevertheless, it makes the code a bit fragile. For example, if we switch the two lines
inside the `while` instruction, the result becomes wrong.

## Recursion

It exists an interesting property : we can rewrite any loop with a recursive call. This refactoring,
[Replace Iteration with
Recursion](https://www.refactoring.com/catalog/replaceIterationWithRecursion.html), is described in
the great catalog of refactorings written by Martin Fowler.

The main trick is to pass variables that are modified inside the loop as parameters of the function.

```
def decompose(n: Int): List[Int] = decompose(n, Nil)

@tailrec
def decompose(n: Int, history: List[Int]): List[Int] = {
  if (n > 0) {
    decompose(n / 10, n % 10 :: history)
  } else
    history
}
```

## Going further

In the recursive approach, two concerns are still mixed : the computation and the history.

Scala 2.13 introduced a new method `Iterator.unfold` that we can take advantage of. Let's start with
an intuition : `fold` allows to convert multiple values into a single value (like a sum). `unfold`
is the opposite : convert a single value into multiple values.

The documentation says :

```
def unfold[A, S](init: S)(f: (S) => Option[(A, S)]): Iterator[A]
    Creates an Iterator that uses a function f to produce elements of type A 
    and update an internal state of type S.
```

So we have to determine what are elements of type `A` and what is the internal state. As often, it
may be solved by following the types. We are interested in remainders, so they are elements of type
`A`. And the internal state is the next number to consider.

```
def decompose(n: Int): List[Int] =
  Iterator
    .unfold(n) { n =>
      if (n > 0) { Some(n % 10, n / 10) } else None
    }
    .toList
    .reverse
```

## Conclusion

There are really many ways to implement even such a trivial program. Scala offers a rich collection
API and so we can replace custom code by a built-in function, which increases readability and
reduces the surface for bugs.
