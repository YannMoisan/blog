---
title: Devoxx France 2025 - Jour 1
description: Devoxx France 2025 - Jour 1
layout: post
lang: fr
---
# L’Intelligence Artificielle n’existe pas - Luc Julia

Le speaker de la première keynote est Luc Julia, l'inventeur de Siri.
Il commence par un historique qui débute en 1956 avec les réseaux de neurones (modèle statistique) puis en 1960 les systèmes experts (arbre de décision).

Il dit que l'IA de Hollywood, celle de Musk et d'Altman n'existe pas et n'existera jamais. Il parle plutôt d'IAs (au pluriel).

L'IA n'est pas une révolution, c'est juste un outil (à l'instar du marteau).
Le prompt est une révolution car il permet l'accessibilité à tous (100M d'utilisateurs de ChatGPT en seulement 2 mois).

Il termine en parlant d'hallucinations et d'erreurs.
- En avril 2023, un avocat du barreau de New York utilise ChatGPT pour créé une plaidoirie. Les références générées n'existent pas.
- Luc Julia demande aussi sa bio et apprend à chaque fois des trucs sur lui !
- L'université de HK montre une pertinence de 63,4% sur des faits vrais.

La solution est la spécialisation : Le fine tuning ou RAG permet d'atteindre 99%.

Il montre aussi le jailbreaking, qui est une course (besoin d'un prompt toujours plus long), pour obtenir la recette de la bombe.

Il termine sur l'impact. A l'inférence, on utilise de l'énergie, et pour construire le modèle, c'est l'équivalent de villes entières.

# Iceberg: pourquoi devez-vous connaitre ce nouveau format de stockage de données? - Bertrand Paquet

Doctolib est déployé sur AWS.
La plus grosse table, `appointment`, représente 3.5 milliards de lignes et 2.5T de data (index compris)

Démo de la performance de différents outils
- Athena / Glue / S3 (csv). Pb: lent car pas splittable
- Athena / Glue / S3 (1000 csv). Pb: schema change, update

Apache Iceberg est un table format. Les buts d'un table format sont
- le support des transaction ACID
- l'évolution du schema

Refonte de l'archi de stockage à froid (nightly batch jusqu'ici). La nouvelle archi comporte 3 composants
1. PG -> Debezium (comme un replica pour lire le WAL) -> Kafka
2. Sink Kafka -> CDC events
3. CDC events (Iceberg) -> Mirrors tables (Iceberg) avec Spark (MERGED INTO)

Compromis à trouver entre le cout et le délai de rafraichissement

# GitHub Copilot : Aller encore plus loin que la completion de code

Live demo sur une appli view/express.

GitHub Copilot a 3 modes :
- chat: interface de conversation, comme ChatGPT
- multi-edit: permet de modifier les fichiers
- agent: assistant multi étapes

`copilot-instructions.md` utilisé par vscode, github.com et bientôt jetbrains.
ajout de toute la codebase dans le contexte pour le multi-edit.

copilot permet de générer un résumé de la PR, d'analyser une PR. Le mode agent
pour modèle MCP est capable de créer une issue.

# Ne perdez plus vos photos de vacances 🔥🏠🔥 (ou tout autre fichier important) - Denis Germain

[slides](https://blog.zwindler.fr/talks/2025-3-2-1/index.html)

Nos données ont plus de valeur que l'on pense. 3 exemples:
- sa voisine qui a failli perdre 10 ans de photo avec un disque defectueux
- le thésard qui perd sa clé USB dans le train
- un mec qui jeté un disque contenant 750M$ de bitcoin

Le risque se calcule : probabilité * impact

Respecter la stratégie 3-2-1 (3 copies, sur 2 supports différents, avec une copie distante)

Conseil : avoir en plus une copie hors ligne pour le risque de ransomware (chiffrement des disques).

Note: Dropbox n'est pas un service de sauvegarde (car pas offline).

- Service de sauvegarde : [backblaze](https://www.backblaze.com/)
- Appli open-source: restic, [duplicati](https://duplicati.com/) (backup chiffrées, en ligne ou hors ligne, locales ou cloud)

# Apache Arrow, l’analyse de données haute performance et interopérable - Sylvain Wallez

[Slides](https://docs.google.com/presentation/d/e/2PACX-1vRzNDZkA2e5QHZdAoD3Flcm5xF10a-AZ6VmsXIknVRlFZ4hXP1SVh7kR41ACCEQYvAWecgy0Fbf-slE/pub#slide=id.p)

Sylvain est tech lead sur la partie SDK chez Elastic.

Arrow un format orienté colonne, un backend pour Pandas 2.0

Il existe des implémentations dans pleins de langage : Go, Java, TS, Rust, Python, …

zero-copy reads : shared-memory entre Java et Python par ex.

Comparaison avec parquet : parquet est fait pour le stockage (storage), arrow pour le calcul (compute)

Une stack complète est basée sur arrow :

- Arrow: In-memory dataframe
- Arrow IPC: zero-cost data interchange
- Arrow Flight
- Arrow SQL (~ jdbc)
- DataFusion: SQL execution engine
- Ballista: Distributed compute engine

ES\|QL est un nouveau langage de requete apparu dans Elasticsearch 8.11.
Il montre le support d'arrow comme format de sortie de ES\|QL.

Sylvain a aussi ajouté le support d'ES dans DataFusion en développant un [`TableProvider`](https://github.com/swallez/elasticsearch-datafusion-tableprovider) en Rust.
Il est ainsi possible de faire des jointures entre un ES et un PG par ex., et aussi d'ingérer efficacement de gros volumes dans ES.

# Count-Min Sketch, Bloom Filter, TopK: Efficient probabilistic data structures - Raphael De Lio

# À la découverte d’un Ledger, une BDD atypique ! - Erwan GEREEC

Un ledger est un **système d'enregistrement** permettant d'accéder à l'historique
complet et immuable des **transactions** qui y sont effecutées. Il peut être
centralisé (comme une base de données classique) ou décentralisé (comme une
blockain).

Démo du ledger de [Formance](https://www.formance.com/modules/ledger).
Avec Formance, on effectue des transactions entre compte. Un compte est
identifié par un nom et une balance. Une transaction est un transfert d'un
compte source vers un compte destination.

Formance utilise Numscript, un langage de script dédié.

On peut calculer automatiquement des comptes agrégés : `practicien:$ID:patient::factures:impayees`

Il faut partir de vos besoins métiers pour déterminer la structure des comptes à
mettre en place.

Sandbox gratuite pour essayer.

Liens utiles : https://stripe.com/blog/ledger-stripe-system-for-tracking-and-validating-money-movement

# Be more productive with IntelliJ IDEA - Marit van Dijk

[talk](https://maritvandijk.com/presentations/developer-productivity-in-intellij-idea/)

En vrac:
- Shift Shift : Search Everywhere
- Alt+Enter pour corriger les erreurs
- F2 va à la prochaine erreur
- surround with if statement
- Cmd+J live template
- Check regexp
- Explain regexp fragment
- [Junie](https://www.jetbrains.com/junie/), un agent pour déléguer ses tâches
