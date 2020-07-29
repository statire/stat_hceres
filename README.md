Traitement des données issues du document partagé pour l’Annexe 4
================

  - [Point du 24/07 sur les objectifs](#point-du-2407-sur-les-objectifs)
  - [Import et nettoyage des données](#import-et-nettoyage-des-données)
      - [Import](#import)
      - [Vision d’ensemble du fichier](#vision-densemble-du-fichier)
  - [Exploitation des données](#exploitation-des-données)
      - [Premiers indicateurs](#premiers-indicateurs)
          - [Projets](#projets)
          - [Production de connaissances](#production-de-connaissances)
          - [Partenariats](#partenariats)
      - [Vision pour chaque onglet](#vision-pour-chaque-onglet)

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

# Import et nettoyage des données

## Import

Dans un premier temps, chargement des packages nécessaires :

``` r
library(dplyr)
library(tidyr)
library(janitor)
library(ggplot2)
library(readxl)
library(purrr)
library(bib2df)
library(gt)
library(wordcloud2)
library(stringr)

source("R/theme_inrae.R")
```

Nous pouvons maintenant importer le fichier :

``` r
# Fichier en date du 27/07/2020
file <- "data/Annexe4_ETBX_complet_2020_07_27.xlsx"


# On réalise une boucle pour importer tous les onglets dans un seul objet, sous forme de liste

sheet_names <- readxl::excel_sheets(file) 
ANX4 <- list()

for (i in sheet_names[-1:-3]) {
  
  ANX4[[i]] <- readxl::read_excel(file, sheet  = i, skip = 1) %>%
    select(-1) # Retrait colonne n°
  
}

# On rend exploitables les noms d'onglets
names(ANX4) <- janitor::make_clean_names(names(ANX4))
```

Pour les tableaux avec cases à cocher, on définit une fonction de
nettoyage qui permettra lors des synthèses de remplacer les `NA` par des
`0` et les `x` par des `1`. Ainsi, nous pourrons faire des sommes etc.

``` r
replace_cases <- function(x){
  
  value <- ifelse(is.na(x), yes = 0, no = 1)
  
  return(value)
  
}
```

## Vision d’ensemble du fichier

Voici un tableau récapitulatif de la dimension des onglets, triés selon
le nombre de lignes.

``` r
tab_dim <- tibble(
  Onglet = names(ANX4),
  nb_lignes = map_dbl(ANX4, nrow),
  nb_colonnes = map_dbl(ANX4, ncol)
) %>% 
  arrange(desc(nb_lignes))


# On ne va garder que les onglets qui ne sont pas vides. 
# Les onglets à 2 lignes sont à chaque fois vide (car la colonne n° a été remplie pour 1 et 2) 
# sauf pour 4 onglets particuliers qui sont ici rajoutés.
Onglets_non_empty <- tab_dim %>%
  filter(nb_lignes != 2) %>%
  pull(Onglet) %>% 
  c("ii_3_activ_consult","iii_1_elearning", "i_9_contrats_internationaux","i_1_articles_synth")

# On affiche le tableau (Seulement le top 10)
tab_dim %>% filter(Onglet %in% Onglets_non_empty) %>% 
  slice(1:10)
```

<div class="kable-table">

| Onglet                         | nb\_lignes | nb\_colonnes |
| :----------------------------- | ---------: | -----------: |
| i\_3\_autres\_produits\_colloq |        136 |            6 |
| i\_1\_articles\_sctfq          |        122 |            7 |
| ii\_3\_particip\_instances     |         84 |            3 |
| i\_8\_evaluation\_articles     |         82 |            3 |
| iii\_3\_enseignement           |         53 |            8 |
| ii\_3\_rapports\_expertise     |         48 |            6 |
| i\_8\_responsab\_instances     |         46 |            5 |
| i\_3\_articles\_actes\_colloq  |         46 |            7 |
| iii\_3\_formation              |         42 |            8 |
| i\_11\_orga\_colloq\_internat  |         41 |            4 |

</div>

# Exploitation des données

## Premiers indicateurs

### Projets

> NB : Il y a un projet international (le seul) à la fin inconnue… Donc
> par défaut j’ai décidé la fin en 2024 pour ne pas changer la tête du
> graphique tout en conservant l’info qu’il y a un projet international.

``` r
## Extraction des projets nationaux
projets_nationaux <- ANX4$i_9_contrats_nationaux %>% 
  clean_names() %>% 
  select(-x11) %>% 
  drop_na(contrat) %>% drop_na(date_debut) %>% mutate(type = "National")

## Projets européens
projets_europ <- ANX4$i_9_contrats_europ_autres %>% drop_na(`Date début`) %>% clean_names() %>%  
  mutate_at(vars(date_debut:date_fin), as.Date) %>% mutate(type = "Européen")

## Projets internationaux
projets_inter <- ANX4$i_9_contrats_internationaux %>% clean_names() %>%  
  mutate_at(vars(date_debut:date_fin), as.Date) %>% mutate(type = "International")

## Projets R&D
projets_rd <- ANX4$i_9_contrats_prive_r_d_indus %>% clean_names() %>%  
  mutate_at(vars(date_debut:date_fin), as.Date) %>% mutate(type = "R&D")

## Projets PIA
projets_pia <- ANX4$i_9_contrats_pia %>% clean_names() %>%  drop_na(contrat,date_debut) %>% 
  mutate_at(vars(date_debut:date_fin), as.Date) %>% mutate(type = "PIA")

## Projets de collectivités territoriales
projets_coll_terri <- ANX4$i_9_contrats_coll_territ %>% clean_names() %>%  drop_na(contrat,date_debut, date_fin) %>% 
  mutate_at(vars(date_debut), as.Date, origin = "1899-12-31") %>% mutate(type = "National")

## On assemble le tout
PRJ <- bind_rows(projets_nationaux,projets_europ)%>%
  bind_rows(projets_inter) %>% 
  bind_rows(projets_rd) %>% 
  bind_rows(projets_pia) %>% 
  bind_rows(projets_coll_terri) %>% 
  mutate_at(vars(porteur:axe_3), replace_cases) %>% unique() %>% 
  mutate(date_fin = replace_na(date_fin, "2024-01-01")) %>%  
  mutate(porteur = recode(porteur, "0" = "ETBX Non porteur", "1"="ETBX Porteur")) %>% 
  mutate(porteur = factor(porteur, levels = c("ETBX Porteur", "ETBX Non porteur"))) %>%
  group_by(contrat) %>% 
  summarise(date_debut = min(date_debut),
         date_fin = max(date_fin),
         porteur = unique(porteur),
         type = unique(type)) %>% 
  ungroup()


## Production du graphique
ggplot(PRJ, aes(x = date_fin, y = reorder(contrat,date_debut))) +
  geom_segment(aes(x = date_debut, xend = date_fin, y = reorder(contrat,date_debut), yend = reorder(contrat,date_debut), color = type), size = 4) +
  geom_point(fill = "black", shape = 23, color = "black", size = 4) +
  geom_point(aes(x = date_debut, y = reorder(contrat,date_debut)), color ="black", fill = "black", shape = 23, size = 4) +
  theme_inrae() +
  geom_vline(xintercept = as.Date("2020-06-01"), color = "blue", size = 4) +
  labs(x = "Temps", y = "Contrats", color = "Type de contrat") +
  facet_wrap(~porteur, scales = "free")
```

<img src="README_files/figure-gfm/unnamed-chunk-4-1.png" width="100%" />

Il y a **76** projets en cours.

### Production de connaissances

Nous étudions dans un premier temps le nombre d’articles, d’actes de
colloques et de chapitres d’ouvrages publiés par des agents de l’unité.

``` r
acl1 <- ANX4$i_1_articles_sctfq %>%
  clean_names() %>% 
  mutate(year = stringr::str_extract(reference_complete,'\\d{4}')) %>% 
  drop_na(year) %>% 
  group_by(year) %>% 
  summarise(n = n_distinct(reference_complete)) %>% 
  spread(key = year, value = n) %>%
  mutate(Type = "Articles")


acl2 <- ANX4$i_1_autres_articles %>%
  clean_names() %>% 
  mutate(year = stringr::str_extract(reference_complete,'\\d{4}')) %>% 
  filter(year != 2016) %>% 
  drop_na(year) %>% 
  group_by(year) %>% 
  summarise(n = n_distinct(reference_complete)) %>%
  spread(key = year, value = n) %>%
  mutate(Type = "Autres articles")


acl3 <- ANX4$i_3_articles_actes_colloq %>%
  clean_names() %>% 
  mutate(year = stringr::str_extract(reference_complete,'\\d{4}')) %>% 
  drop_na(year) %>% 
  group_by(year) %>% 
  summarise(n = n_distinct(reference_complete)) %>% spread(key = year, value = n) %>% mutate(Type = "Actes colloques")


acl4 <- ANX4$i_2_chap_ouvrages %>%
  clean_names() %>% 
  mutate(year = stringr::str_extract(reference_complete,'\\d{4}')) %>% 
  drop_na(year) %>% 
  group_by(year) %>% 
  summarise(n = n_distinct(reference_complete)) %>% spread(key = year, value = n) %>% mutate(Type = "Chapitres ouvrages")

bind_rows(acl1,acl2,acl3,acl4) %>% 
  select(Type,`2017`:`2020`) 
```

<div class="kable-table">

| Type               | 2017 | 2018 | 2019 | 2020 |
| :----------------- | ---: | ---: | ---: | ---: |
| Articles           |   41 |   30 |   28 |   21 |
| Autres articles    |    6 |    3 |    2 |    1 |
| Actes colloques    |   13 |   14 |   18 |    1 |
| Chapitres ouvrages |    6 |   14 |    5 |    4 |

</div>

En ce qui concerne les revues, voici un nuage des revues auxquelles sont
soumis les articles scientifiques

``` r
word_count <- ANX4$i_1_articles_sctfq %>% 
  clean_names() %>% 
  group_by(journal) %>% 
  count() %>% arrange(desc(n)) %>% 
  ungroup() %>% 
  rowwise() %>% 
  mutate(n = ifelse(journal == "Journal of Water Resources Planning and Management", yes = 7, no = n)) %>% 
    mutate(journal = ifelse(journal == "Journal of Water Resources Planning and Management", yes = "Water Res. Planning and Management", no = journal)) %>% 
  ungroup() %>%  mutate(journal = str_to_lower(journal)) %>% 
  mutate(journal = str_trim(journal))

# wordcloud2(word_count, size = 0.35)
```

![](wordcloud.png)

Nous pouvons ensuite observer si notre unité est bien identifiée dans
les revues dans lesquelles elle publie :

``` r
articles <- ANX4$i_1_articles_sctfq %>% 
  clean_names() %>% 
  group_by(journal) %>% 
  count() %>% arrange(desc(n)) %>% 
  mutate(journal = str_to_lower(journal)) %>% 
  mutate(journal = str_trim(journal))



tab_relecture_articles <- ANX4$i_8_evaluation_articles %>% 
  clean_names() %>% 
  select(revue_ouvrage, nombre_de_relectures) %>% 
  mutate(revue_ouvrage = str_to_lower(revue_ouvrage)) %>% 
  mutate(revue_ouvrage = str_trim(revue_ouvrage)) %>% 
  full_join(articles, by = c("revue_ouvrage"="journal")) %>% 
  arrange(revue_ouvrage) %>% unique() %>% group_by(revue_ouvrage) %>% 
  summarise(n_relecture = sum(nombre_de_relectures, na.rm=TRUE), n_publi = sum(n, na.rm=TRUE)) %>% 
  ungroup() %>% 
  unique()

# Top 10
tab_relecture_articles %>%
  mutate(indicateur_som = n_relecture * n_publi) %>% 
  arrange(desc(indicateur_som))%>% 
  slice(1:10) 
```

<div class="kable-table">

| revue\_ouvrage                                     | n\_relecture | n\_publi | indicateur\_som |
| :------------------------------------------------- | -----------: | -------: | --------------: |
| journal of water resources planning and management |           29 |       10 |             290 |
| environmental science and policy                   |            4 |        4 |              16 |
| développement durable et territoires               |            3 |        4 |              12 |
| social indicators research                         |            8 |        1 |               8 |
| sud-ouest europeen                                 |            1 |        6 |               6 |
| urban water journal                                |            3 |        2 |               6 |
| land use policy                                    |            1 |        5 |               5 |
| vertigo                                            |            1 |        5 |               5 |
| forest policy and economics                        |            1 |        4 |               4 |
| natures sciences sociétés                          |            1 |        4 |               4 |

</div>

``` r
# Top 10
tab_relecture_articles %>%
  mutate(indicateur_moy = (n_relecture + n_publi)/2) %>% 
  arrange(desc(indicateur_moy))%>% 
  slice(1:10) 
```

<div class="kable-table">

| revue\_ouvrage                                     | n\_relecture | n\_publi | indicateur\_moy |
| :------------------------------------------------- | -----------: | -------: | --------------: |
| journal of water resources planning and management |           29 |       10 |            19.5 |
| journal of hydroinformatics, iwa                   |           10 |        0 |             5.0 |
| social indicators research                         |            8 |        1 |             4.5 |
| environmental science and policy                   |            4 |        4 |             4.0 |
| développement durable et territoires               |            3 |        4 |             3.5 |
| sud-ouest europeen                                 |            1 |        6 |             3.5 |
| land use policy                                    |            1 |        5 |             3.0 |
| vertigo                                            |            1 |        5 |             3.0 |
| forest policy and economics                        |            1 |        4 |             2.5 |
| natures sciences sociétés                          |            1 |        4 |             2.5 |

</div>

### Partenariats

#### Interdisciplinarité proche (interne)

A partir du tableau rempli par l’équipe du GT4, nous pouvons créer une
liste de noms d’auteurs (prenant en compte toutes les syntaxes possibles
d’un même nom) appartenant à ETBX.

``` r
table_auteurs <- readxl::read_excel("data/table_auteurs_ETBX_2020-07-27_SL_DC.xlsx") %>% clean_names()


liste_auteurs_etbx <- table_auteurs %>%
  filter(etbx_oui_non %in% c("oui","temporaire", "oui / BSA", "temporaire ?")) %>% 
  pull(auteur)

liste_auteurs_etbx
```

    ##   [1] "Aka, J"              "Alonso Ugaglia A"    "Alonso Ugaglia A."  
    ##   [4] "Alonso Ugaglia, A"   "Alonso Ugaglia, A."  "Alonso-Ugaglia, A"  
    ##   [7] "André, C"            "Aouadi N"            "Assouan, E"         
    ##  [10] "Aubrun, C"           "Ayala Cabrera, D"    "Banos, V"           
    ##  [13] "Banos, V."           "Bernard, P"          "Boschet C"          
    ##  [16] "Boschet, C"          "Bouet B"             "Bouet, B"           
    ##  [19] "Bouleau, G"          "Bouleau, G."         "Brahic, E"          
    ##  [22] "Brahic, E."          "Braun, M"            "Brun, C"            
    ##  [25] "Caillaud, K."        "Candau, J"           "Candau, J."         
    ##  [28] "Carayon, D"          "Carreira, A."        "Carter, C"          
    ##  [31] "Carter, C."          "Cazals, C"           "Chambon, C"         
    ##  [34] "Cholet, L"           "Conchon, P."         "Dachary Bernard, J" 
    ##  [37] "Dachary Bernard, J." "Dachary-Bernard, J"  "Dachary-Bernard, J."
    ##  [40] "De Godoy Leski, C"   "de Rouffignac A."    "de Rouffignac, A"   
    ##  [43] "de Rouffignac, A."   "Dehez J"             "Dehez J."           
    ##  [46] "Dehez, J"            "Dehez, J."           "Del'homme B"        
    ##  [49] "Del'homme, B"        "Del'homme, B."       "Deldrève V."        
    ##  [52] "Deldreve, V"         "Deldrève, V"         "Deldreve, V."       
    ##  [55] "Deldrève, V."        "Deuffic, P"          "Deuffic, P."        
    ##  [58] "Diaw, M"             "Esparon, S."         "Fisnot, C"          
    ##  [61] "Gassiat A"           "Gassiat, A"          "Gassiat, A."        
    ##  [64] "Giard, A"            "Gilbert, D"          "Ginelli L"          
    ##  [67] "Ginelli, L"          "Ginelli, L."         "Ginter Z."          
    ##  [70] "Ginter, Z"           "Girard, S"           "Girard, S."         
    ##  [73] "Gremmel, J"          "Gremmel, J."         "Hautdidier B"       
    ##  [76] "Hautdidier, B"       "Hautdidier, B."      "Houdart, M"         
    ##  [79] "Husson, A"           "Husson, A."          "Joalland, O"        
    ##  [82] "Kerouaz, F"          "Kerouaz, F."         "Krasnodębski M."    
    ##  [85] "Krasnodębski, M."    "Krieger, S.J"        "Kuentz Simonet, V"  
    ##  [88] "Kuentz-Simonet V"    "Kuentz-Simonet, V"   "Labbouz B"          
    ##  [91] "Labenne, A"          "Lafon, S."           "Large, A"           
    ##  [94] "Latimier, A-C."      "Le Floch S"          "Le Floch, S"        
    ##  [97] "Le Floch, S."        "Le Gat, Y"           "Le Gat, Y."         
    ## [100] "Leccia Phelpin, O"   "Leccia-Phelpin, O"   "Leccia, O"          
    ## [103] "Leccia, O."          "Legat, Y."           "Lemarié Boutry, M"  
    ## [106] "Lescot J-M."         "Lescot J.-M"         "Lescot, J.M"        
    ## [109] "Lescot, J.M."        "Lyser S."            "Lyser, S"           
    ## [112] "Lyser, S."           "Macary F"            "Macary, F"          
    ## [115] "Macary, F."          "Mainguy, G"          "Marquet V"          
    ## [118] "Marquet, V"          "Petit, K"            "Petit, K."          
    ## [121] "Pham, T"             "Piller O"            "Piller, O"          
    ## [124] "Piller, O."          "Pillot, J"           "Rambolinaza, T."    
    ## [127] "Rambonilaza T"       "Rambonilaza T."      "Rambonilaza, M"     
    ## [130] "Rambonilaza, T"      "Rambonilaza, T."     "Renaud, E"          
    ## [133] "Renaud, E."          "Rocle N"             "Rocle N."           
    ## [136] "Rocle, N"            "Rocle, N."           "Roussary, A."       
    ## [139] "Rulleau, B"          "Rulleau, B."         "Salles D"           
    ## [142] "Salles, D"           "Salles, D."          "Scordia, C"         
    ## [145] "Scordia, C."         "Sergent, A"          "Sergent, A."        
    ## [148] "Stricker, A. E"      "Stricker, A. E."     "Stricker, A.E"      
    ## [151] "Stricker, A.E."      "Terreaux, J.P"       "Terreaux, J.P."     
    ## [154] "Thomas, A."          "Tomasian, M"         "Ung, H"             
    ## [157] "Uny, D"              "Vacelet, A"          "Vernier F"          
    ## [160] "Vernier F."          "Vernier, F"          "Vernier, F."        
    ## [163] "Zahm F."             "Zahm, F"             "Zahm, F."

Chacun des agents ETBX a aussi été affecté à une discipline, en accord
avec les informations présentées sur le site web de l’unité
<https://www6.bordeaux-aquitaine.inrae.fr/etbx/Les-equipes>.

Nous pouvons donc quantifier le nombre d’auteurs ETBX pour chaque
publication :

``` r
calcul_nb_copubli <- function(x) {
  liste_auteurs_etbx[str_detect(x,liste_auteurs_etbx)] %>% gsub('^\\.|\\.$', '', .) %>% unique() %>% 
    length()
}

# Top 10
ANX4$i_1_articles_sctfq %>% clean_names() %>% 
  select(reference_complete) %>% 
  rowwise() %>% 
  mutate(nb_copubli = calcul_nb_copubli(reference_complete)) %>% 
  ungroup() %>% arrange(desc(nb_copubli)) %>% 
  slice(1:10) 
```

<div class="kable-table">

| reference\_complete                                                                                                                                                                                                                                                                                                                                                                     | nb\_copubli |
| :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------: |
| Banos, V., Gassiat, A., Girard, S., Hautdidier, B., Houdart, M., Le Floch S., Vernier F., 2020, L’écologisation, mise à l’épreuve ou nouveau registre de légitimation de l’ordre territorial ? Une lecture à partir des particularités du débat conceptuel en France, Développement durable et territoires (à paraître)                                                                 |           7 |
| Drouineau, H., Carter, C., Rambonilaza, M., Beaufaron, G., Bouleau, G., Gassiat, A., Lambert, P., Le Floch, S., Tétard, S., De Oliveira, E. - 2018. River Continuity Restoration and Diadromous Fishes: Much More than an Ecological Issue. Environmental Management, vol. 61, n° 4, p. 671-686                                                                                         |           5 |
| Vernier, F., Leccia Phelpin, O., Lescot, J.M., Minette, S., Miralles, A., Barberis, D., Scordia, C., Kuentz Simonet, V., Tonneau, J.P. - 2017. Integrated modeling of agricultural scenarios (IMAS) to support pesticide action plans: the case of the Coulonge drinking water catchment area (SW France). Environmental Science and Pollution Research, vol. 24, n° 8, p. 6923-6950    |           5 |
| Zahm, F., Barbier, J.M., Cohen, S., Boureau, H., Girard, S., Carayon, D., Alonso Ugaglia, A., Del’homme, B., Gafsi, M., Gasselin, P., Guichard, L., Loyce, C., Manneville, V., Redlingshöfer, B. - 2019. IDEA4 : une méthode de diagnostic pour une évaluation clinique de la durabilité en agriculture . Agronomie, Environnement et Sociétés, vol. 9, n° 2, p. 39-51                  |           5 |
| Renaud, E., Husson, A., Vacelet, A., Le Gat, Y., Stricker, A. E.,  - 2020. Statistical modelling of French drinking water pipe inventory at national level using demographic and geographical information. H2Open Journal IWA Publishing Vol 3 No 1 p. 89-101                                                                                                                           |           5 |
| Candau, J., Deuffic, P., Kuentz Simonet, V., Lyser, S. - 2017. Entre environnement, marché, territoire : agriculteurs en quête de sens pour leur métier. Regards Sociologiques, vol. 50-51, p. 45-81                                                                                                                                                                                    |           4 |
| Cazals, C., Lyser, S., Bouleau, G., Hautdidier, B. - 2018. Quels écotourismes sur le bassin d’Arcachon ? Diversités et contradiction sur une territoire confrontéà son attractivité résidentielle . Sud-Ouest Europeen, n° 45, p. 139-156                                                                                                                                               |           4 |
| Ginelli, L., Candau, J., Girard, S., Houdart, S., Deldrève, V. - 2020. Écologisation des pratiques et territorialisation des activités : une introduction . Développement durable et territoires,                                                                                                                                                                                       |           4 |
| Hautdidier, B., Banos, V., Deuffic, P., Sergent, A. - 2018. Leopards under the pines: An account of continuity and change in the integration of forest land-uses in Landes de Gascogne, France. Land Use Policy, vol. 79, p. 990-1000                                                                                                                                                   |           4 |
| Zahm, F., Alonso Ugaglia, A., Barbier, J.M., Boureau, H., Del’homme, B., Gafsi, M., Gasselin, P., Girard, S., Guichard, L., Loyce, C., Manneville, V., Menet, A., Redlingshöfer, B. - 2019. Évaluer la durabilité des exploitations agricoles : La méthode IDEA v4, un cadre conceptuel combinant dimensions et propriétés de la durabilité . Cahiers Agricultures, vol. 28, n° 5, 10 p |           4 |

</div>

Nous pouvons maintenant nous intéresser aux disciplines :

``` r
table_disciplines <- table_auteurs %>% filter(etbx_oui_non %in% c("oui","temporaire", "oui / BSA", "temporaire ?")) %>% 
  select(auteur,discipline) %>% drop_na()


calcul_discipline <- function(x) {
  
  df <- data.frame(auteur = liste_auteurs_etbx[str_detect(x,liste_auteurs_etbx)] %>% gsub('^\\.|\\.$', '', .) %>% unique() )
  
  df %>% inner_join(table_disciplines, by = "auteur") %>% pull(discipline) %>% unique() %>% paste(collapse = " / ")
  
}

# Top 10
ANX4$i_1_articles_sctfq %>% clean_names() %>% 
  select(reference_complete) %>% 
  rowwise() %>% 
  mutate(disciplines = calcul_discipline(reference_complete)) %>% 
  mutate(nb_disciplines = str_split(disciplines, " / ")[[1]] %>% length) %>% 
  ungroup() %>% 
  arrange(desc(nb_disciplines)) %>% 
  slice(1:10) 
```

<div class="kable-table">

| reference\_complete                                                                                                                                                                                                                                                                                                                                                                  | disciplines                                                                      | nb\_disciplines |
| :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------- | --------------: |
| Cazals, C., Lyser, S., Bouleau, G., Hautdidier, B. - 2018. Quels écotourismes sur le bassin d’Arcachon ? Diversités et contradiction sur une territoire confrontéà son attractivité résidentielle . Sud-Ouest Europeen, n° 45, p. 139-156                                                                                                                                            | sciences po / économie / géographie / statistique                                |               4 |
| Banos, V., Gassiat, A., Girard, S., Hautdidier, B., Houdart, M., Le Floch S., Vernier F., 2020, L’écologisation, mise à l’épreuve ou nouveau registre de légitimation de l’ordre territorial ? Une lecture à partir des particularités du débat conceptuel en France, Développement durable et territoires (à paraître)                                                              | géographie / sciences agronomiques et économiques / sciences de l’environnement  |               3 |
| Drouineau, H., Carter, C., Rambonilaza, M., Beaufaron, G., Bouleau, G., Gassiat, A., Lambert, P., Le Floch, S., Tétard, S., De Oliveira, E. - 2018. River Continuity Restoration and Diadromous Fishes: Much More than an Ecological Issue. Environmental Management, vol. 61, n° 4, p. 671-686                                                                                      | sciences po / géographie / économie                                              |               3 |
| Hautdidier, B., Banos, V., Deuffic, P., Sergent, A. - 2018. Leopards under the pines: An account of continuity and change in the integration of forest land-uses in Landes de Gascogne, France. Land Use Policy, vol. 79, p. 990-1000                                                                                                                                                | géographie / sociologie / sciences po                                            |               3 |
| Vernier, F., Leccia Phelpin, O., Lescot, J.M., Minette, S., Miralles, A., Barberis, D., Scordia, C., Kuentz Simonet, V., Tonneau, J.P. - 2017. Integrated modeling of agricultural scenarios (IMAS) to support pesticide action plans: the case of the Coulonge drinking water catchment area (SW France). Environmental Science and Pollution Research, vol. 24, n° 8, p. 6923-6950 | statistique / sciences de l’environnement / sciences agronomiques et économiques |               3 |
| Aouadi N., Macary F., Alonso Ugaglia A., 2020. Evaluation multicritère des performances socio-économiques et environnementales de systèmes viticoles et de scénarios de transition agroécologique, Cahiers Agriculture. Article accepté pour publication (mai 2020).                                                                                                                 | sciences agronomiques et économiques / sciences de l’environnement               |               2 |
| Ayala Cabrera, D., Piller, O., Herrera, M., Gilbert, D., Deuerlein, J. - 2019. Absorptive Resilience Phase Assessment Based on Criticality Performance indicators for Water Distribution Networks. Journal of Water Resources Planning and Management, vol. 149, n° 9, 15 p.                                                                                                         | mathématiques / hydraulique                                                      |               2 |
| Banos, V., Deuffic, P., 2020, Après la catastrophe, bifurquer ou persévérer ? Les forestiers à l’épreuve des événements climatiques extrêmes, Natures Sciences Sociétés, n°4 ( à paraître)                                                                                                                                                                                           | géographie / sociologie                                                          |               2 |
| Banos, V., Dehez, J. - 2017. Le bois-énergie dans la tempête, entre innovation et captation ? Les nouvelles ressources de la forêt landaise. Natures Sciences Sociétés, vol. 25, n° 2, p. 122-133                                                                                                                                                                                    | géographie / économie                                                            |               2 |
| Brahic, E., Deuffic, P. - 2017. Comportement des propriétaires forestiers landais vis-à-vis du bois énergie : Une analyse micro-économique. Economie Rurale, n° 359, p. 7-25                                                                                                                                                                                                         | économie / sociologie                                                            |               2 |

</div>

#### Interdisciplinarité éloignée (externe)

Cette section nécessite de disposer d’informations sur les affiliations
des co-auteurs. Cette information n’est malheureusement pas accessible
directement via le tableau excel (stratus) rempli par les collègues.

Il est donc nécessaire de passer soit :

  - par HAL-INRAE, ce qui implique de travailler, forcémment, avec un
    nombre réduit de publications
  - A partir de notre tableau excel d’affiliation des agents à ETBX /
    aux disciplines : Rajouter le max d’info sur les co-publiants
    externes.

#### Export HAL-INRAE :

J’ai testé un export direct de HAL avec 2 critères : - Année 2017-2020 -
Unité = ETBX

Et j’ai le nombre d’entrées suivant :

``` r
# J'ai testé un export massif HAL-INRAE avec dates 2017-2020 et structure ETBX
test <- bib2df::bib2df("data/biball.bib")

test %>% group_by(CATEGORY) %>% count()
```

<div class="kable-table">

| CATEGORY      |   n |
| :------------ | --: |
| ARTICLE       | 103 |
| BOOK          |   6 |
| INCOLLECTION  |  25 |
| INPROCEEDINGS | 143 |
| MASTERSTHESIS |   7 |
| MISC          |   4 |
| PHDTHESIS     |   9 |
| PROCEEDINGS   |   1 |
| TECHREPORT    |  25 |
| UNPUBLISHED   |   2 |

</div>

#### Nombre de citations

A partir de export HAL-INRAE, j’ai pu récupérer 80 DOI, que je pourrais
utiliser pour récupérer des données du nombre de citations de chaque
article via Scopus.

Il me reste également à explorer l’approche “Publish or Perish” proposée
par Baptiste qui se révèlera peut-être plus exhaustive que Scopus.

L’approche google scholar est pour le moment exclue (nécessité pour
chaque agent de créer un compte et de me donner un ID trouvable dans les
paramètres).

## Vision pour chaque onglet

\[TO-DO\]
