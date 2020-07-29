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

# On affiche le tableau
tab_dim %>% filter(Onglet %in% Onglets_non_empty)
```

<div class="kable-table">

| Onglet                                | nb\_lignes | nb\_colonnes |
| :------------------------------------ | ---------: | -----------: |
| i\_3\_autres\_produits\_colloq        |        136 |            6 |
| i\_1\_articles\_sctfq                 |        122 |            7 |
| ii\_3\_particip\_instances            |         84 |            3 |
| i\_8\_evaluation\_articles            |         82 |            3 |
| iii\_3\_enseignement                  |         53 |            8 |
| ii\_3\_rapports\_expertise            |         48 |            6 |
| i\_8\_responsab\_instances            |         46 |            5 |
| i\_3\_articles\_actes\_colloq         |         46 |            7 |
| iii\_3\_formation                     |         42 |            8 |
| i\_11\_orga\_colloq\_internat         |         41 |            4 |
| i\_9\_contrats\_nationaux             |         40 |           10 |
| i\_9\_contrats\_coll\_territ          |         34 |            9 |
| i\_2\_chap\_ouvrages                  |         33 |            6 |
| iii\_2\_prod\_issues\_de\_theses      |         28 |            8 |
| ii\_4\_produits\_vulgarisation        |         27 |            5 |
| i\_8\_evaluation\_projets             |         22 |            3 |
| i\_9\_contrats\_pia                   |         18 |            9 |
| i\_7\_comites\_editoriaux             |         15 |            2 |
| i\_1\_autres\_articles                |         15 |            6 |
| i\_5\_questionnaires                  |         13 |            8 |
| i\_10\_post\_docs                     |         11 |            9 |
| ii\_4\_emissions\_radio\_tv           |         10 |            5 |
| ii\_2\_formations\_acteurs\_socioec   |          9 |            5 |
| i\_10\_chercheurs\_accueil            |          8 |            9 |
| i\_4\_logiciels                       |          8 |            5 |
| i\_11\_responsab\_stes\_savantes      |          7 |            3 |
| i\_9\_contrats\_prive\_r\_d\_indus    |          7 |            9 |
| i\_11\_sejours\_labo\_etrangers       |          6 |            4 |
| iii\_3\_respons\_master               |          6 |            5 |
| i\_9\_contrats\_europ\_autres         |          6 |            9 |
| i\_11\_prix\_distictions              |          5 |            3 |
| ii\_2\_creation\_reseaux              |          5 |            5 |
| i\_11\_invit\_colloq\_etranger        |          4 |            3 |
| i\_6\_produits\_propres\_a\_une\_disc |          4 |            4 |
| ii\_2\_contrats\_r\_d                 |          4 |            5 |
| i\_2\_monographies                    |          3 |            5 |
| ii\_3\_activ\_consult                 |          2 |            2 |
| i\_1\_articles\_synth                 |          2 |            5 |
| iii\_1\_elearning                     |          1 |            8 |
| ii\_2\_bourses\_cifre                 |          1 |            4 |
| i\_9\_contrats\_internationaux        |          1 |            9 |
| i\_4\_bases\_de\_donnees              |          1 |            4 |
| i\_4\_outils\_aide\_decision          |          1 |            4 |
| i\_2\_theses\_publiees                |          1 |            4 |
| i\_2\_dir\_ou\_coord                  |          1 |            5 |

</div>

# Exploitation des données

## Premiers indicateurs

### Projets

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
  mutate(date_fin = replace_na(date_fin, "2024-01-01")) %>%  # Il y a un projet international (le seul) à la fin inconnue... Donc par défaut j'ai décidé la fin en 2024 pour ne pas changer la tête du graphique tout en conservant l'info qu'il y a un projet international.
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
  summarise(n = n_distinct(reference_complete)) %>% spread(key = year, value = n) %>% mutate(Type = "Articles")


acl2 <- ANX4$i_1_autres_articles %>%
  clean_names() %>% 
  mutate(year = stringr::str_extract(reference_complete,'\\d{4}')) %>% 
  filter(year != 2016) %>% 
  drop_na(year) %>% 
  group_by(year) %>% 
  summarise(n = n_distinct(reference_complete)) %>% spread(key = year, value = n) %>% mutate(Type = "Autres articles")


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


# acl5 <- ANX4$ii_3_rapports_expertise %>%
#   clean_names() %>% 
#   mutate(year = stringr::str_extract(reference_complete,'\\d{4}')) %>% 
#   filter(year != 2016) %>% 
#   drop_na(year) %>% 
#   group_by(year) %>% 
#   summarise(n = n_distinct(reference_complete)) %>% spread(key = year, value = n) %>% mutate(Type = "Rapports d'expertise")

bind_rows(acl1,acl2,acl3,acl4) %>% 
  select(Type,`2017`:`2020`) %>% 
  gt() %>% 
  tab_header(title = "Productions de connaissance par ETBX") %>%
  tab_options(table.width = pct(100))
```

