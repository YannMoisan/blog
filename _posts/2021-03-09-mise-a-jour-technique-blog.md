---
title: Mise à jour technique de mon blog
description: J'ai mis à jour le système d'exploitation Ubuntu, configurer HTTPS et HTTP/2, améliorer la sécurité et les performances et changer le générateur de contenu statique.
layout: post
lang: fr
---
## Un nouvel hébergeur

Souvenez-vous, [mon blog est hébergé sur un VPS](/hebergement.html). C'est donc à moi de maintenir le système à jour. Et vu que l'OS est encore un Ubuntu 16.04, 
je ne l'avais pas fait depuis longtemps. La mise à jour ne fonctionne pas, je décide donc de réinstaller via l'interface web
de mon fournisseur. Et c'est là que les ennuis commencent. Ubuntu 20.04 refuse de s'installer et le support technique est catastrophique.

Je suis donc contraint de changer de fournisseur. Je continue de soutenir la _french tech_ et choisis [OVH](https://www.ovh.com/fr/).
J'ai choisi l'offre la moins chère : VPS Starter (1 vCPU 2 GB RAM 20 GB disk) pour 3,6 € par mois. Après quelques minutes, j'ai un nouveau
serveur fraichement installé avec Ubuntu 20.04.

## La configuration SSH
Juste après l'installation, je fais la configuration minimale pour SSH :
- je change le port par défaut du serveur SSH pour réduire radicalement les attaques de _bots_. 
  `journalctl` montre que ces erreurs disparaissent. 
```
sshd[2823]: Invalid user admin from 186.89.246.141 port 24850
sshd[2823]: pam_unix(sshd:auth): check pass; user unknown
sshd[2823]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=186.89.246.141
sshd[2823]: Failed password for invalid user admin from 186.89.246.141 port 24850 ssh2
sshd[2823]: Connection closed by invalid user admin 186.89.246.141 port 24850 [preauth]
```  
- je mets à jour l'entrée pour mon VPS dans `~/.ssh/config` (avec le nouveau port)
- je copie ma clé SSH sur le serveur avec `ssh-copy-id` pour me connecter sans mot de passe

## La configuration NGINX
J'utilise la configuration par défaut pour `/etc/nginx/nginx.conf`. Je dois juste :
- copier [la config du blog](https://github.com/YannMoisan/blog/blob/master/nginx/blog) dans `/etc/nginx/sites-available/blog` 
- ajouter le lien symbolique vers `/etc/nginx/sites-enabled`
- copier le contenu statique dans `/var/www/yannmoisan.com`
  - créer le répertoire : `sudo mkdir -p /var/www/yannmoisan.com`
  - changer le propriétaire : `sudo chown ubuntu:ubuntu /var/www/yannmoisan.com`
  - synchroniser le contenu : `rsync -a _site/ blog:/var/www/yannmoisan.com`
- recharger nginx : `systemctl reload nginx`

## HTTPS
Mon site n'était pas disponible en HTTPS. J'ai suivi la documentation pour utiliser [Let's encrypt avec NGINX](https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/).
L'outil modifie la configuration NGINX; le traffic HTTP est ainsi redirigé en HTTPS. Le cadenas dans le navigateur montre bien que tout fonctionne.

## HTTP/2
HTTPS est un prérequis pour HTTP/2. J'ai donc pu l'activer simplement en modifiant la ligne `listen 443 ssl;` par `listen 443 ssl http2;`

## Sécurité
Le site [webpagetest](https://webpagetest.org) permet de tester la performance de son site. Ma note en sécurité est F.
DigitalOcean offre [un outil pour configurer nginx](https://www.digitalocean.com/community/tools/nginx). J'ai recopié les valeurs
de `security.conf` qui permettent d'ajouter des _headers_ de sécurité.

On peut utiliser `httpie` pour vérifier 

```
❯ http https://www.yannmoisan.com
HTTP/1.1 200 OK
...
Content-Security-Policy: default-src 'self' http: https: data: blob: 'unsafe-inline'
Referrer-Policy: no-referrer-when-downgrade
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
```

Ma note est maintenant A+.

## Performance
webpagetest a aussi détecté un problème sur le cache des fonts et un problème sur la compression de certains fichiers. 

Après les correctifs, voici l'évolution des différents scores :

| |Security score|First Byte Time|Keep-alive Enabled|Compress Transfer|Compress Images|Cache static content|
|---|---|---|---|---|---|---|
|avant|F|B|A|C|A|C|
|après|A+|A|A|A|A|A|

Vous pouvez consulter [le résultat](https://webpagetest.org/result/210309_AiB3_d67682d3e764a6cff8a772ad588e4583/).

lighthouse est un autre outil populaire. Vous pouvez tester votre site sur [web.dev](https://web.dev/measure/).
Un problème remonté est [render-blocking resources](https://web.dev/render-blocking-resources/). Pour résoudre cela, j'ai hébergé les fonts google sur mon serveur comme recommandé 
[ici](https://sia.codes/posts/making-google-fonts-faster/) ou 
[là](https://wpspeedmatters.com/self-host-google-fonts/).
La métrique _First Contentful Paint_ est ainsi passé de 2.5 s à 1 s


## Migration à jekyll
Mon blog était généré par un script shell maison. Même si cela était intéressant à faire, le code est devenu peu lisible
et peu maintenable. Il existe aujourd'hui de nombreux générateurs de sites statiques et j'ai migré sur une solution éprouvée : [jekyll](https://jekyllrb.com/) 
et ainsi soigner un peu mon syndrome [NIH](https://en.wikipedia.org/wiki/Not_invented_here).

Jusqu'ici, j'écrivais mes articles en HTML. Ce qui est pénible à la longue. Jekyll supportant HTML et Markdown, j'ai migré
tous mes posts en Markdown avec l'aide de `pandoc`.

Et pour finir, j'ai opté pour le thème par défaut : minima. Le site s'affiche mieux sur mobile (à croire que le dev front est un vrai métier).

## URL canonique
Mon site était disponible à travers ces 2 urls : [http://www.yannmoisan.com](http://www.yannmoisan.com) et 
[http://yannmoisan.com](http://yannmoisan.com). 
Le support de HTTPS a encore ajouté deux nouvelles variantes : [https://www.yannmoisan.com](http://www.yannmoisan.com) et
[https://yannmoisan.com](http://yannmoisan.com). Afin d'aider les moteurs de recherche à ne pas détecter ces contenus 
comme dupliqués, j'ai déclaré une URL canonique sur chaque page.

```
<link rel="canonical" href="https://www.yannmoisan.com/foo.html"/>
```

L'impact devrait être visible dans la [google search console](https://search.google.com/search-console).

## Problèmes restants
- l'administration du système m'incombe (mise à jour des paquets, …)
- la configuration du serveur est manuelle (elle pourrait être automatisée avec ansible par ex.)
- il n'y a pas de haute disponibilité. Mon site est inaccessible lors d'un incident comme l'[incendie du 10/03/2021.](https://www.lemonde.fr/societe/article/2021/03/10/a-strasbourg-un-important-incendie-sur-le-site-de-l-entreprise-ovh-classe-seveso_6072548_3224.html).
  
> Nous faisons actuellement face à un incident majeur au sein de notre datacentre de Strasbourg, avec un feu déclaré dans le bâtiment SBG2.

- il y a peu de monitoring

## Liens

- [un guide complet pour utiliser nginx pour un site statique [en]](https://jgefroh.medium.com/a-guide-to-using-nginx-for-static-websites-d96a9d034940)
- [sécuriser un VPS - OVH [fr]](https://docs.ovh.com/fr/vps/conseils-securisation-vps/)