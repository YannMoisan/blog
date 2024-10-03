---
title: Scala resources
layout: page
nav_exclude: true
lang: fr
---
Here is the list of my favorite articles collected during my 10 years of language practice.

## Best practices

- [Why are Default Parameter Values Considered Bad in Scala?](https://blog.ssanj.net/posts/2019-05-01-why-are-default-parameter-values-considered-bad-in-scala.html)
- [try-with-resources](https://dkomanov.medium.com/scala-try-with-resources-735baad0fd7d)
- [scala-best-practices](https://nrinaudo.github.io/scala-best-practices)
- [ADT](https://nrinaudo.github.io/scala-best-practices/definitions/adt.html)
- [referential transparency](https://nrinaudo.github.io/scala-best-practices/definitions/referential_transparency.html)

## Type System

### Awesome overview

- [Kinds of types in Scala](https://kubuszok.com/compiled/kinds-of-types-in-scala/), A master piece, highly recommended read
- [Scala’s Types of Types](http://ktoso.github.io/scala-types-of-types/)
- [Types in Scala](https://heather.miller.am/blog/types-in-scala.html)

### Specific topics

- [Phantom Types in Scala](https://www.codecentric.de/wissens-hub/blog/phantom-types-scala) phantom types never get instantiated. They are used to encode type constraints.
- [Type members are [almost] type parameters](https://typelevel.org/blog/2015/07/13/type-members-parameters.html) type members VS type parameters.
- [When are two methods alike?](https://typelevel.org/blog/2015/07/16/method-equiv.html)
- [A short introduction to the `Aux` pattern](http://gigiigig.github.io/posts/2015/09/13/aux-pattern.html) a trick to overcome a limitation with path dependent type.
- [Generalized Algebraic Data Types in Scala](https://gist.github.com/smarter/2e1c564c83bae58c65b4f3f041bfb15f)
- [Returning the "Current" Type in Scala](http://tpolecat.github.io/2015/04/29/f-bounds.html) An F-bounded type is parameterized over its own subtypes. `trait Pet[A <: Pet[A]]`. And also subtyping VS ad-hoc polymorphism.
- [Fake Theorems for Free ](https://failex.blogspot.com/2013/06/fake-theorems-for-free.html) why you should not use `Object#equals` and `Object#hashCode`
- [Compiler plugin for making type lambdas (type projections) easier to write](https://github.com/typelevel/kind-projector)
- [Generalized type constraints in Scala (without a PhD)](https://blog.bruchez.name/posts/generalized-type-constraints-in-scala/), About `<:<` and `=:=` syntax
- [Avoiding Unnecessary Object Instantiation with Specialized Generics](https://scalac.io/blog/specialized-generics-avoid-object-instantiation/), `@specialized`
- [Type classes in Scala](https://scalac.io/blog/typeclasses-in-scala/)
- [Generics of a Higher Kind](http://adriaanm.github.io/files/higher.pdf)
- [Overcoming type erasure in Scala](https://medium.com/@sinisalouc/overcoming-type-erasure-in-scala-8f2422070d20)

## Category theory

- [Functors, Applicatives, And Monads In Pictures](https://www.adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html)
- [The Essence of the Iterator Pattern](https://etorreborre.blogspot.com/2011/06/essence-of-iterator-pattern.html)
- [Free Monoids and Free Monads](http://blog.higher-order.com/blog/2013/08/20/free-monads-and-free-monoids/)
- [Monoid Morphisms, Products, and Coproducts](http://blog.higher-order.com/blog/2014/03/19/monoid-morphisms-products-coproducts/)
- [A tale on Semirings](https://typelevel.org/blog/2018/11/02/semirings.html)
- [How can we map a Set?](https://typelevel.org/blog/2014/06/22/mapping-sets.html), on coyoneda

## Advanced - Free monad VS tagless final

- [Stackless Scala With Free Monads](http://days2012.scala-lang.org/sites/days2012/files/bjarnason_trampolines.pdf)
- [On Free Monads](https://perevillega.com/posts/understanding-free-monads/)
- [Introduction to Tagless final](https://www.beyondthelines.net/programming/introduction-to-tagless-final/)
- [Exploring Tagless Final pattern for extensive and readable Scala code](https://scalac.io/blog/tagless-final-pattern-for-scala-code/)

## Concurrency

- [An IO monad for cats](https://typelevel.org/blog/2017/05/02/io-monad-for-cats.html)
- [Shared State in Functional Programming](https://typelevel.org/blog/2018/06/07/shared-state-in-fp.html)
- [Why should you care about RT](https://impurepics.com/posts/2018-07-13-referential-transparency-wild.html)
- [Thread Pools](https://gist.github.com/djspiewak/46b543800958cf61af6efa8e072bfd5c)
- [Talk - Intro to Cats-Effect (Gavin Bisesi)](https://www.youtube.com/watch?v=83pXEdCpY4A)
- [Talk - The Making of an IO - Daniel Spiewak](https://www.youtube.com/watch?v=g_jP47HFpWA)

## Various

- [Implicit Design Patterns in Scala](http://www.lihaoyi.com/post/ImplicitDesignPatternsinScala.html)
- [Scrap Your Cake Pattern Boilerplate: Dependency Injection](https://www.originate.com/thinking/scrap-your-cake-pattern-boilerplate-dependency-injection-using-the-reader-monad.html)
- [A brief tour of Scala: two classic problems](https://pabloernesto.github.io/2022/05/22/fibonacci.html), Fibonacci …

## Blogs

- [Runar Bjarnason](http://blog.higher-order.com/), author of Functional Programming in Scala
- [Rob Norris a.k.a. tpolecat](http://tpolecat.github.io/), author of doobie
- [Li Haoyi](http://www.lihaoyi.com/), author of ammonite
- [Eric Torreborre](https://etorreborre.blogspot.com/), author of specs2
- [Travis Brown](https://meta.plasm.us/), author of circe
- [Typelevel](https://typelevel.org/blog/), the blog of the typelevel organization
- [Erik Bruchez](https://blog.bruchez.name/categories/programming/)
