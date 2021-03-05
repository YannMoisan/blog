---
title: How-to run tests in parallel with sbt
description: How-to run tests in parallel with sbt
layout: blog
---
The aim of this post is to clarify how to run tests in parallel with sbt.

The initial motivation is to speed up testing on a Spark project.

## 2 level of parallelism

A frequent source of confusion is that there are multiple levels of parallelism involved.

### inside a project

sbt maps each test class to a task. sbt runs tasks in parallel and within the same JVM by default.

Serial execution can be forced with :

```
parallelExecution in Test := false
```

### cross-project

There is a second level of parallelism. If your build is a cross-project build, sbt also runs tasks
from different project in parallel.

sbt can limit task concurrency based on tags. The task test is tagged by default and this tag is
propagated to each child task created for each test class.

To restrict the number of concurrently executing tests in all projects, use:

```
Global / concurrentRestrictions += Tags.limit(Tags.Test, 1)
```

Here is a short recap

| Tags.Test         | parallelExecution | behaviour (cross-project / inside project)                                                                                                                                                                                           |
|-------------------|-------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| \#cores (default) | true              | parallel / parallel                                                                                                                                                                                                                  |
| \#cores (default) | false             | parallel / sequentially                                                                                                                                                                                                              |
| 1                 | true              | sequentially / sequentially (because we limit globally to one task, i.e. one test class, at once)                                                                                                                                    |
| 1                 | false             | WARNING : tests are still run in parallel across projects !!! This is because sbt currently does not tag the generated test task when parallelExecution in Test is set to false. cf [\#2425](https://github.com/sbt/sbt/issues/2425) |

## Forking ?

By default, tests are executed in the same JVM than sbt.

This can be changed with :

```
fork in Test := true
```

Hence, all tests will be executed in a single external JVM. By default, tests executed in a forked
JVM are executed sequentially.

This can be changed with : (the equivalent of parallelExecution)

```
Test / testForkedParallel := true
```

Moreover, in forked mode, each project will spawn its own JVM (I did not find a way to run tests
from all projects in the same forked JVM, the only workaround is to create a dedicated test project
and put all tests inside it).

By default, all tests are in the same group. It's possible to change that with `testGrouping`

For example, if you want each test to be in its own group.

```
testGrouping in Test := (testGrouping in Test).value.flatMap { group =>
  group.tests map (test => Group(test.name, Seq(test), SubProcess(ForkOptions()))
}
```

It's possible to run multiple forked JVM at the same time :

```
concurrentRestrictions := Seq(Tags.limit(Tags.ForkedTestGroup, 2))
```

Here is a short recap

| Tags.ForkedTestGroup | testForkedParallel | testGrouping | behaviour (\#JVM / cross-project / inside project) |
|----------------------|--------------------|--------------|----------------------------------------------------|
| 1 (default)          | false (default)    | (default)    | one JVM per project / sequentially / sequentially  |
| 2                    |                    |              | one JVM per project / parallel / sequentially      |
|                      | true               |              | one JVM per project / sequentially / parallel      |
|                      |                    | single       | one JVM per test                                   |

## Back to Spark

The issue with Spark is that it costs a lot to create a `SparkContext`. So, some libraries allow to
reuse it across multiple tests (e.g.
[spark-testing-base](https://github.com/holdenk/spark-testing-base)).

But it's not thread-safe ! Using what we have learned in the previous sections, there are two
possibilities :

1. Forking. But each project will have its own JVM and its own SparkContext.

2. Stay in the same JVM and execute all tests sequentially (with parallelExecution = true
AND Tags.Test = 1). Warning: the configuration given
[here](https://github.com/holdenk/spark-testing-base#special-considerations) doesn't work in case of
multi-project.

## Why should I trust you

I have created a tiny project to test all these configurations :
<https://github.com/YannMoisan/sbt-parallel>

It's a project with 2 subprojects and 2 test classes in each project : Foo(1|2) in project foo and
Bar(1|2) in project bar. Each test print 5 messages with a 1s delay between them. So we can see how
it's interleaved. Each message contains the class name, the index of the iteration and the pid of
the JVM

Run `sbt test` to see the default behaviour :

The format is ClassName\[iteration\]\[pid\]

Here is the output for default behaviour

```
Foo1[1][39324]
Foo2[1][39324]
Bar2[1][39324]
Bar1[1][39324]

Bar1[2][39324]
Foo2[2][39324]
Bar2[2][39324]
Foo1[2][39324]

Foo1[3][39324]
Foo2[3][39324]
Bar2[3][39324]
Bar1[3][39324]

Bar1[4][39324]
Foo1[4][39324]
Foo2[4][39324]
Bar2[4][39324]

Foo2[5][39324]
Bar2[5][39324]
Bar1[5][39324]
Foo1[5][39324]
```

Here is the output with forked. As expected, there are 2 different pids (one by project)

```
Foo1[1][76860]
Foo1[2][76860]
Foo1[3][76860]
Foo1[4][76860]
Foo1[5][76860]

Foo2[1][76860]
Foo2[2][76860]
Foo2[3][76860]
Foo2[4][76860]
Foo2[5][76860]

Bar2[1][76861]
Bar2[2][76861]
Bar2[3][76861]
Bar2[4][76861]
Bar2[5][76861]

Bar1[1][76861]
Bar1[2][76861]
Bar1[3][76861]
Bar1[4][76861]
Bar1[5][76861]
```

## Links

-   [sbt official doc : Testing](https://www.scala-sbt.org/1.x/docs/Testing.html)
-   [sbt official doc : Forking](https://www.scala-sbt.org/1.x/docs/Forking.html)
-   [sbt official doc : Multi-Project](https://www.scala-sbt.org/1.x/docs/Multi-Project.html)
-   [sbt official doc :
    Parallel-Execution](https://www.scala-sbt.org/1.x/docs/Parallel-Execution.html)
-   [issue 2425](https://github.com/sbt/sbt/issues/2425)

