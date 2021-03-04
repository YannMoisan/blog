---
title: Design for test
description: Design for test
layout: blog
---
Nous allons voir un exemple de code legacy *Scala* qui n'est pas testable. C'est une problématique
assez simple et indépendante pour un court article.

```
object SUT {
  def isEnabled = ResourceBundle.getBundle("design").getString("enabled").toBoolean
  def methodToTest(name: String) = if (isEnabled) s"Hello $name" else s"Goodbye $name"
}
```

Le problème est qu'il n'est pas possible de tester le comportement de la méthode pour tous les
valeurs de `isEnabled`. Le but de cet article est de voir ce que l'on peut faire pour résoudre ce
problème, sans modifier le code client de cet objet.

## parameter

Le plus simple est d'ajouter un paramètre à la fonction.

```
object SUT {
  def isEnabled = ResourceBundle.getBundle("design").getString("enabled").toBoolean
  def methodToTest(name: String, isEnabled: Boolean = isEnabled) = if (isEnabled) s"Hello $name" else s"Goodbye $name"
}
```

La valeur par défaut permet ainsi au code client de continuer à fonctionner sans modification. Voici
alors le code de test.

```
test("should work when isEnabled is true") {
  assertResult("Hello Test")(SUT.methodToTest("Test", true))
}

test("should work when isEnabled is false") {
  assertResult("Goodbye Test")(SUT.methodToTest("Test", false))
}
```

L'inconvénient est qu'il est bizarre de passer en paramètre une information qui est accessible dans
le scope et qu'il faut le faire pour chaque méthode qui a besoin de ce paramètre.

## class

Il est aussi possible d'introduire une classe.

```
class SUTC {
  def isEnabled = ResourceBundle.getBundle("design").getString("enabled").toBoolean
  def methodToTest(name: String) = if (isEnabled) s"Hello $name" else s"Goodbye $name"
}

object SUT extends SUTC
```

Ce qui permet de surcharger le comportement par défaut dans le test.

```
test("should work when isEnabled is true") {
    val sut = new SUTC {
      override def isEnabled: Boolean = true
    }
    assertResult("Hello Test")(sut.methodToTest("Test"))
}

test("should work when isEnabled is false") {
    val sut = new SUTC {
      override def isEnabled: Boolean = false
    }
    assertResult("Goodbye Test")(sut.methodToTest("Test"))
}
```

## implicit parameter

La dernière possibilité est d'utiliser un paramètre implicite

```
object SUT {
  implicit val isEnabled: Boolean = ResourceBundle.getBundle("design").getString("enabled").toBoolean
  def methodToTest(name: String)(implicit isEnabled: Boolean) = if (isEnabled) s"Hello $name" else s"Goodbye $name"
}
```

```
test("should work when isEnabled is true") {
  assertResult("Hello Test")(SUT.methodToTest("Test")(true))
}

test("should work when isEnabled is false") {
  assertResult("Goodbye Test")(SUT.methodToTest("Test")(false))
}
```

L'inconvénient est que l'on doit modifier le code client pour importer l'implicit.

## Conclusion

Il existe donc des solutions simples, loin du cake pattern et autres monades, pour résoudre cette
problématique. Dans ce cas, la solution class me parait la plus propre.
