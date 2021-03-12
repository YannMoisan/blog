---
title: awk vs Scala
description: awk vs Scala
layout: post
lang: fr
---
Dans la série "the right tool for the right job", j'ai besoin d'un petit programme qui filtre
certaines lignes d'un fichier, au format csv. Je veux filtrer les enregistrements pour lesquelles le
nombre de lignes contenant la première colonne est inférieur à un seuil, l'équivalent d'un
`HAVING(COUNT(*)) > seuil` en SQL.

Prenons un exemple pour clarifier cela : un fichier pays.csv contenant des couples pays, ville

```
France,Paris
France,Grenoble
France,Marseille
Espagne,Barcelone
Espagne,Madrid
```

Le but est de supprimer tous les pays ayant moins de 3 villes.

```
France,Paris
France,Grenoble
France,Marseille
```

J'ai voulu tester 2 approches différentes : une première en ligne de commandes et une deuxième avec
Scala.

## awk

La boite à outils Unix permettant de rendre des services inestimables, j'ai implémenté une version
avec awk :

```awk
awk 'BEGIN { FS=","; OFS=","} {id[$0]=$1; lines[$0]=$0; count[$1]++;} END { for (line in lines) if(count[id[line]] > 2) print line}' pays.csv
```

## Scala

```scala
import scala.io.Source._
import java.io.PrintWriter

object awk extends App {
  val out = new PrintWriter("/home/yamo/pays.res")

  fromFile("/home/yamo/pays.csv")
    .getLines()
    .toList
    .groupBy(_.split(",")(0))
    .filter(_._2.length > 2)
    .flatMap(_._2)
    .foreach(out.println(_))

  out.close
}
```

## Conclusion

Étant débutant dans ces 2 langages, je pense que les solutions ne sont pas optimales. D'ailleurs,
n'hésitez pas à me proposer vos améliorations. L'implémentation AWK est plus concise, et utilise un
tableau mutable. Le code Scala est plus verbeux mais orienté fonctionnel et plus lisible.
