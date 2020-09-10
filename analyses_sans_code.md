Traitement des données issues du document partagé pour l’Annexe 4
================

  - [Exploitation des données](#exploitation-des-données)
      - [Premiers indicateurs](#premiers-indicateurs)
          - [Projets](#projets)
          - [Production de connaissances](#production-de-connaissances)
              - [Quantification de la
                production](#quantification-de-la-production)
              - [Revues scientifiques](#revues-scientifiques)
              - [Nombre de citations](#nombre-de-citations)
          - [Partenariats](#partenariats)
              - [Interdisciplinarité proche
                (interne)](#interdisciplinarité-proche-interne)
              - [Interdisciplinarité éloignée
                (externe)](#interdisciplinarité-éloignée-externe)
      - [Graphes supplémentaires (intro du
        rapport)](#graphes-supplémentaires-intro-du-rapport)
          - [RH](#rh)
          - [Ressources](#ressources)
          - [Profil de l’UR](#profil-de-lur)
      - [Reste à faire](#reste-à-faire)

# Exploitation des données

## Premiers indicateurs

### Projets

> **NB : Il y a un projet international (le seul) à la fin inconnue…
> Donc par défaut j’ai décidé la fin en 2024 pour ne pas changer la tête
> du graphique tout en conservant l’info qu’il y a un projet
> international.**

Nous pouvons dans un premier temps représenter graphiquement la
chronologie des contrats :

<img src="analyses_sans_code_files/figure-gfm/unnamed-chunk-4-1.png" width="100%" />

Et dénombrer le nombre de contrats pour lesquels ETBX est porteur ou
non, ainsi que les types de contrats :

<div class="kable-table">

| porteur     |  n |
| :---------- | -: |
| Porteur     | 51 |
| Non porteur | 29 |

</div>

<div class="kable-table">

| type          |  n |
| :------------ | -: |
| Européen      |  5 |
| International |  1 |
| National      | 52 |
| PIA           | 15 |
| R\&D          |  7 |

</div>

Nous pouvons aussi compter combien de contrats **commencent** chaque
année (NB: et qui sont encore en cours sur la période 2017-2020, les
contrats qui débutent avant 2017 mais qui ont pris fin avant 2017 ne
sont pas comptabilisés).

<div class="kable-table">

| type          | 2013 | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 |
| :------------ | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Européen      |    0 |    0 |    0 |    1 |    1 |    3 |    0 |
| International |    0 |    0 |    0 |    0 |    0 |    0 |    1 |
| National      |    4 |    2 |    7 |   14 |    8 |    6 |   11 |
| PIA           |    0 |    0 |    2 |    1 |    2 |    2 |    8 |
| R\&D          |    0 |    0 |    2 |    0 |    2 |    0 |    3 |

</div>

Et combien **finissent** chaque année, à partir de 2017 :

<div class="kable-table">

| type          | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 |
| :------------ | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Européen      |    0 |    0 |    3 |    1 |    0 |    1 |    0 |    0 |    0 |
| International |    0 |    0 |    0 |    0 |    0 |    0 |    1 |    0 |    0 |
| National      |    4 |    6 |   11 |    9 |    8 |    8 |    3 |    1 |    2 |
| PIA           |    0 |    0 |    6 |    5 |    3 |    1 |    0 |    0 |    0 |
| R\&D          |    0 |    2 |    2 |    0 |    2 |    0 |    0 |    1 |    0 |

</div>

Nous pouvons enfin quantifier, chaque année, combien de projets sont
**en cours** (NB: Pour les années antérieures à 2017, seuls les contrats
prenant fin à partir de 2017 sont comptabilisés).

<div class="kable-table">

| type          | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 |
| :------------ | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Européen      |    0 |    0 |    1 |    2 |    5 |    5 |    2 |
| International |    0 |    0 |    0 |    0 |    0 |    1 |    1 |
| National      |    6 |   13 |   27 |   35 |   37 |   42 |   31 |
| PIA           |    0 |    2 |    3 |    5 |    7 |   15 |    9 |
| R\&D          |    0 |    2 |    2 |    4 |    4 |    5 |    3 |

</div>

### Production de connaissances

#### Quantification de la production

Nous étudions dans un premier temps le nombre d’articles, d’actes de
colloques et de chapitres d’ouvrages publiés par des agents de l’unité.

<div class="kable-table">

| Type               | 2017 | 2018 | 2019 | 2020 |
| :----------------- | ---: | ---: | ---: | ---: |
| Articles           |   41 |   30 |   28 |   26 |
| Autres articles    |    6 |    3 |    2 |    2 |
| Actes colloques    |   13 |   14 |   18 |    1 |
| Chapitres ouvrages |    6 |   14 |    5 |   15 |

</div>

Production en langue anglaise : **68** articles scientifiques et **11**
chapitres d’ouvrages.

#### Revues scientifiques

En ce qui concerne les revues, voici un nuage des revues auxquelles sont
soumis les articles scientifiques :

![](img/wordcloud_revues_simple.png)

Nous pouvons ensuite observer si notre unité est bien identifiée dans
les revues dans lesquelles elle publie :

Nous pouvons représenter ces deux variables (nombre de publications /
nombre de relectures) sur un même graphique. Dans un soucis de
lisibilité, nous ne conservons que les revues pour lesquelles la
différence entre les deux variables est supérieure à 1.

<img src="analyses_sans_code_files/figure-gfm/unnamed-chunk-13-1.png" width="100%" />

#### Nombre de citations

L’information du nombre de citations n’est évidemment pas indiqué dans
le document excel.

Il est cependant possible de récupérer cette information via le portail
HAL-INRAE. Ceci implique de travailler, forcément, avec un nombre réduit
de publications par rapport au document excel.

Un export de la base HAL a donc été réalisé avec ces deux critères :

  - Année 2017-2020

  - Unité = ETBX

A partir de cet export HAL-INRAE, nous récupérons 90 DOI, que nous
utilisons pour extraire sur scopus le nombre de citations pour chacun de
ces documents.

Cette requête a permis de récupérer des données de citations pour **52**
articles. Voici donc, à ce jour, le nombre de citations pour ces
articles en fonction de leur année de publication :

<div class="kable-table">

| Année | n\_citations |
| ----: | -----------: |
|  2017 |           78 |
|  2018 |           93 |
|  2019 |           20 |
|  2020 |            8 |

</div>

### Partenariats

#### Interdisciplinarité proche (interne)

A partir du tableau rempli par l’équipe du GT4, nous pouvons créer une
liste de noms d’auteurs (prenant en compte toutes les syntaxes possibles
d’un même nom) appartenant à ETBX.

Chacun des agents ETBX a aussi été affecté à une discipline, en accord
avec les informations présentées sur le site web de l’unité
<https://www6.bordeaux-aquitaine.inrae.fr/etbx/Les-equipes>.

(Fichier : `table_auteurs_ETBX_2020-08-17_BH.xlsx`).

Nous pouvons donc quantifier le nombre d’auteurs ETBX pour chaque
production scientifique (comprenant les articles scientifiques et les
chapitres d’ouvrages) :

<div class="kable-table">

| Nombre de co-auteurs ETBX sur une production scientifique | Fréquence |
| --------------------------------------------------------: | --------: |
|                                                         2 |        38 |
|                                                         3 |        18 |
|                                                         4 |         7 |
|                                                         5 |         4 |
|                                                         6 |         2 |

</div>

Avec l’information du nombre de co-auteurs, nous pouvons corriger le
nuage de revues précédent en le pondérant par le nombre moyen de
co-auteurs ETBX par publication pour chaque revue.

![Nombre moyen de co-auteurs par publication par
revue](img/wordcloud_revues_pondere.png)

Grâce à la classification JCR (<https://jcr.clarivate.com>) nous pouvons
classer les revues selon des grandes catégories disciplinaires. Ci
dessous un tableau des 48 revues pour lesquelles une correspondance de
catégorie a pu être récupérée.

Voici donc le résumé du nombre de publications par catégorie JCR :

<img src="analyses_sans_code_files/figure-gfm/unnamed-chunk-20-1.png" width="100%" />

Nous pouvons maintenant nous intéresser aux disciplines. Nous pouvons
dénombrer le nombre de disciplines mobilisées pour chaque production
scientifique (comprenant les articles scientifiques et les chapitres
d’ouvrages) :

<div class="kable-table">

| Nombre de disciplines impliquées sur une production scientifique | Fréquence |
| ---------------------------------------------------------------: | --------: |
|                                                                2 |        35 |
|                                                                3 |         5 |
|                                                                4 |         2 |

</div>

Autre indicateurs:

  - Il y a **27** publications avec \> 2 agents ETBX mais où ces agents
    sont de la **même discipline**.
  - Il y a **68** publications où **un seul** agent ETBX est impliqué.

#### Interdisciplinarité éloignée (externe)

Cette section nécessite de disposer d’informations sur les affiliations
des co-auteurs. Cette information n’est malheureusement pas accessible
directement via le tableau excel (stratus) rempli par les collègues.

Il est cependant possible de récupérer une partie de ces informations
via HAL-INRAE. Ceci implique de travailler, forcément, avec un nombre
réduit de publications.

Un export de la base HAL a été réalisé avec ces deux critères :

  - Année 2017-2020

  - Unité = ETBX

Et nous obtenons le nombre d’entrées suivant :

<div class="kable-table">

| Type      |   N |
| :-------- | --: |
| ART       | 118 |
| COMM      | 153 |
| COUV      |  28 |
| DOUV      |   1 |
| HDR       |   5 |
| LECTURE   |   1 |
| MEM       |   7 |
| OUV       |   6 |
| POSTER    |   4 |
| REPORT    |  25 |
| THESE     |   4 |
| UNDEFINED |   1 |

</div>

Sur les **146** entrées (Articles + Chapitres d’ouvrages) récupérées
dans la base HAL, nous obtenons **282** structures différentes avec
lesquelles ETBX co-publie des articles scientifiques ou des chapitres
d’ouvrages. A partir des données extraites de ces documents, un
premier travail de catégorisation manuelle de nos partenaires a été
entamé par le GT (B. Rulleau), mais ne donne pour le moment pas
suffisamment d’informations pour pousser l’analyse avec ces données.

(Fichier : `Structures_Collab.xlsx`).

Ci dessous les 10 pays avec lesquels nous collaborons avec le plus de
labos (ex : 12 labos UK, 9 labs allemands, etc.)

<div class="kable-table">

| pays |  n |
| :--- | -: |
| UK   | 12 |
| DE   |  9 |
| FI   |  8 |
| AT   |  6 |
| BE   |  6 |
| CA   |  6 |
| NL   |  6 |
| ZA   |  6 |
| IT   |  5 |
| RO   |  5 |

</div>

Ensuite, nous supposons que la possibilité d’attribuer un sigle à la
structure permettait d’identifier la plupart des gros labos avec
lesquels on travaille. Ainsi, on dénombre **203** sigles uniques de
labos avec lesquels nous co-publions.

Les structures avec lesquelles on co-publie majoritairement (n copubli
\>5)

<div class="kable-table">

| structure                                                                                        |   n |
| :----------------------------------------------------------------------------------------------- | --: |
| Institut national de recherche en sciences et technologies pour l’environnement et l’agriculture | 228 |
| Environnement, territoires et infrastructures                                                    | 146 |
| Centre National de la Recherche Scientifique                                                     |  52 |
| Institut National de Recherche pour l’Agriculture, l’Alimentation et l’Environnement             |  27 |
| AgroParisTech                                                                                    |  15 |
| Institut National de la Recherche Agronomique                                                    |  14 |
| Université de Bordeaux                                                                           |  14 |
| Centre de Coopération Internationale en Recherche Agronomique pour le Développement              |  10 |
| Institut national d’études supérieures agronomiques de Montpellier                               |  10 |
| École des hautes études en sciences sociales                                                     |   8 |
| Ecole Nationale Supérieure des Sciences Agronomiques de Bordeaux-Aquitaine                       |   8 |
| 3S Consult GmbH                                                                                  |   7 |
| École Nationale du Génie de l’Eau et de l’Environnement de Strasbourg                            |   7 |
| École des Ponts ParisTech                                                                        |   6 |
| Gestion Territoriale de l’Eau et de l’environnement                                              |   6 |
| Université de Montpellier                                                                        |   6 |
| Université Sciences et Technologies - Bordeaux 1                                                 |   6 |
| Université Toulouse - Jean Jaurès                                                                |   6 |
| University of Adelaide                                                                           |   6 |

</div>

## Graphes supplémentaires (intro du rapport)

### RH

<img src="analyses_sans_code_files/figure-gfm/unnamed-chunk-28-1.png" width="100%" />

### Ressources

<img src="analyses_sans_code_files/figure-gfm/unnamed-chunk-29-1.png" width="100%" />

<img src="analyses_sans_code_files/figure-gfm/unnamed-chunk-30-1.png" width="100%" />

### Profil de l’UR

<img src="analyses_sans_code_files/figure-gfm/unnamed-chunk-31-1.png" width="100%" />

## Reste à faire

  - [ ] Remplir le document word
  - [ ] Représentation ‘Réseau’ des collaborations (internes et
    externes) ?