<!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#hqqapipxkp .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  width: 100%;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#hqqapipxkp .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hqqapipxkp .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#hqqapipxkp .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#hqqapipxkp .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hqqapipxkp .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hqqapipxkp .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#hqqapipxkp .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#hqqapipxkp .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#hqqapipxkp .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#hqqapipxkp .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#hqqapipxkp .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#hqqapipxkp .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#hqqapipxkp .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#hqqapipxkp .gt_from_md > :first-child {
  margin-top: 0;
}

#hqqapipxkp .gt_from_md > :last-child {
  margin-bottom: 0;
}

#hqqapipxkp .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#hqqapipxkp .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#hqqapipxkp .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hqqapipxkp .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#hqqapipxkp .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hqqapipxkp .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#hqqapipxkp .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hqqapipxkp .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hqqapipxkp .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#hqqapipxkp .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hqqapipxkp .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#hqqapipxkp .gt_left {
  text-align: left;
}

#hqqapipxkp .gt_center {
  text-align: center;
}

#hqqapipxkp .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#hqqapipxkp .gt_font_normal {
  font-weight: normal;
}

#hqqapipxkp .gt_font_bold {
  font-weight: bold;
}

#hqqapipxkp .gt_font_italic {
  font-style: italic;
}

#hqqapipxkp .gt_super {
  font-size: 65%;
}

#hqqapipxkp .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="hqqapipxkp" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<thead class="gt_header">

<tr>

<th colspan="5" class="gt_heading gt_title gt_font_normal" style>

Productions de connaissance par ETBX

</th>

</tr>

<tr>

<th colspan="5" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>

</th>

</tr>

</thead>

<thead class="gt_col_headings">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

Type

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">

2017

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">

2018

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">

2019

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">

2020

</th>

</tr>

</thead>

<tbody class="gt_table_body">

<tr>

<td class="gt_row gt_left">

Articles

</td>

<td class="gt_row gt_center">

41

</td>

<td class="gt_row gt_center">

30

</td>

<td class="gt_row gt_center">

28

</td>

<td class="gt_row gt_center">

21

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Autres articles

</td>

<td class="gt_row gt_center">

6

</td>

<td class="gt_row gt_center">

3

</td>

<td class="gt_row gt_center">

2

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Actes colloques

</td>

<td class="gt_row gt_center">

13

</td>

<td class="gt_row gt_center">

14

</td>

<td class="gt_row gt_center">

18

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Chapitres ouvrages

</td>

<td class="gt_row gt_center">

6

</td>

<td class="gt_row gt_center">

14

</td>

<td class="gt_row gt_center">

5

</td>

<td class="gt_row gt_center">

4

</td>

</tr>

</tbody>

</table>

</div>

<!--/html_preserve-->

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

