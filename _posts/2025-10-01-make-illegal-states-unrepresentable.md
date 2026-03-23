---
title: A simple tool to make illegal states unrepresentable
description: A simple tool to make illegal states unrepresentable
layout: post
lang: en
---
One of my favorite topics is domain modeling. Even though a key characteristic of good design is to make
illegal states unrepresentable
(a phrase borrowed from [Yaron Minsky](https://blog.janestreet.com/effective-ml-revisited/)), I've often seen counterexamples in existing
codebases.

One important tool to achieve that is to model your domain with types.

We're going to see another tool through two examples.

## Pattern 1: Redundant State - Status and StatusDetail

Imagine a payment system where transactions have both a `status` and `statusDetails`:

```scala
enum Status {
  case Ok
  case Ko
}

enum StatusDetails {
  case Ok1
  case Ok2
  case Ko1
  case Ko2
}

case class Transaction(status: Status, statusDetails: StatusDetails)

object Transaction {
  def from(whatever: String): Transaction = {
    whatever match {
      case "A" => Transaction(Status.Ok, StatusDetails.Ok1)
      case "B" => Transaction(Status.Ok, StatusDetails.Ok2)
      case "C" => Transaction(Status.Ko, StatusDetails.Ko1)
      case "D" => Transaction(Status.Ko, StatusDetails.Ko2)
    }
  }
}
```

Reading the code above, it appears that there is an implicit relationship between
status and statusDetails. In this example, it has been made even more obvious
with the naming.

Take a pause: is there anything wrong with this code?

The issue is that this code is fragile because there are multiple ways to get an
illegal state.

```scala
Transaction(Status.Ok, StatusDetails.Ko1)
Transaction.from("A").copy(statusDetails = StatusDetails.Ko1)
```

Take a pause: how would you fix the issue?

The cause is the implicit relationship, so the type system cannot enforce the
invariant.

```scala
enum Status {
  case Ok
  case Ko
}
enum StatusDetails(val status: Status) {
  case Ok1 extends StatusDetails(Status.Ok)
  case Ok2 extends StatusDetails(Status.Ok)
  case Ko1 extends StatusDetails(Status.Ko)
  case Ko2 extends StatusDetails(Status.Ko)
}

case class Transaction(statusDetails: StatusDetails) {
  val status = statusDetails.status
}
```

By using a [parameterized enum](https://docs.scala-lang.org/scala3/reference/enums/enums.html#parameterized-enums) and a derived property, the relationship is now explicit, making it impossible to have an illegal state.

## Pattern 2: Calculated Values - Sum Example

Let's consider a class containing two amounts and their sum.

```scala
case class Amounts(amount1: Int, amount2: Int, sum: Int)

object Amounts {
  def from(amount1: Int, amount2: Int): Amounts = Amounts(amount1, amount2, amount1 + amount2)
}
```

Take a pause: is there anything wrong with this code?

You got it! The same issue as in the first example.

```scala
Amounts(1, 2, 4)
Amounts.from(1,2).copy(sum = 4)
```

Take a pause: how would you fix the issue?

```scala
case class Amounts(amount1: Int, amount2: Int) {
  val sum = amount1 + amount2
}
```

You got it again. By using a derived property.


## Conclusion

The benefits of using derived properties to make illegal states unrepresentable are numerous:

- Code Quality Benefits:
    - Self-documenting code - The type system makes relationships explicit
    - Easier refactoring - Compiler catches inconsistencies during changes
    - Reduced cognitive load - Developers don't need to remember implicit rules
- Development Process Benefits:
    - Faster debugging - Issues are caught at compile time, not runtime
    - Easier code reviews - Reviewers can focus on logic instead of checking invariants
    - Reduced testing burden - No need to test impossible states
    - Better onboarding - New team members understand constraints from the type signatures
- Maintenance Benefits:
    - Reduced documentation overhead - The code itself documents the business rules
    - Lower maintenance cost - Fewer bugs mean less time spent on fixes
