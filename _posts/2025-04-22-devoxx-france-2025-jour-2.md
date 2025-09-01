---
title: Devoxx France 2025 - Jour 2
description: Devoxx France 2025 - Jour 2
layout: post
lang: fr
---
# Les clés de l’architecture pour les devs

Tout d'abord, chapeau à Eric Le Merdy qui a appris le matin du talk qu'il remplacerait Christian Sperandio.

Le fil rouge de ce talk est un besoin client : un fichier est reçu chaque
minute, et ces fichiers doivent être aggregés toutes les 15 min

- Ne pas parler solution avant d'avoir compris le problème
- Faire simple pour valider les hypothèses : 2 briques logique, 1 seul brique physique (avantage: 1 déploiement) = modular monolith
- Garder des options pour changer (par ex. une interface pour les connecteurs entre module) - Reversible decisions
- Archi = compromis
- On teste en prod avec impl. in-memory, on fera la durabilité après
- Faire du json c'est établir un contrat (les contrats sont partout, ex:`.h`/`.c`, API, MCP)
- Les contrats sont pour toujours.
- Règles de robustesse :
    - Ignore les évements et les champs inconnus.
    - Ne jamais supprimer un champs ou un événement.
    - Toujours ajouter un nouveau champs pour faire des changements
- Faire des ADR
- ArchUnit est un outil pour tester son archi

# Booster le démarrage des applications Java : optimisations JVM et frameworks - Olivier Bourgain

Le cycle de vie : Build (artefact) -> Docker image -> Deploy

Les frameworks font plein de choses au démarrage : scanner le classpath, parser le bytecode, reflection, génération de code.

La JVM
- chargement et linking des classes. nature dynamique de la JVM (permet de changer de JDK)
- génère du code optimisé. Le JIT (optim spéculative) tourne en // de l'application. C1 (rapide), C2 (lent)

Voici une liste des options pour amélirer le temps de démarrage

- Spring Boot - jar extract : 25s -> 19s
- Spring AOT (un goal maven en +) : 19s -> 18s
- CDS = Class Data Sharing : permet de précharger et de partager les métadonnées de classes
- Leyden (à partir de Java 24) : 12s
- Leyden + Spring AOT : 10s
- CraC : capture l'image mémoire d'un processus. seulement pour Linux. Dev par Azul. démarrage ~ 100ms
- Native Image : tps compilation long, pas de reflection, license commercial pour meilleur perf

Attention sur k8s avec limit.cpu < 2

Pour conclure, un petit tableau de recap avec le gain et la simplicité de chaque solution

# Chapter Lead : retour d’XP après 3 ans de mise en place chez BforBank - Arnaud MARY

Passage de 30 devs à 120 devs.

Les missions:
- instaurer et partager les bonnes pratiques
- fluidifier les relations
- support aux squads
- vision tech - gestion du backlog tech
- rayonner autour de nos expertises
- recruter et accompagner nos talents
- veille

# Dans les coulisses des géants de la Tech ! - Rachel Dubois

Je l'avoue, j'ai failli loupé ce talk car il ne m'attirait pas plus que cela. Et
j'ai adoré, un super rythme et des punchlines (j'en cite quelques unes plus
bas). Pour la street cred, Rachel a notamment travaillé chez Spotify et Vinted.

Elle commence par décrire l'illusion de l'agilité. L'équipe fait tout bien (mais des choses inutiles …). On confond vitesse et impact.

> a Product **is not** a list of Jira tickets, it **is not** a roadmap to execute

Elle donne ensuite un ex. chez Spotify où une équipe découvre un drop de 8% sur
une feature. On peut alors transformer un problème en opportunité.

DIBB (data, insight, believe, bet)

L'excellence technique est un pré-requis.

Faire une anti roadmap = la liste des trucs à enlever.

> One refacto a day, keeps doctor at bay.

Faire attention aux retours des utilisateurs :

> Real behaviours trumps declarations every single time.

Elle parle de système circulatoire, toutes les données doivent être accessibles.

Le point commun des big techs : elles ont compris que ce qu'elles font, c'est de la tech !

# Quand le Terminal dévore la UI : TUI pour tout le monde ! - Thierry Chantier

[slides](https://noti.st/titimoby/zKCPXc/quand-le-terminal-devore-la-ui-tui-pour-tout-le-monde)

Commence par données une définition et des exemples : k9s, posting (équivalent de postman)

Thierry va montrer comment développer un TUI dans plusieurs langages
- Java : n'a pas trouvé de librairie ?
- Go : cobra
- Python : typer, meme dev que FastAPI
- Rust : pleins de petits éléments à assembler. clap / ratatui

# Vos requêtes SQL jusqu'à 10000 fois plus rapides, durablement. - Alain Lesage

Alain travaille chez Dalibo, une société de référence dans l'ecosystème PostgreSQL.
Pour l'anecdote, j'ai déjà eu l'occassion de les croiser lors d'une mission à la DGFiP en 2011.

PostgreSQL n'a pas plus de 50% de la même entreprise.

Voici un résumé des takeaways

- autovacuum s'occupe de la maintenance et des stats. aussi possible de vacuum manuel si besoin.
- Indexation couteuse en stockage/écriture mais indispensable en lecture.
- Les différents types d'index
    - monocolonne
    - multicolonne
    - partiel
    - couvrant pour index only scan
    - fonctionnel
- et encore
    - B-Tree, arbre binaire, classique, efficace (probablement 100% de vos index)
    - GIN/GiST : extension PG pour faire du full text search `pg_trgm`
    - BRIN : pour données ordonnées, par ex. un timestamp
- 43 vues de supervision : `pg_stats`
- EXPLAIN ANALYZE
- [explain.dalibo.com](explain.dalibo.com) pour représentation visuelle des plans
- attention aux micro services. Pas d'acidité multi DB (Ne pas faire une DB par service mais faire un schema par service)
- attention aux ORMs qui génèrent des requetes avec beaucoup de jointures. PG calcule tous les plans jusqu'à 8 tables.
- Liens utiles :
    - [Base de connaissance PostgreSQL](https://kb.dalibo.com/)

# BoF Paris Scala User Group: Modélisation de domaines, parlons en.

J'ai assisté au BoF avec Madame, qui m'avait rejoint pour découvrir cet événement dont je parle tant.
C'est un plaisir d'assister à une présentation du PSUG, ça manquait !

Jon et Stéphane nous ont montré comment modéliser son domaine grace au feature
de scala 2 et scala 3 ainsi qu'un panorama des librairies pour améliorer encore
les choses.

En conclusion, ils montrent un recap des features disponible par langage et
montre que Scala a encore 10 ans d'avance.
