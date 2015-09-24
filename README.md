# roleplay.pixelastic.com

This project is using both Brunch and Jekyll.

## Build process explained

Jekyll sources are in `app/jekyll` and gets built in `app/assets`. Brunch
listens to this dir and copy and change to `public`. It also listens for `css`
and `js` files changes in `app/styles` and `app/scripts` to send them in
`public`.


## What I learned

Pris Jekyll, parce que connais bien. Pas essayé Middleman ou autre là. Je sais
pas trop si je vais faire des pages, des posts, des datas. Mais Jekyll, sur.


This is a PR test

Petit projet, peu de pages, mais un but final de hoster les enregistrements
audio des parties de jeu de role. Avance doucement mais surement, veut faire le
mieux à chaque fois.

Voulu aussi essayer Brunch tant qu'à faire pour compresser assets, etc. Brunch
suit des conventions, copie tout ce qui se trouve dans `assets`. Jekyll override
tout son fichier dest. Pour faire fonctionner les deux, je mets tout mon code
"statique" (html, images, fonts) dans `jekyll`, je le build dans `assets` et
brunch s'occupe de le passer dans public.

J'ai aussi voulu arreter avec Bootstrap, car trop de bloat, mais voulais un truc
chouette. Ai donc essayé Bourbon/Neat/Bitters/Refills. S'installe avec Ruby mais
installation dans un dossier. Ai créé un `npm run install-dependencies` pour
faire ça tout seul.

J'ai utilisé comme base ce que Refills proposait, ça me faisait une belle page
à peu de frais. Mais les exemples sont outdated (Deprecation warnings dessus) et
encore trop de markup, du coup j'ai réécrit. J'ai aussi testé la méthode de
nommage de CSSWizardy qui me semble vraiment bien.

Voulait aussi normalize.css, mais pas le commiter. L'ai pris dans node_modules,
mais pour l'inclure direct dans le même fichier, need de l'avoir en fichier
scss. Syntaxe retro-compatible, du coup un simple copie du node_modules vers mon
dossier de scss vendors.

Same pour FontAwesome. Ils ont une version SCSS et j'ai besoin que de peu
d'icones. Du coup j'ai installé avec node, copié le tout dans mes vendors et
inclue seulement les mixins dont j'avais besoin. ien fait avec un système de
variables donc juste à changer le path et pas besoin de loader du css inutile.


Eu besoin de la police de caractere de Warhammer. Quelques recherches, Calson
Antique, partie d'un groupe de 1001 free fonts. Un coup dans Font Squirrel pour
avoir la bonne syntaxe pour inclure et hop. Celle là je la commit dans le repo.

Besoin d'une image pour ma page. J'en trouve une sympa avec une recherche
google. Mais impossible de trouver l'auteur pour le moment, il faut que je
m'assure que libre pour mon utilisation.

k

