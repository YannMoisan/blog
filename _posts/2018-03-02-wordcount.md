---
title: Understand the essence of the iterator pattern through the example of word count
description: We will start with a naive implementation of word count (to compute the numbers of characters, words and lines in a text). We'll perform multiple refactorings to go towards a pure functional approach inspired by the paper The Essence of the Iterator Pattern.
layout: blog
lang: en
---
The starting point is that I'm trying to understand the paper [The Essence of the Iterator
Pattern](https://www.cs.ox.ac.uk/jeremy.gibbons/publications/iterator.pdf). To help my brain, I
need to see how these abstract concepts can be useful in a real world use case. So I've decided to
code a classic use case : word count. The aim is to count the number of chars, words and
lines in a piece of text. The idea is to take the road from the start, hit the wall and appreciate
how clever this paper is.

Let's start with the straightforward solution, that will be enriched step by step.

```
  def wordcount1(s: String) : (Int, Int, Int) = {
    val c = s.length
    val w = s.split("\\w+").size
    val l = s.count(_ == '\n')
    (c, w, l)
  }
```

The drawback is that the text is traversed 3 times.

Let's implement a solution where the text is traversed only once

```
  def wordcount2(s: String) : (Int, Int, Int) = {
    var nonAlpha = true
    var c = 0
    var w = 0
    var l = 0
    s.foreach { ch =>
      c = c + 1
      if (ch == '\n')
        l = l + 1
      if (ch.isLetterOrDigit && nonAlpha)
        w = w + 1
      nonAlpha = !ch.isLetterOrDigit
    }
    (c, w, l)
  }
```

It's a very imperative style, with a big loop that mutate some variables. As you know,
mutability is a bad thing. Let's fix that

```
  def wordcount3(s: String) : (Int, Int, Int) = {
    val init = (true, 0, 0, 0)
    val (_, c, w, l) = s.foldLeft(init) { case ((prevSpace, c, w, l), ch) =>
      (
        isSpace(ch),
        c + 1,
        w + (if (!isSpace(ch) && prevSpace) 1 else 0),
        l + (if (ch == '\n') 1 else 0)
      )
    }
    (c, w, l)
  }
```

It's better, `foldLeft` allow abstracting over the traversal logic. But all the counts are mixed
together which does not respect the single responsibility principle. Let's separate the concerns.

```
  def wordcount4(s: String) : (Int, Int, Int) = {
    val c = s.foldLeft(0) { case (c, _) => c + 1 }

    val (_, w) = s.foldLeft((true, 0)) { case ((prevSpace, w), ch) =>
      (isSpace(ch),
        w + (if (!isSpace(ch) && prevSpace) 1 else 0)
      )
    }

    val l = s.foldLeft(0) { case (l, ch) =>
        l + (if (ch == '\n') 1 else 0)
    }

    (c, w, l)
  }
```

Damned, the problem of traversing 3 times is back ! The power of functional programming is to
compose functions. Let's combine the 3 fold.

```
  def wordcount5(s: String) : (Int, Int, Int) = {
    def foldLeft3[A, B, C, D](as: Seq[A])(z1: B, z2: C, z3: D)(op1: (B, A) => B, op2: (C, A) => C, op3: (D, A) => D) : (B, C, D) = {
      val z = (z1, z2, z3)
      as.foldLeft(z) { case ((acc1, acc2, acc3), a) =>
        (op1(acc1, a), op2(acc2, a), op3(acc3, a))
      }
    }
    val (c, (_, w), l) = foldLeft3(s)(
        0,
        (true, 0),
        0
      )(
        { case (c, _) => c + 1 },
        { case ((prevSpace, w), ch) =>
          (isSpace(ch),
            w + (if (!isSpace(ch) && prevSpace) 1 else 0)
          )
        },
        { case (l, ch) =>
          l + (if (ch == '\n') 1 else 0)
        }
    )
    (c, w, l)
  }
```

As a functional programmer, I really enjoy the way that we can create new combinator from existing
functions. But wait, some more powerful abstractions exists, like `Foldable` and `Traversable` (for
counting words, because it's a stateful process) …

```
  def wordcount6(s: String) : (Int, Int, Int) = {
    val c = s.toList.foldMap(_ => 1)
    val l = s.toList.foldMap(c => if (c == '\n') 1 else 0)
    def f(c: Char): IndexedStateT[Eval, Boolean, Boolean, Int] =
      for {
        x <- get[Boolean]
        y = !isSpace(c)
        _ <- set(y)
      } yield if (y && !x) 1 else 0
    val w = s.toList.traverse(f).run(false).value._2.sum
    (c, w, l)
  }
```

We can even merge foldMap together, because if we have a `Monoid[A]`, we have for free a
`Monoid[(A, A)]`

```
  def wordcount7(s: String) : (Int, Int, Int) = {
    val (c, l) = s.toList.foldMap(c => (1, if (c == '\n') 1 else 0))
    def f(c: Char): IndexedStateT[Eval, Boolean, Boolean, Int] =
      for {
        x <- get[Boolean]
        y = !isSpace(c)
        _ <- set(y)
      } yield if (y && !x) 1 else 0
    val w = s.toList.traverse(f).run(false).value._2.sum
    (c, w, l)
  }
```

Now, we are stuck with 2 traversals.

Hopefully, the paper propose a solution to go further. There is nice [write
up](https://etorreborre.blogspot.fr/2011/06/essence-of-iterator-pattern.html) by Eric Torreborre.
Here is below an implementation made by eedesign in its great [herding
cats](http://eed3si9n.com/herding-cats/applicative-wordcount.html) series.

```
  def wordcount8(s: String) : (Int, Int, Int) = {
    // A type alias to treat Int as semigroupal applicative
    type Count[A] = Const[Int, A]

    // Tye type parameter to Count is ceremonial, so hardcode it to Unit
    def liftInt(i: Int): Count[Unit] = Const(i)

    // A simple counter
    def count[A](a: A): Count[Unit] = liftInt(1)

    val countChar: AppFunc[Count, Char, Unit] = appFunc(count _)

    def testIf(b: Boolean): Int = if (b) 1 else 0
    // An applicative functor to count each line
    val countLine: AppFunc[Count, Char, Unit] =
      appFunc { (c: Char) => liftInt(testIf(c == '\n')) }

    // To count words, we need to detect transitions from whitespace to non-whitespace.
    val countWord =
      appFunc { (c: Char) =>
        for {
          x <- get[Boolean]
          y = !isSpace(c)
          _ <- set(y)
        } yield testIf(y && !x)
      } andThen appFunc(liftInt)

    val countAll = countWord product countLine product countChar
    // Run all applicative functions at once
    val allResults = countAll.traverse(data.toList)
    val wordCountState = allResults.first.first
    val lineCount = allResults.first.second
    val charCount = allResults.second
    val wordCount = wordCountState.value.runA(false).value
    (charCount.getConst, wordCount.getConst,lineCount.getConst)
  }
```

The main points are :

-   each monoid can be transformed to an applicative functor
-   as monoidal functions (`A => M[B]`) can be composed (it's `Kleisli`), applicative function also
    have an interesting composition.

## Conclusion

We've seen many ways to solve the same problem. Functional programming offer powerful
abstraction to decouple things and allow composing small parts together to build complex system. So
it's worth to spend some times to understand those concepts in order to write better programs.
