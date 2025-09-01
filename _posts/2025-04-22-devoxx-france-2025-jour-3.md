---
title: Devoxx France 2025 - Jour 3
description: Devoxx France 2025 - Jour 3
layout: post
lang: fr
---
# Les LLM rêvent-ils de cavaliers électriques ? - Thibaut Giraud

Thibaut Giraud refute la thèse que les LLMs se réduisent à des perroquets stochastiques.

Il utilise pour cela l'exemple des échecs et montre qu'avec un prompt sous la
forme d'un PGN, gpt-3.5-turbo-instruct joue entre 1700 et 1800 ELO, ce qui est
le niveau d'un bon joueur !

# 30 ans d'Hello World en Java avec les JDK 1.0 à 24 - Jean-Michel Doudoux

Jean-Michel est connu pour avoir rédiger le tutoriel Développons en Java (soit
plusieurs milliers de page !)

Dans ce talk, pour célébrer les 30 ans de Java, il nous montre 34 façons
d'écrire un HelloWorld. Ca passe notamment par JNI, Nashorn (le moteur d'execution
Javascript), la FFM API (Foreign Function & Memory API) introduite en JDK 22 jusqu'a la nouvelle API Class-File du JDK 24.

# Continuations: The magic behind virtual threads in Java - Balkrishna Rawool

Ce talk est un live coding pour réimplementer les virtuals threads en utilisant
la continuation API, le but étant de comprendre ce qu'il y a sous le capot.

Les virtual thread ont fait leur apparition en Java 21. Le scheduler permet de
monter/démonter des virtual threads dans des platform threads.

Une continuation représente l'état courant du programme.
L'API a deux méthodes pour pause/resume, qui manipulent la call stack.
Les continuations en Java sont réservées pour une utilisation interne uniquement, 
il faut donc utiliser ce flag `--add-exports java.base/jdk.internal.vm=ALL-UNNAMED` pour executer les exemples.

Le speaker commence par implémenter un générateur puis passe à la partie virtual
thread.

[code](https://github.com/balkrishnarawool/continuations)

# Staff Engineer : Les défis, les galères, et comment les surmonter

Les speakers travaillent chez BackMarket et Google.

Ils vont parcourir les questionnements auquel on est confronté en tant que staff

- J'ai pas le temps
    - réduire les interruptions (slack)
    - pour les managers, aider vos staffs à protéger leur temps
    - déléguer, ne pas céder à la tentation: pas le temps de leader, je vais le faire moi-même
- J'ai des idées mais personne ne m'écoute
    - Il faut construire ses relations
- Qu'est ce que je suis censé faire
    - Skip level interview pour dumper la charge mentale de son N+2
- Personne ne comprend pourquoi c'est important
    - Expliquer "qu'est ce qui se passe si on ne le fait pas ?"
- J'ai fait quoi ?
    - Contribution indirectes (qui a mené a un impact)
- J'ai l'impression d'être la personne qui dit toujours non
    - Demander du feedback, votre contribution est probablement apprécié

# Optimisation des requêtes PostgreSQL : Parlons Performance !

[slides](https://l_avrot.gitlab.io/slides/perf_20250418.html)

Rewriter
    - CTE Processing
    - Subquery Transformation
    - Join Reordering (jusqu'à 8 tables)
    - Predicate pushdown

Planner
- estimations des couts basés sur les statistiques
- les fréquences sont basés sur un échantillon de lignes (10%)
- le calcul du cout utilise des constantes configurables
    - `seq_page_cost` = 1
    - `random_page_cost` = 4 (bon il y a 25 ans, possible de mettre 1.1 aujourd'hui avec les SSD)
    - `cpu_tuple_cost`
    - `cpu_index_tuple_cost`

Utiliser explain(analyze,verbose,buffer,wal,memory) pour récupérer un max d'info.
cost=a..b (a pour le temps de recup la première ligne, b pour toutes les lignes)

Performance red flags
- Seq Scan on large tables
- Huge differences between estimated and actual rows
- High-cost Sort or Hash operations
- Nested Loop joins with large outer relations
- Filter conditions (vs. Index Cond)

Vérifier l'utilisation de vos index, il y a des stats là-dessus 
Chercher les index dupliqués.

Rows removed by filter. si selectivité basse (entre 5 et 10%), PG utilise un scan seq

Pour finir, il y a un quizz on doit trouver le problème à partir d'une requete
et du résultat du EXPLAIN ANALYZE.