## On affiche le tableau en ne gardant que les 10 premiers selon 2 critères
#  tab_relecture_articles %>% 
#   arrange(desc(n_relecture)) %>% 
#   slice(1:10) %>% 
#   gt() %>% 
#   tab_header(title = "Publications et relectures, tri par # de relectures (top 10)") %>%
#   tab_options(table.width = pct(100))
# 
# tab_relecture_articles %>% 
#   arrange(desc(n_publi))%>% 
#   slice(1:10) %>% 
#   gt() %>% 
#   tab_header(title = "Publications et relectures, tri par nombre de publications (top 10)") %>%
#   tab_options(table.width = pct(100))


tab_relecture_articles %>%
  mutate(indicateur_som = n_relecture * n_publi) %>% 
  arrange(desc(indicateur_som))%>% 
  slice(1:10) %>% 
  gt() %>%
  tab_header(title = "Top 10 selon l'indicateur 'n_relecture x n_publi'") %>%
  tab_options(table.width = pct(100))
```

<!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#rgytexfjnm .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  width: 100%;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#rgytexfjnm .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rgytexfjnm .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#rgytexfjnm .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#rgytexfjnm .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rgytexfjnm .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rgytexfjnm .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#rgytexfjnm .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#rgytexfjnm .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#rgytexfjnm .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#rgytexfjnm .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#rgytexfjnm .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#rgytexfjnm .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#rgytexfjnm .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#rgytexfjnm .gt_from_md > :first-child {
  margin-top: 0;
}

#rgytexfjnm .gt_from_md > :last-child {
  margin-bottom: 0;
}

#rgytexfjnm .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#rgytexfjnm .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#rgytexfjnm .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rgytexfjnm .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#rgytexfjnm .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rgytexfjnm .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#rgytexfjnm .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rgytexfjnm .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rgytexfjnm .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#rgytexfjnm .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rgytexfjnm .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#rgytexfjnm .gt_left {
  text-align: left;
}

#rgytexfjnm .gt_center {
  text-align: center;
}

#rgytexfjnm .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#rgytexfjnm .gt_font_normal {
  font-weight: normal;
}

#rgytexfjnm .gt_font_bold {
  font-weight: bold;
}

#rgytexfjnm .gt_font_italic {
  font-style: italic;
}

#rgytexfjnm .gt_super {
  font-size: 65%;
}

#rgytexfjnm .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="rgytexfjnm" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<thead class="gt_header">

<tr>

<th colspan="4" class="gt_heading gt_title gt_font_normal" style>

Top 10 selon l’indicateur ‘n\_relecture x n\_publi’

</th>

</tr>

<tr>

<th colspan="4" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>

</th>

</tr>

</thead>

<thead class="gt_col_headings">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

revue\_ouvrage

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

n\_relecture

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">

n\_publi

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

indicateur\_som

</th>

</tr>

</thead>

<tbody class="gt_table_body">

<tr>

<td class="gt_row gt_left">

journal of water resources planning and management

</td>

<td class="gt_row gt_right">

29

</td>

<td class="gt_row gt_center">

10

</td>

<td class="gt_row gt_right">

290

</td>

</tr>

<tr>

<td class="gt_row gt_left">

environmental science and policy

</td>

<td class="gt_row gt_right">

4

</td>

<td class="gt_row gt_center">

4

</td>

<td class="gt_row gt_right">

16

</td>

</tr>

<tr>

<td class="gt_row gt_left">

développement durable et territoires

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_center">

4

</td>

<td class="gt_row gt_right">

12

</td>

</tr>

<tr>

<td class="gt_row gt_left">

social indicators research

</td>

<td class="gt_row gt_right">

8

</td>

<td class="gt_row gt_center">

1

</td>

<td class="gt_row gt_right">

8

</td>

</tr>

<tr>

<td class="gt_row gt_left">

sud-ouest europeen

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_center">

6

</td>

<td class="gt_row gt_right">

6

</td>

</tr>

<tr>

<td class="gt_row gt_left">

urban water journal

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_center">

2

</td>

<td class="gt_row gt_right">

6

</td>

</tr>

<tr>

<td class="gt_row gt_left">

land use policy

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_center">

5

</td>

<td class="gt_row gt_right">

5

</td>

</tr>

<tr>

<td class="gt_row gt_left">

vertigo

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_center">

5

</td>

<td class="gt_row gt_right">

5

</td>

</tr>

<tr>

<td class="gt_row gt_left">

forest policy and economics

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_center">

4

</td>

<td class="gt_row gt_right">

4

</td>

</tr>

<tr>

<td class="gt_row gt_left">

natures sciences sociétés

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_center">

4

</td>

<td class="gt_row gt_right">

4

</td>

</tr>

</tbody>

</table>

</div>

<!--/html_preserve-->

``` r
tab_relecture_articles %>%
  mutate(indicateur_moy = (n_relecture + n_publi)/2) %>% 
  arrange(desc(indicateur_moy))%>% 
  slice(1:10) %>% 
  gt() %>%
  tab_header(title = "Top 10 selon l'indicateur '(n_relecture + n_publi) / 2'") %>%
  tab_options(table.width = pct(100))
