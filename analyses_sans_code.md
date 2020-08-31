Traitement des données issues du document partagé pour l’Annexe 4
================

  - [Point du 24/07 sur les objectifs](#point-du-2407-sur-les-objectifs)
      - [Vision d’ensemble du fichier](#vision-densemble-du-fichier)
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
      - [Reste à faire](#reste-à-faire)

# Point du 24/07 sur les objectifs

**Objectif**: Définir des extractions pertinentes (indicateurs, Figures,
tableaux) pour alimenter la rédaction du rapport

Travail au niveau Global UR / dans un second temps par axe.

Plusieurs volets à exploiter :

  - **Production de connaissances**
    
      - Articles (ACL ou non)
      - Chapitres d’ouvrages
      - Identification dans les revues

  - **Production “appliquée”**
    
      - Rapports scientifiques
      - Vulgarisation
      - Travail sur les partenaires économiques

  - **Partenariats**
    
      - Travail sur les co-publications au sein de l’UR (réseau?) et
        catégorisation manuelle des disciplines de chaque agent.
      - Travail sur les co-publications avec d’autres labos (les labos
        sont donc à catégoriser également)

> NB : Interdisciplinaire = SHS / SE / SPI

Objectif à court terme : Production d’indicateurs généraux, synthétiques
pour chaque onglet du document excel.

**Envoi le 24/07 d’un dernier mail de rappel pour demander l’ajout
d’articles qui seraient acceptés avec modifications mineures à ce jour
(et seulement mineures) et rappel pour les derniers retardataires. Ajout
d’une colonne ‘révision’ à cocher pour ces cas spécifiques. Cela
concerne publications + ouvrages.**

## Vision d’ensemble du fichier

Voici un tableau récapitulatif de la dimension des onglets, triés selon
le nombre de lignes (on ne présente ici que les 10 onglets contenants le
plus de lignes).

<div class="kable-table">

| Onglet                         | nb\_lignes | nb\_colonnes |
| :----------------------------- | ---------: | -----------: |
| i\_3\_autres\_produits\_colloq |        136 |            6 |
| i\_1\_articles\_sctfq          |        125 |            7 |
| ii\_3\_particip\_instances     |         86 |            3 |
| i\_8\_evaluation\_articles     |         83 |            3 |
| iii\_3\_enseignement           |         53 |            8 |
| ii\_3\_rapports\_expertise     |         48 |            6 |
| i\_8\_responsab\_instances     |         46 |            5 |
| i\_3\_articles\_actes\_colloq  |         46 |            7 |
| i\_2\_chap\_ouvrages           |         44 |            6 |
| iii\_3\_formation              |         42 |            8 |

</div>

# Exploitation des données

## Premiers indicateurs

### Projets

> **NB : Il y a un projet international (le seul) à la fin inconnue…
> Donc par défaut j’ai décidé la fin en 2024 pour ne pas changer la tête
> du graphique tout en conservant l’info qu’il y a un projet
> international.**

Nous pouvons dans un premier temps représenter graphiquement la
chronologie des contrats :

<img src="analyses_sans_code_files/figure-gfm/unnamed-chunk-5-1.png" width="100%" />

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

**NB : Nous notons qu’il semble y avoir un biais assez important entre
“contrat” et “projet” : Un même projet peut faire l’objet de plusieurs
contrats à différentes temporalités (ex : LYRE, TREFOR, etc.) et / ou
pour lesquels ETBX est parfois porteur, parfois non (ex : JUSTBAUX)**

**NB2 : Il semble également y avoir un biais sur la catégorie
“National”, qui inclut à la fois des projets régionaux et des ANR.
Il serait probablement intéressant de réaliser un focus sur les projets
nationaux (au nombre de 52) afin de les catégoriser “manuellement” plus
finement : PSDR / ANR, etc.**

### Production de connaissances

#### Quantification de la production

Nous étudions dans un premier temps le nombre d’articles, d’actes de
colloques et de chapitres d’ouvrages publiés par des agents de l’unité.

<div class="kable-table">

| Type               | 2017 | 2018 | 2019 | 2020 |
| :----------------- | ---: | ---: | ---: | ---: |
| Articles           |   41 |   30 |   28 |   22 |
| Autres articles    |    6 |    3 |    2 |    2 |
| Actes colloques    |   13 |   14 |   18 |    1 |
| Chapitres ouvrages |    6 |   14 |    5 |   15 |

</div>

Il y a **68** articles scientifiques et **11** chapitres d’ouvrages en
langue anglaise.

#### Revues scientifiques

En ce qui concerne les revues, voici un nuage des revues auxquelles sont
soumis les articles scientifiques :

![](wordcloud_1.png)

Nous pouvons ensuite observer si notre unité est bien identifiée dans
les revues dans lesquelles elle publie :

Nous pouvons représenter ces deux variables (nombre de publications /
nombre de relectures) sur un même graphique. Dans un soucis de
lisibilité, nous ne conservons que les revues pour lesquelles la
différence entre les deux variables est supérieure à 1.

<img src="analyses_sans_code_files/figure-gfm/unnamed-chunk-14-1.png" width="100%" />

Et voici une version alternative avec l’une des variables passée en
négatif afin de mieux distinguer les deux variables :

<img src="analyses_sans_code_files/figure-gfm/unnamed-chunk-15-1.png" width="100%" />

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

    ##   [1] "Aka, J"              "André, C"            "Aouadi N"           
    ##   [4] "Assouan, E"          "Aubrun, C"           "Ayala Cabrera, D"   
    ##   [7] "Banos, V"            "Banos, V."           "Bernard, P"         
    ##  [10] "Boschet C"           "Boschet, C"          "Bouet B"            
    ##  [13] "Bouet, B"            "Bouleau, G"          "Bouleau, G."        
    ##  [16] "Brahic, E"           "Brahic, E."          "Braun, M"           
    ##  [19] "Brun, C"             "Caillaud, K."        "Candau, J"          
    ##  [22] "Candau, J."          "Carayon, D"          "Carreira, A."       
    ##  [25] "Carter, C"           "Carter, C."          "Cazals, C"          
    ##  [28] "Chambon, C"          "Cholet, L"           "Conchon, P."        
    ##  [31] "Dachary Bernard, J"  "Dachary Bernard, J." "Dachary-Bernard, J" 
    ##  [34] "Dachary-Bernard, J." "De Godoy Leski, C"   "de Rouffignac A."   
    ##  [37] "de Rouffignac, A"    "de Rouffignac, A."   "Dehez J"            
    ##  [40] "Dehez J."            "Dehez, J"            "Dehez, J."          
    ##  [43] "Del'homme B"         "Del'homme, B"        "Del'homme, B."      
    ##  [46] "Deldrève V."         "Deldreve, V"         "Deldrève, V"        
    ##  [49] "Deldreve, V."        "Deldrève, V."        "Deuffic, P"         
    ##  [52] "Deuffic, P."         "Diaw, M"             "Esparon, S."        
    ##  [55] "Fisnot, C"           "Gassiat A"           "Gassiat, A"         
    ##  [58] "Gassiat, A."         "Giard, A"            "Gilbert, D"         
    ##  [61] "Ginelli L"           "Ginelli, L"          "Ginelli, L."        
    ##  [64] "Ginter Z."           "Ginter, Z"           "Girard, S"          
    ##  [67] "Girard, S."          "Gremmel, J"          "Gremmel, J."        
    ##  [70] "Hautdidier B"        "Hautdidier, B"       "Hautdidier, B."     
    ##  [73] "Husson, A"           "Husson, A."          "Joalland, O"        
    ##  [76] "Kerouaz, F"          "Kerouaz, F."         "Krasnodębski M."    
    ##  [79] "Krasnodębski, M."    "Krieger, S.J"        "Kuentz Simonet, V"  
    ##  [82] "Kuentz-Simonet V"    "Kuentz-Simonet, V"   "Labbouz B"          
    ##  [85] "Labenne, A"          "Lafon, S."           "Large, A"           
    ##  [88] "Latimier, A-C."      "Le Floch S"          "Le Floch, S"        
    ##  [91] "Le Floch, S."        "Le Gat, Y"           "Le Gat, Y."         
    ##  [94] "Leccia Phelpin, O"   "Leccia-Phelpin, O"   "Leccia, O"          
    ##  [97] "Leccia, O."          "Legat, Y."           "Lemarié Boutry, M"  
    ## [100] "Lescot J-M."         "Lescot J.-M"         "Lescot, J.M"        
    ## [103] "Lescot, J.M."        "Lyser S."            "Lyser, S"           
    ## [106] "Lyser, S."           "Macary F"            "Macary, F"          
    ## [109] "Macary, F."          "Mainguy, G"          "Marquet V"          
    ## [112] "Marquet, V"          "Petit, K"            "Petit, K."          
    ## [115] "Pham, T"             "Piller O"            "Piller, O"          
    ## [118] "Piller, O."          "Pillot, J"           "Rambolinaza, T."    
    ## [121] "Rambonilaza T"       "Rambonilaza T."      "Rambonilaza, M"     
    ## [124] "Rambonilaza, T"      "Rambonilaza, T."     "Renaud, E"          
    ## [127] "Renaud, E."          "Rocle N"             "Rocle N."           
    ## [130] "Rocle, N"            "Rocle, N."           "Roussary, A."       
    ## [133] "Rulleau, B"          "Rulleau, B."         "Salles D"           
    ## [136] "Salles, D"           "Salles, D."          "Scordia, C"         
    ## [139] "Scordia, C."         "Sergent, A"          "Sergent, A."        
    ## [142] "Stricker, A. E"      "Stricker, A. E."     "Stricker, A.E"      
    ## [145] "Stricker, A.E."      "Terreaux, J.P"       "Terreaux, J.P."     
    ## [148] "Thomas, A."          "Tomasian, M"         "Ung, H"             
    ## [151] "Uny, D"              "Vacelet, A"          "Vernier F"          
    ## [154] "Vernier F."          "Vernier, F"          "Vernier, F."        
    ## [157] "Zahm F."             "Zahm, F"             "Zahm, F."

Chacun des agents ETBX a aussi été affecté à une discipline, en accord
avec les informations présentées sur le site web de l’unité
<https://www6.bordeaux-aquitaine.inrae.fr/etbx/Les-equipes>.

(Fichier : `table_auteurs_ETBX_2020-08-17_BH.xlsx`).

Nous pouvons donc quantifier le nombre d’auteurs ETBX pour chaque
production scientifique (comprenant les articles scientifiques et les
chapitres d’ouvrages) :

<img src="analyses_sans_code_files/figure-gfm/unnamed-chunk-20-1.png" width="100%" />

Avec l’information du nombre de co-auteurs, nous pouvons corriger le
nuage de revues précédent en le pondérant par le nombre moyen de
co-auteurs ETBX par publication pour chaque revue.

![Nombre moyen de co-auteurs par publication par revue](wordcloud.png)

Grâce à la classification JCR (<https://jcr.clarivate.com>) nous pouvons
classer les revues selon des grandes catégories disciplinaires. Ci
dessous un tableau des 48 revues pour lesquelles une correspondance de
catégorie a pu être récupérée.

    ##  [1] "agricultural systems"                                 
    ##  [2] "agricultural water management"                        
    ##  [3] "annals of forest science"                             
    ##  [4] "climate policy"                                       
    ##  [5] "climatic change"                                      
    ##  [6] "comptes rendus geoscience"                            
    ##  [7] "computational statistics"                             
    ##  [8] "ecological economics"                                 
    ##  [9] "ecological indicators"                                
    ## [10] "energy economics"                                     
    ## [11] "energy policy"                                        
    ## [12] "environment and history"                              
    ## [13] "environmental management"                             
    ## [14] "environmental pollution"                              
    ## [15] "environmental science and pollution research"         
    ## [16] "european review of agricultural economics"            
    ## [17] "food policy"                                          
    ## [18] "forest policy and economics"                          
    ## [19] "geoforum"                                             
    ## [20] "international forestry review"                        
    ## [21] "journal of choice modelling"                          
    ## [22] "journal of coastal research"                          
    ## [23] "journal of environmental management"                  
    ## [24] "journal of environmental planning and management"     
    ## [25] "journal of environmental policy & planning"           
    ## [26] "journal of hydraulic engineering"                     
    ## [27] "journal of hydroinformatics"                          
    ## [28] "journal of irrigation and drainage engineering"       
    ## [29] "journal of rural studies"                             
    ## [30] "journal of water resources planning and management"   
    ## [31] "journal of wine economics"                            
    ## [32] "land use policy"                                      
    ## [33] "landscape and urban planning"                         
    ## [34] "outlook on agriculture"                               
    ## [35] "policy sciences"                                      
    ## [36] "regional environmental change"                        
    ## [37] "river research and applications"                      
    ## [38] "silva fennica"                                        
    ## [39] "small-scale forestry"                                 
    ## [40] "social indicators research"                           
    ## [41] "sociologia ruralis"                                   
    ## [42] "stochastic environmental research and risk assessment"
    ## [43] "urban water journal"                                  
    ## [44] "water"                                                
    ## [45] "water and environment journal"                        
    ## [46] "water research"                                       
    ## [47] "water resources and economics"                        
    ## [48] "water science and technology"

Voici donc le résumé du nombre de publications par catégorie JCR :

<img src="analyses_sans_code_files/figure-gfm/unnamed-chunk-22-1.png" width="100%" />

Nous pouvons maintenant nous intéresser aux disciplines. Nous pouvons
dénombrer le nombre de disciplines mobilisées pour chaque production
scientifique (comprenant les articles scientifiques et les chapitres
d’ouvrages) :

<img src="analyses_sans_code_files/figure-gfm/unnamed-chunk-23-1.png" width="100%" />

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

Sur les **146** entrées récupérées dans la base HAL, nous obtenons
**282** structures différentes avec lesquelles ETBX co-publie des
articles scientifiques ou des chapitres d’ouvrages. A partir des données
extraites de ces documents, un premier travail de catégorisation
manuelle de nos partenaires a été entamé par le GT (B. Rulleau), mais ne
donne pour le moment pas suffisamment d’informations pour pousser
l’analyse avec ces données.

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

  - IRSTEA
  - INRAE
  - INRA
  - CNRS
  - AgroParisTech
  - Université de Bordeaux
  - Centre de Coopération Internationale en Recherche Agronomique pour
    le Développement
  - Institut national d’études supérieures agronomiques de Montpellier
  - École des hautes études en sciences sociales  
  - Ecole Nationale Supérieure des Sciences Agronomiques de
    Bordeaux-Aquitaine
  - 3S Consult GmbH  
  - École Nationale du Génie de l’Eau et de l’Environnement de
    Strasbourg  
  - École des Ponts ParisTech  
  - Gestion Territoriale de l’Eau et de l’environnement  
  - Université de Montpellier  
  - Université Sciences et Technologies - Bordeaux 1  
  - Université Toulouse - Jean Jaurès  
  - University of Adelaide

## Reste à faire

  - [ ] Synthèse détaillée par onglet
  - [ ] Approche “Publish or Perish” pour les données de citations pour
    complément de l’approche Scopus
  - [ ] Représentation ‘Réseau’ des collaborations (internes et
    externes)
  - [ ] Catégorisation des structures avec lesquelles ETBX co-publie
  - [ ] Affectation de chaque membre de l’UR à une grande discipline
    (SHS/SE,SPI et éventuellement autres…)
  - [ ] Recensement des partenaires économiques/externes : Donnée
    inexistante sur le fichier excel.
  - [ ] Focus sur les contrats “nationaux” afin de séparer les ANR,
    projets collectivités, etc.
