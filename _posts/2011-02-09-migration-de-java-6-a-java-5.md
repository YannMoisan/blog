---
title: Migration de Java 6 à Java 5.
description: Migration d'une application de Java 6 à Java 5
layout: blog
---
Sur mon projet actuel, nous avons dû rétrograder la version de Java utilisée. Seulement trois
problèmes se sont posés :

## @Override

Depuis Java 6, il est possible d'utiliser l'annotation `@Override` sur les méthodes qui implémentent
une méthode d'une interface. Pour l'anecdote, ce changement n'est pas documenté : la javadoc de
l'annotation n'a pas été modifiée. La solution consiste à supprimer ces lignes. Cela est automatisé
avec la ligne de commande suivante :

```
find . -name "*.java" -exec sed -i '/@Override/d' {} \
```

## JAXB

Nous utilisons JAXB, qui a été intégré dans Java 6. La solution consiste à ajouter les librairies
suivantes au classpath :

-   activation.jar
-   jaxb-api.jar
-   jaxb-impl.jar
-   jaxb1-impl.jar
-   jsr173\_1.0\_api.jar

## HSQLDB

Nous utilisons HSQLDB 2.0 pour les tests unitaires. À l'exécution, le code lance la classique
exception suivante : `java.lang.UnsupportedClassVersionError: Bad version number in .class file`.
L'explication est simple : depuis la version 2, le binaire est compilé avec Java 6. La solution
consiste à récupérer la version snapshot qui est disponible pour java 6 et java 5 [sur le site
officiel](http://hsqldb.org/support/index.html).