```

<!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#rvkjellrqp .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  width: 100%;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#rvkjellrqp .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rvkjellrqp .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#rvkjellrqp .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#rvkjellrqp .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rvkjellrqp .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rvkjellrqp .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#rvkjellrqp .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#rvkjellrqp .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#rvkjellrqp .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#rvkjellrqp .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#rvkjellrqp .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#rvkjellrqp .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#rvkjellrqp .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#rvkjellrqp .gt_from_md > :first-child {
  margin-top: 0;
}

#rvkjellrqp .gt_from_md > :last-child {
  margin-bottom: 0;
}

#rvkjellrqp .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#rvkjellrqp .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#rvkjellrqp .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rvkjellrqp .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#rvkjellrqp .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rvkjellrqp .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#rvkjellrqp .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rvkjellrqp .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rvkjellrqp .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#rvkjellrqp .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rvkjellrqp .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#rvkjellrqp .gt_left {
  text-align: left;
}

#rvkjellrqp .gt_center {
  text-align: center;
}

#rvkjellrqp .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#rvkjellrqp .gt_font_normal {
  font-weight: normal;
}

#rvkjellrqp .gt_font_bold {
  font-weight: bold;
}

#rvkjellrqp .gt_font_italic {
  font-style: italic;
}

#rvkjellrqp .gt_super {
  font-size: 65%;
}

#rvkjellrqp .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="rvkjellrqp" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<thead class="gt_header">

<tr>

<th colspan="4" class="gt_heading gt_title gt_font_normal" style>

Top 10 selon l’indicateur ‘(n\_relecture + n\_publi) / 2’

</th>

</tr>

<tr>

<th colspan="4" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>

</th>

</tr>

</thead>

<thead class="gt_col_headings">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

revue\_ouvrage

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

n\_relecture

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">

n\_publi

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

indicateur\_moy

</th>

</tr>

</thead>

<tbody class="gt_table_body">

<tr>

<td class="gt_row gt_left">

journal of water resources planning and management

</td>

<td class="gt_row gt_right">

29

</td>

<td class="gt_row gt_center">

10

</td>

<td class="gt_row gt_right">

19.5

</td>

</tr>

<tr>

<td class="gt_row gt_left">

journal of hydroinformatics, iwa

</td>

<td class="gt_row gt_right">

10

</td>

<td class="gt_row gt_center">

0

</td>

<td class="gt_row gt_right">

5.0

</td>

</tr>

<tr>

<td class="gt_row gt_left">

social indicators research

</td>

<td class="gt_row gt_right">

8

</td>

<td class="gt_row gt_center">

1

</td>

<td class="gt_row gt_right">

4.5

</td>

</tr>

<tr>

<td class="gt_row gt_left">

environmental science and policy

</td>

<td class="gt_row gt_right">

4

</td>

<td class="gt_row gt_center">

4

</td>

<td class="gt_row gt_right">

4.0

</td>

</tr>

<tr>

<td class="gt_row gt_left">

développement durable et territoires

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_center">

4

</td>

<td class="gt_row gt_right">

3.5

</td>

</tr>

<tr>

<td class="gt_row gt_left">

sud-ouest europeen

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_center">

6

</td>

<td class="gt_row gt_right">

3.5

</td>

</tr>

<tr>

<td class="gt_row gt_left">

land use policy

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_center">

5

</td>

<td class="gt_row gt_right">

3.0

</td>

</tr>

<tr>

<td class="gt_row gt_left">

vertigo

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_center">

5

</td>

<td class="gt_row gt_right">

3.0

</td>

</tr>

<tr>

<td class="gt_row gt_left">

forest policy and economics

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_center">

4

</td>

<td class="gt_row gt_right">

2.5

</td>

</tr>

<tr>

<td class="gt_row gt_left">

natures sciences sociétés

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_center">

4

</td>

<td class="gt_row gt_right">

2.5

</td>

</tr>

</tbody>

</table>

</div>

<!--/html_preserve-->

### Partenariats

#### Interdisciplinarité proche (interne)

A partir du tableau rempli par l’équipe du GT4, nous pouvons créer une
liste de noms d’auteurs (prenant en compte toutes les syntaxes possibles
d’un même nom) appartenant à ETBX.

``` r
table_auteurs <- readxl::read_excel("data/table_auteurs_ETBX_2020-07-27_SL_DC.xlsx") %>% clean_names()


