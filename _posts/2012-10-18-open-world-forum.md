---
title: Open World Forum
description: Open World Forum
layout: blog
lang: fr
---
J'ai assisté à l'[OWF](http://www.openworldforum.org/), le premier forum Open Source en Europe
vendredi dernier. Cette conférence contenait une track dédiée à Java, et plusieurs présentations sur
Big Data. Cette conférence est gratuite et un stand O'Reilly permettait même de s'approvisionner en
bouquins avec un discount de 40 %. Disclaimer : ce qui suit est une liste de points qui ont retenu
mon attention et pas un CR détaillé de l'événement.

## 10:30 Big Data & Open Source

Le déroulement est le suivant : 4 speakers se succèdent et une table ronde clot la session.

### Romain Chaumais (Ysance) : “Big Data : noSql, Map&Reduce, RDBMS - Quoi utiliser et quand ?”

Cette présentation, à destination du béotien, commence par une introduction de Big Data en rappelant
quelques chiffres sur l'explosion des volumes (1 milliard de like facebook depuis 2009). Mais Big
Data n'est pas qu'une question de volume : règles des 3V : Volume, Vélocité et Variété. Il rappelle
ensuite [le théorème CAP](http://en.wikipedia.org/wiki/CAP_theorem) et l'origine d'Hadoop des grands
du Web (Yahoo, Facebook, Twitter, LinkedIn).

Il présente ensuite l'écosystème :

-   QueryEngine : [Pig](http://pig.apache.org/), [Hive](http://hive.apache.org/)
-   Datamining : [Mahout](http://mahout.apache.org/), Pegasus
-   Admin : [Zookeeper](http://zookeeper.apache.org/), [Oozie](http://oozie.apache.org/), Hue
-   Distribution : [Cloudera](http://www.cloudera.com/), [HortonWorks](http://hortonworks.com/)

### Florian Douetteau (Dataiku) : "Open Source et science de la donnée". Comment la science de la donnée, les outils open source et la maîtrise de grands volumes permettent d'améliorer les performances fonctionnelles et commerciales d'une application, d'un site, d'un jeu…

Le social gaming génère de gros volumes de données : 30 Go de logs par jour, 10 To par an.

Il présente ensuite les outils qu'il a utilisés pour manipuler ces données :

-   Framework Open Source en Python : PyBabe
-   Column Stores: [actian](http://www.actian.com/), [InfiniDB](http://infinidb.org/)
-   Clustering : R
-   Visualisation : Gephi
-   Dashboard : NodeJS, MongoDB, D3.js

Cette diversité engendre donc des architectures techniques complexes. Le speaker travaille donc pour
offrir une solution, via une offre de DataScience on demand : dataiku.

### Emmanuel Keller (Open Search Server) : "Big Data et technologies de Search" - Le moteur de recherche, inspirateur technologique du Big Data ? Immersion et vulgarisation de techniques clés des moteurs de recherche, et prospective sur de nouveaux terrains à défricher.

Il présente l'évolution de Google et notamment la sortie d'un papier en 2004 fondateur de
Map/Reduce. Il rappelle la définition de l'informatique : le traitement automatique de l'information
(Information + Automatique). Il pousse un coup de gueule contre Java, qui est moins adapté à ce type
de tâche qu'un langage comme C, plus proche de la machine. Il recommande donc de jeter un coup
d'œil XtreemFS, Sector et Sphere, tous 3 développés en C/C++.

### Vincent Heuschling (Affini-Tech) : “Comment les technologies bigdata/hadoop viennent au secours des données de Search Engine Optimisation”.

Il rappelle les grandes phases métier d'un projet Big Data : collecter, traiter, analyser, stocker
et visualiser. Il présente les outils utilisés, déjà cités lors de présentations précédentes.

### Table ronde

On évoquera le temps réel avec [Storm](http://storm-project.net/) (utilisé par twitter pour les
trends) et MapR.

## 14:00 Track Java

### 14h00 - 14h45 : New Opportunities for Connected Data, Ian Robinson, Neotechnology

Une track sur Neo4j, une base de données orienté graphe, notamment utilisée par Viadeo pour gérer
son graphe d'utilisateurs et calculer la recommandation sociale.

### 14h45 - 15h30 : Le cloud - Etre ou ne pas être, Sacha Labourey, CloudBees

J'avais déjà vu Sacha à Devoxx France, mais il est tellement bon speaker que je l'ai revu avec
plaisir. Il prend toujours l'exemple de LoseIt, une start-up avec des millions d'utilisateurs et
seulement 4 employés : 2 développeurs et 2 marketteux. Il insiste sur le fait que ce genre de
business model n'était pas possible il y a quelques années.

### 16h15 - 17h00 : Powering Hadoop and Big Data with Eclipse, Cédric Carbone, Talend

Pour être honnête, cette présentation m'a déçu car le with Eclipse s'est transformé en with Talend
Open Studio.

Et pour finir la journée, une série de présentations éclair, notamment une assez poilue sur les
opérateurs secrets de Perl.

### Conclusion

Les sessions ne sont pas aussi techniques qu'à Devoxx mais ce fut néanmoins riche et intéressant.
Cela m'a permis d'avoir des retours d'expérience autour d'Hadoop et d'approfondir ma connaissance de
l'écosystème. Et c'est aussi l'occasion de retrouver quelques connaissances : Joel, Olivier, Xavier
et Philippe.
