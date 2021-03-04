---
title: TDD en Scala
description: Comment pratiquer le TDD en Scala, le plus simplement possible (sans IDE)
layout: blog
---
En ce moment, je pratique le [kata](http://en.wikipedia.org/wiki/Kata_%28programming%29) Roman
Numerals pour me familiariser avec l'écosystème Scala. Mon but est la simplicité, je n'utilise donc
que ces programmes : Vim, tmux et sbt. Voici, étape par étape, comment je pratique le TDD en Scala.

Lancer tmux

```
$ tmux
```

Créer et aller dans le répertoire du projet

```
$ mkdir roman
$ cd $_
```

Créer le fichier de configuration de sbt, afin d'ajouter la dépendance avec ScalaTest (framework de
test).

```
$ vim build.sbt
```

```
libraryDependencies += "org.scalatest" %% "scalatest" % "1.8" % "test"
```

Créer et aller dans le répertoire du code source

```
$ mkdir -p src/test/scala
$ cd $_
```

Écrire le code, dans un seul fichier pour faciliter les déplacements entre le code et les tests.

```
$ vim RomanTest.scala
```

```
import org.scalatest.FunSuite

object Roman {
  def decode(s: String) : Int = 0
}

class RomanTest extends FunSuite {
  test("I") {
    assert(Roman.decode("I") === 1)
  }
}
```

Nous allons maintenant pouvoir tester. C'est maintenant que tmux va être utile pour séparer l'écran
en 2 &lt;Ctrl-b&gt; " et aller en bas.

```
$ sbt
```

Lancer les tests en continu

```
> ~ test
```

Le test ne passe pas :

```
[info] RomanTest:
[info] - I *** FAILED ***
[info]   0 did not equal 1 (RomanTest.scala:9)
```

On revient dans Vim, on corrige l'implémentation, on sauvegarde et le test est relancé
automatiquement. L'enchainement des cycles Red Green Refactor se fait ainsi de manière très fluide.

Pour aller plus loin : configurer Vim pour Scala, essayer specs 2.

Et vous, des idées, des remarques…