liste_auteurs_etbx <- table_auteurs %>% filter(etbx_oui_non %in% c("oui","temporaire", "oui / BSA", "temporaire ?")) %>% 
  pull(auteur)


# liste_auteurs_etbx <- gsub('^\\.|\\.$', '', liste_auteurs_etbx) %>% unique()

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

ANX4$i_1_articles_sctfq %>% clean_names() %>% 
  select(reference_complete) %>% 
  rowwise() %>% 
  mutate(nb_copubli = calcul_nb_copubli(reference_complete)) %>% 
  ungroup() %>% arrange(desc(nb_copubli)) %>% 
  slice(1:10) %>% 
  gt() %>%
  tab_header(title = "Top 10 des publications en nombre d'agents ETBX associés") %>%
  tab_options(table.width = pct(100))
```

<!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#mcpcpmsffp .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  width: 100%;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#mcpcpmsffp .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#mcpcpmsffp .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#mcpcpmsffp .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#mcpcpmsffp .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mcpcpmsffp .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#mcpcpmsffp .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#mcpcpmsffp .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#mcpcpmsffp .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#mcpcpmsffp .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#mcpcpmsffp .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#mcpcpmsffp .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#mcpcpmsffp .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#mcpcpmsffp .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#mcpcpmsffp .gt_from_md > :first-child {
  margin-top: 0;
}

#mcpcpmsffp .gt_from_md > :last-child {
  margin-bottom: 0;
}

#mcpcpmsffp .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#mcpcpmsffp .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#mcpcpmsffp .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mcpcpmsffp .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#mcpcpmsffp .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mcpcpmsffp .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#mcpcpmsffp .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mcpcpmsffp .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#mcpcpmsffp .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#mcpcpmsffp .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#mcpcpmsffp .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#mcpcpmsffp .gt_left {
  text-align: left;
}

#mcpcpmsffp .gt_center {
  text-align: center;
}

#mcpcpmsffp .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#mcpcpmsffp .gt_font_normal {
  font-weight: normal;
}

#mcpcpmsffp .gt_font_bold {
  font-weight: bold;
}

#mcpcpmsffp .gt_font_italic {
  font-style: italic;
}

#mcpcpmsffp .gt_super {
  font-size: 65%;
}

#mcpcpmsffp .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="mcpcpmsffp" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<thead class="gt_header">

<tr>

<th colspan="2" class="gt_heading gt_title gt_font_normal" style>

Top 10 des publications en nombre d’agents ETBX associés

</th>

</tr>

<tr>

<th colspan="2" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>

</th>

</tr>

</thead>

<thead class="gt_col_headings">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

reference\_complete

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">

nb\_copubli

</th>

</tr>

</thead>

<tbody class="gt_table_body">

<tr>

<td class="gt_row gt_left">

Banos, V., Gassiat, A., Girard, S., Hautdidier, B., Houdart, M., Le
Floch S., Vernier F., 2020, L’écologisation, mise à l’épreuve ou nouveau
registre de légitimation de l’ordre territorial ? Une lecture à partir
des particularités du débat conceptuel en France, Développement durable
et territoires (à paraître)

</td>

<td class="gt_row gt_center">

7

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Drouineau, H., Carter, C., Rambonilaza, M., Beaufaron, G., Bouleau, G.,
Gassiat, A., Lambert, P., Le Floch, S., Tétard, S., De Oliveira, E. -
2018. River Continuity Restoration and Diadromous Fishes: Much More than
an Ecological Issue. Environmental Management, vol. 61, n° 4, p. 671-686

</td>

<td class="gt_row gt_center">

5

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Vernier, F., Leccia Phelpin, O., Lescot, J.M., Minette, S., Miralles,
A., Barberis, D., Scordia, C., Kuentz Simonet, V., Tonneau, J.P. - 2017.
Integrated modeling of agricultural scenarios (IMAS) to support
pesticide action plans: the case of the Coulonge drinking water
catchment area (SW France). Environmental Science and Pollution
Research, vol. 24, n° 8, p. 6923-6950

</td>

<td class="gt_row gt_center">

5

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Zahm, F., Barbier, J.M., Cohen, S., Boureau, H., Girard, S., Carayon,
D., Alonso Ugaglia, A., Del’homme, B., Gafsi, M., Gasselin, P.,
Guichard, L., Loyce, C., Manneville, V., Redlingshöfer, B. - 2019. IDEA4
: une méthode de diagnostic pour une évaluation clinique de la
durabilité en agriculture . Agronomie, Environnement et Sociétés,
vol. 9, n° 2, p. 39-51

</td>

<td class="gt_row gt_center">

5

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Renaud, E., Husson, A., Vacelet, A., Le Gat, Y., Stricker, A. E.,  -
2020. Statistical modelling of French drinking water pipe inventory at
national level using demographic and geographical information. H2Open
Journal IWA Publishing Vol 3 No 1 p. 89-101

</td>

<td class="gt_row gt_center">

5

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Candau, J., Deuffic, P., Kuentz Simonet, V., Lyser, S. - 2017. Entre
environnement, marché, territoire : agriculteurs en quête de sens pour
leur métier. Regards Sociologiques, vol. 50-51, p. 45-81

</td>

<td class="gt_row gt_center">

4

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Cazals, C., Lyser, S., Bouleau, G., Hautdidier, B. - 2018. Quels
écotourismes sur le bassin d’Arcachon ? Diversités et contradiction sur
une territoire confrontéà son attractivité résidentielle . Sud-Ouest
Europeen, n° 45, p. 139-156

</td>

<td class="gt_row gt_center">

4

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Ginelli, L., Candau, J., Girard, S., Houdart, S., Deldrève, V. - 2020.
Écologisation des pratiques et territorialisation des activités : une
introduction . Développement durable et territoires,

</td>

<td class="gt_row gt_center">

4

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Hautdidier, B., Banos, V., Deuffic, P., Sergent, A. - 2018. Leopards
under the pines: An account of continuity and change in the integration
of forest land-uses in Landes de Gascogne, France. Land Use Policy,
vol. 79, p. 990-1000

</td>

<td class="gt_row gt_center">

4

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Zahm, F., Alonso Ugaglia, A., Barbier, J.M., Boureau, H., Del’homme, B.,
Gafsi, M., Gasselin, P., Girard, S., Guichard, L., Loyce, C.,
Manneville, V., Menet, A., Redlingshöfer, B. - 2019. Évaluer la
durabilité des exploitations agricoles : La méthode IDEA v4, un cadre
conceptuel combinant dimensions et propriétés de la durabilité . Cahiers
Agricultures, vol. 28, n° 5, 10 p

</td>

<td class="gt_row gt_center">

4

</td>

</tr>

</tbody>

</table>

</div>

<!--/html_preserve-->

Nous pouvons maintenant nous intéresser aux disciplines :

``` r
table_disciplines <- table_auteurs %>% filter(etbx_oui_non %in% c("oui","temporaire", "oui / BSA", "temporaire ?")) %>% 
  select(auteur,discipline) %>% drop_na()


