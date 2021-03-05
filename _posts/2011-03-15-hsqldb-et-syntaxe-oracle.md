---
title: HSQLDB et syntaxe Oracle
description: Utilisation de la base HSQLDB avec la syntaxe Oracle
layout: blog
---
## La problématique

Nous utilisons Oracle en production et HSQLDB pour les tests unitaires. Ces deux produits
n'utilisent pas toujours la même syntaxe SQL. À titre d'exemple, voici la syntaxe pour récupérer la
prochaine valeur d'une séquence. 
Avec HSQL :

```
SELECT […] NEXT VALUE FOR <sequencename> […] FROM <tablename>;
```

Avec Oracle :

```
SELECT <sequencename>.NEXTVAL FROM dual;
```

## La nouvelle fonctionnalité de HSQLDB 2.0

HSQLDB offre depuis la version 2.0 le support partiel de la syntaxe Oracle, en ajoutant simplement
la propriété `sql.syntax_ora=true` sur l'URL de connexion. Cela permet d'utiliser les mêmes requêtes
SQL pour les tests unitaires et la production. Les premiers tests sont concluants…

## Un bug…

Malheureusement, notre cas d'utilisation ne fonctionne pas : utilisation d'une séquence dans la
requête d'insertion. Après une vaine recherche sur le forum du projet, je décide de poster [un
message](http://sourceforge.net/projects/hsqldb/forums/forum/73674/topic/4400421) (ce qui passe par
la création d'un compte SourceForge). Et un peu moins de 3 heures plus tard, le bug est fixé. La
correction sera disponible dans la version snapshot du lendemain. Un grand bravo à Fred Toussi pour
sa réactivité.

## Conclusion

Cela montre bien la force de l'open source, notamment pour les projets ayant une communauté très
active.
