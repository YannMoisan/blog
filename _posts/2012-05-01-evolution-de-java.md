---
title: Évolution de Java
description: "À travers un exemple concret, réflexion autour de la nécessaire évolution de Java vers la programmation fonctionnelle. Au menu : Guava, Java 8 et Scala"
layout: blog
lang: fr
---
J'ai déjà parlé du [projet euler](librairie-mathematiques.html). Dans ce billet, nous allons voir
comment résoudre le premier problème en utilisant des technologies de plus en plus récentes, ce qui
permet d'apprécier l'évolution des langages basés sur la JVM. Tout d'abord, voici l'énoncé :

> Si on liste tous les entiers naturels inférieurs à 10 qui sont multiples de 3 ou de 5, on obtient
> 3, 5, 6 et 9. La somme de ces nombres est 23. Trouvez la somme de tous les multiples de 3 ou de 5
> inférieurs à 1000

## Avec Java 6

```
public class Java6Euler1 {
    public static void main(String[] args) {
        int sum = 0;
        for (int i = 1; i < 1000; i++) {
            if (i % 3 == 0 || i % 5 == 0) {
                sum += i;
            }
        }
        System.out.println(sum);
    }
}
```

Ce code semble familier, clair et relativement lisible. Alors pourquoi chercher à l'améliorer ? Le
premier problème est que l'itération est côté client et deuxièmement, cet algorithme n'est pas
parallélisable, et donc n'est pas optimisé les processeurs multi-coeur qui sont devenus la norme
aujourd'hui.

## Avec Guava

[Guava](https://github.com/google/guava) est une librairie développée par Google qui offre
notamment une API Collection riche et un support partiel de la programmation fonctionnelle. Cette
librairie remplace avantageusement la librairie commons collections d'Apache, tombé en désuétude.

```
import java.util.Collection;

import com.google.common.base.Predicate;
import com.google.common.collect.Collections2;
import com.google.common.collect.ContiguousSet;
import com.google.common.collect.DiscreteDomains;
import com.google.common.collect.Ranges;

public class GuavaEuler1 {
    public static void main(String[] args) {
        ContiguousSet<Integer> range = Ranges.closedOpen(1, 1000).asSet(
                DiscreteDomains.integers());

        Collection<Integer> filtered = Collections2.filter(range,
                new Predicate<Integer>() {
                    @Override
                    public boolean apply(Integer i) {
                        return (i % 3 == 0 || i % 5 == 0);
                    }
                });

        int sum = 0;
        for (Integer i : filtered) {
            sum += i;
        }
        System.out.println(sum);
    }
}
```

On progresse : l'itération et le filtrage sont pris en charge par la librairie et l'exécution n'est
pas intrinsèquement en série. Malheureusement, la syntaxe n'est pas pratique car très verbeuse…

## Avec Scala

[Scala](http://www.scala-lang.org/) est un nouveau langage sur la JVM qui combine la programmation
orientée objet et la programmation fonctionnelle. Scala supporte nativement les lambda expressions
(c.-à-d. les fonctions anonymes) et les fonctions d'ordre supérieur (c.-à-d. une fonction prenant en
paramètre d'entrée une ou plusieurs fonctions et/ou renvoyant une fonction). Le code suivant montre
la puissance du langage.

```
object euler1 extends App {
  println((1 until 1000).filter(n => n % 3 == 0 || n % 5 == 0).sum)
}
```

C'est clairement l'objectif à atteindre au niveau de la syntaxe. Le langage a été conçu dés le
départ dans ce but.

## Avec Java 8

[Java 8](http://openjdk.java.net/projects/jdk8/) apportera le support très attendu des
[lambda-expressions](http://openjdk.java.net/projects/lambda/) (JSR 335). Une version binary
snapshot permet d'essayer ces nouveautés.

```
import java.util.ArrayList;
import java.util.List;

public class Java8Euler1 {
    public static void main(String[] args) {
        List<Integer> range = new ArrayList<Integer>();
        for (int i=0; i<1000; i++) {
            range.add(i);
        }
        
        System.out.println(range.filter(s -> s % 3 == 0 || s % 5 == 0).
                reduce(0, (x,y) -> x + y));
    }
}
```

Ce code utilise deux nouveautés de Java 8 : les lambda expressions et les méthodes d'extension
virtuelles. La syntaxe retenue pour les lambda est celle du C\#. Le code est lisible et assez proche
de Scala. Voici quelques précisions techniques :

-   Les méthodes d'extension virtuelles permettent de traiter un problème de l'évolution des API
    existantes, et notamment l'API Collection. Elles permettent d'ajouter une implémentation par
    défaut sur les interfaces. L'interface `Iterable` gagne ainsi une méthode `filter` qui prend en
    paramètre un `Predicate` et possède une implémentation par défaut.

```
Iterable<T> filter(Predicate<? super T> predicate) default {
    return Iterables.filter(this, predicate);
}
```

-   Le type de la lambda expression est déduit en fonction du contexte par le compilateur. On parle
    alors de *target typing*. Dans le code ci-dessus, l'expression `s -> s % 3 == 0 || s % 5 == 0`
    est de type `Predicate`. Le type est toujours une interface à une seule méthode.
-   Le type des paramètres est déduit à partir de la signature de la méthode de l'interface cible.
    Dans notre cas, le compilateur déduit que les paramètres `s`, `x` et `y` sont des `Integer`.
    C'est une extension de l'inférence de type apparue avec les génériques de Java 5 et étendue avec
    l'opérateur diamant de Java 7.

Le code est beaucoup plus lisible qu'avec Guava, ce qui démontre la nécessité de mettre à jour le
langage car les librairies tierces ne permettent pas d'obtenir le même résultat. De plus, la méthode
`reduce` est supportée alors que Guava ne la supporte pas.