calcul_discipline <- function(x) {
  
  df <- data.frame(auteur = liste_auteurs_etbx[str_detect(x,liste_auteurs_etbx)] %>% gsub('^\\.|\\.$', '', .) %>% unique() )
  
  df %>% inner_join(table_disciplines, by = "auteur") %>% pull(discipline) %>% unique() %>% paste(collapse = " / ")
  
}

ANX4$i_1_articles_sctfq %>% clean_names() %>% 
  select(reference_complete) %>% 
  rowwise() %>% 
  mutate(disciplines = calcul_discipline(reference_complete)) %>% 
  mutate(nb_disciplines = str_split(disciplines, " / ")[[1]] %>% length) %>% 
  ungroup() %>% 
  arrange(desc(nb_disciplines)) %>% 
  slice(1:10) %>% 
  gt() %>%
  tab_header(title = "Top 10 du nombre de disciplines combinées entre agents ETBX") %>%
  tab_options(table.width = pct(100))
```

<!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#khqtckgldq .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  width: 100%;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#khqtckgldq .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#khqtckgldq .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#khqtckgldq .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#khqtckgldq .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#khqtckgldq .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#khqtckgldq .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#khqtckgldq .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#khqtckgldq .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#khqtckgldq .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#khqtckgldq .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#khqtckgldq .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#khqtckgldq .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#khqtckgldq .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#khqtckgldq .gt_from_md > :first-child {
  margin-top: 0;
}

#khqtckgldq .gt_from_md > :last-child {
  margin-bottom: 0;
}

#khqtckgldq .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#khqtckgldq .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#khqtckgldq .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#khqtckgldq .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#khqtckgldq .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#khqtckgldq .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#khqtckgldq .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#khqtckgldq .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#khqtckgldq .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#khqtckgldq .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#khqtckgldq .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#khqtckgldq .gt_left {
  text-align: left;
}

#khqtckgldq .gt_center {
  text-align: center;
}

#khqtckgldq .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#khqtckgldq .gt_font_normal {
  font-weight: normal;
}

#khqtckgldq .gt_font_bold {
  font-weight: bold;
}

#khqtckgldq .gt_font_italic {
  font-style: italic;
}

#khqtckgldq .gt_super {
  font-size: 65%;
}

#khqtckgldq .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="khqtckgldq" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<thead class="gt_header">

<tr>

<th colspan="3" class="gt_heading gt_title gt_font_normal" style>

Top 10 du nombre de disciplines combinées entre agents ETBX

</th>

</tr>

<tr>

<th colspan="3" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>

</th>

</tr>

</thead>

<thead class="gt_col_headings">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

reference\_complete

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

disciplines

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">

nb\_disciplines

</th>

</tr>

</thead>

<tbody class="gt_table_body">

<tr>

<td class="gt_row gt_left">

Cazals, C., Lyser, S., Bouleau, G., Hautdidier, B. - 2018. Quels
écotourismes sur le bassin d’Arcachon ? Diversités et contradiction sur
une territoire confrontéà son attractivité résidentielle . Sud-Ouest
Europeen, n° 45, p. 139-156

</td>

<td class="gt_row gt_left">

sciences po / économie / géographie / statistique

</td>

<td class="gt_row gt_center">

4

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Banos, V., Gassiat, A., Girard, S., Hautdidier, B., Houdart, M., Le
Floch S., Vernier F., 2020, L’écologisation, mise à l’épreuve ou nouveau
registre de légitimation de l’ordre territorial ? Une lecture à partir
des particularités du débat conceptuel en France, Développement durable
et territoires (à paraître)

</td>

<td class="gt_row gt_left">

géographie / sciences agronomiques et économiques / sciences de
l’environnement

</td>

<td class="gt_row gt_center">

3

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Drouineau, H., Carter, C., Rambonilaza, M., Beaufaron, G., Bouleau, G.,
Gassiat, A., Lambert, P., Le Floch, S., Tétard, S., De Oliveira, E. -
2018. River Continuity Restoration and Diadromous Fishes: Much More than
an Ecological Issue. Environmental Management, vol. 61, n° 4, p. 671-686

</td>

<td class="gt_row gt_left">

sciences po / géographie / économie

</td>

<td class="gt_row gt_center">

3

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Hautdidier, B., Banos, V., Deuffic, P., Sergent, A. - 2018. Leopards
under the pines: An account of continuity and change in the integration
of forest land-uses in Landes de Gascogne, France. Land Use Policy,
vol. 79, p. 990-1000

</td>

<td class="gt_row gt_left">

géographie / sociologie / sciences po

</td>

<td class="gt_row gt_center">

3

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Vernier, F., Leccia Phelpin, O., Lescot, J.M., Minette, S., Miralles,
A., Barberis, D., Scordia, C., Kuentz Simonet, V., Tonneau, J.P. - 2017.
Integrated modeling of agricultural scenarios (IMAS) to support
pesticide action plans: the case of the Coulonge drinking water
catchment area (SW France). Environmental Science and Pollution
Research, vol. 24, n° 8, p. 6923-6950

</td>

<td class="gt_row gt_left">

statistique / sciences de l’environnement / sciences agronomiques et
économiques

</td>

<td class="gt_row gt_center">

3

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Aouadi N., Macary F., Alonso Ugaglia A., 2020. Evaluation multicritère
des performances socio-économiques et environnementales de systèmes
viticoles et de scénarios de transition agroécologique, Cahiers
Agriculture. Article accepté pour publication (mai 2020).

</td>

<td class="gt_row gt_left">

sciences agronomiques et économiques / sciences de l’environnement

</td>

<td class="gt_row gt_center">

2

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Ayala Cabrera, D., Piller, O., Herrera, M., Gilbert, D., Deuerlein, J. -
2019. Absorptive Resilience Phase Assessment Based on Criticality
Performance indicators for Water Distribution Networks. Journal of Water
Resources Planning and Management, vol. 149, n° 9, 15 p.

</td>

<td class="gt_row gt_left">

mathématiques / hydraulique

</td>

<td class="gt_row gt_center">

2

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Banos, V., Deuffic, P., 2020, Après la catastrophe, bifurquer ou
persévérer ? Les forestiers à l’épreuve des événements climatiques
extrêmes, Natures Sciences Sociétés, n°4 ( à paraître)

</td>

<td class="gt_row gt_left">

géographie / sociologie

</td>

<td class="gt_row gt_center">

2

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Banos, V., Dehez, J. - 2017. Le bois-énergie dans la tempête, entre
innovation et captation ? Les nouvelles ressources de la forêt landaise.
Natures Sciences Sociétés, vol. 25, n° 2, p. 122-133

</td>

<td class="gt_row gt_left">

géographie / économie

</td>

<td class="gt_row gt_center">

2

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Brahic, E., Deuffic, P. - 2017. Comportement des propriétaires
forestiers landais vis-à-vis du bois énergie : Une analyse
micro-économique. Economie Rurale, n° 359, p. 7-25

</td>

<td class="gt_row gt_left">

économie / sociologie

</td>

<td class="gt_row gt_center">

2

</td>

</tr>

</tbody>

</table>

</div>

<!--/html_preserve-->

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
