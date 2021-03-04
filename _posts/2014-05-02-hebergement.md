---
title: Hébergement sur un serveur dédié
description: Les étapes à suivre pour passer d'un hébergement chez un prestataire web vers un hébergement sur son serveur dédié
layout: blog
---
Jusqu'ici, ce site était hebergé chez [hebergement-gratuit](http://www.hebergement-gratuit.com/),
qui offre un hébergement totalement gratuit, sans publicité. Le service est de bonne qualité, mais
limité. Tout d'abord, ce prestataire impose l'utilisation de ses serveurs DNS. Il faut donc
configurer une délégation DNS, ce qui se fait sans problème chez [Gandi](http://www.gandi.net), mon
registar.

```
DNS PRIMAIRE (name server) ns1.hebergement-gratuit.com
DNS SECONDAIRE ns2.hebergement-gratuit.com
DNS SECONDAIRE ADDITIONNEL ns3.slconseil.com
```

La mise à jour du site passe obligatoirement par le protocole FTP.

Voici donc les limites qui, à la longue, peuvent devenir dérangeant pour un usage avancé :

-   impossible de configurer son serveur web (pour activer la compression gzip, configurer le cache,
    par exemple)
-   impossible de configurer les redirections mail
-   impossible d'avoir un compte SSH sur le serveur (pour synchroniser le contenu avec rsync, par
    exemple)
-   impossible de configurer un sous domaine au niveau DNS

J'ai donc décidé d'heberger sur mon serveur dédié. Pour la partie DNS, il suffit de reconfigurer les
DNS de Gandi et de modifier son fichier de zone pour pointer vers l'IP de son serveur (via les
enregistrements de type A qui établissent le lien entre un nom et une adresse IPv4). Gandi permet de
faire cela à travers une interface web. Voici les lignes modifiées :

```
nom    type valeur
@       A   195.154.118.138
www     A   195.154.118.138
```

Pour la partie serveur, il suffit d'installer un serveur web, comme [nginx](http://nginx.org/).

## Liens

-   [Wiki sur la configuration des DNS sur le site de Gandi.](https://wiki.gandi.net/fr/dns)
-   [setting-up-http-cache-and-gzip-with-nginx](http://aspyct.org/blog/2012/08/20/setting-up-http-cache-and-gzip-with-nginx/)

