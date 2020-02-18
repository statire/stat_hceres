
# Statistiques ETBX pour l’HCERES 2020

# Initialisation et import des données

``` r
## Manipulation de données
library(tidyverse)
library(purrr)
library(igraph)

## Package pour l'import de .bib
library(bib2df)
library(bibliometrix)

## Thème INRAE
source("R/theme_inrae.R")
```

``` r
# Liste des fichiers bib irsteadoc
list_bib <- list.files(pattern = "\\.bib$")[-1] # Pour ne pas prendre biball

# Import et mise en tableau
bib_df <- purrr::map_df(list_bib,bib2df::bib2df)
```

# Barplot général de toutes les entrées

``` r
bib_df %>% select(NOTE, AUTHOR, TITLE, YEAR) %>% 
  unnest(AUTHOR) %>% 
  group_by(YEAR,NOTE) %>% 
  summarise(n = n_distinct(TITLE)) %>% 
  ungroup() %>% 
  arrange(desc(n)) %>% 
  
  ggplot(aes(x = reorder(NOTE, n), y = n)) +
  geom_col(color = "black", aes(fill = NOTE))+
  geom_label(aes(label = n)) +
  facet_wrap(~YEAR, scales = "free") +
  guides(fill = FALSE) +
  coord_flip() +
  theme_inrae() +
  labs(title = "Nombre d'entrées bibliographiques par catégorie de document", subtitle = "Tous les agents confondus", caption = "Export IrsteaDoc du 06/02/2020") +
  theme(axis.title = element_blank()) 
```

<img src="README_files/figure-gfm/unnamed-chunk-1-1.png" width="100%" />

> TO-DO: Idem mais “chercheurs” uniquement

# Nombre d’Article à Comité de Lecture (ACL) par année.

``` r
bib_df %>% select(NOTE, AUTHOR, TITLE, YEAR) %>% 
  unnest(AUTHOR) %>% 
  group_by(YEAR, NOTE) %>%
  filter(NOTE %in% c("Article de revue scientifique à comité de lecture","Communication scientifique avec actes")) %>% 
  summarise(n = n_distinct(TITLE)) %>% 
  mutate(n_publi = sum(n)) %>% 
  ungroup() %>% 
  arrange(YEAR) %>% 
  mutate(YEAR = as.character(YEAR)) %>% 
  
  ggplot(aes(x = YEAR, y = n)) +
  geom_col(color = "black", aes(fill = NOTE))+
  geom_label(aes(y = n_publi,label = n_publi), size = 6) +
  scale_fill_inrae(name = "Catégorie")+
  theme_inrae() +
  theme(axis.title.x = element_blank())+
  labs(title = "Nombre d'ACL par année", subtitle = "Tous les agents confondus", y = "Nombre d'ACL")
```

<img src="README_files/figure-gfm/unnamed-chunk-2-1.png" width="100%" />

> TO-DO: Idem mais “chercheurs” uniquement

# Sélection des auteurs ETBX

> TODO : Attention il faudra regrouper manuellement certains noms
> composés … Adeline Alonso-Ugaglia par exemple de BSA y est 2 fois (et
> ça a sûrement pu arriver pour des gens d’ETBX). Dans ce cas là, les
> noter et on fusionnera ici ces noms avant de faire des
stats/graphes.

``` r
# Il y 5 entrées qui sont problématiques (pas le meme nombre d'auteur et d"affilliation, qui sont les critères que j'utilise) et à corriger manuellement (pour le moment retirées) :
a_traiter <-  c("PUB00057566","PUB00057565","PUB00061139","PUB00063885","PUB00056781")


auteurs_ETBX <- bib_df %>%
  select(AUTHOR,AFFILIATION, BIBTEXKEY) %>%
  filter(!BIBTEXKEY %in% a_traiter) %>%
  rowwise() %>%
  mutate(AFFILIATION = list(as.list(strsplit(AFFILIATION, ";")[[1]]))) %>% 
  unnest() %>%
  unnest() %>% 
  mutate(AFFILIATION = str_trim(AFFILIATION)) %>% 
  filter(AFFILIATION %in% c("IRSTEA BORDEAUX UR ETBX FRA","INRAE BORDEAUX UR ETBX FRA")) %>%
  distinct(AUTHOR) %>%
  pull()

auteurs_ETBX
```

    ##  [1] "Kuentz Simonet, V."   "Labenne, A."          "Rambonilaza, T."     
    ##  [4] "Lescot, J.M."         "Terreaux, J.P."       "Vernier, F."         
    ##  [7] "Leccia Phelpin, O."   "Barberis, D."         "Scordia, C."         
    ## [10] "Carter, C."           "Rulleau, B."          "Piller, O."          
    ## [13] "Ginelli, L."          "Gilbert, D."          "Ung, H."             
    ## [16] "Dehez, J."            "Banos, V."            "Krieger, S.J."       
    ## [19] "Deldrève, V."         "Aka, J."              "Bouleau, G."         
    ## [22] "Salles, D."           "Brahic, E. "          "Deuffic, P."         
    ## [25] "Dachary Bernard, J."  "Candau, J."           "Gassiat, A."         
    ## [28] "Lafon, S."            "Brahic, E."           "Hautdidier, B."      
    ## [31] "Le Floch, S."         "Ayala Cabrera, D."    "Braun, M."           
    ## [34] "Le Gat, Y."           "Zahm, F."             "Hervé, L."           
    ## [37] "Dubot, C."            "Sergent, A."          "Carter, C"           
    ## [40] "Rocle, N."            "Large, A."            "Tomasian, M."        
    ## [43] "Renaud, E."           "Pallandre, K."        "Cholet, L."          
    ## [46] "Vacelet, A."          "Husson, A."           "Stricker, A.E."      
    ## [49] "Metin, J."            "Lyser, S."            "Joalland, O."        
    ## [52] "Macary, F."           "Labbouz, B."          "Leccia, O."          
    ## [55] "Kuentz Simmonet, V."  "Migneaux, Marie"      "Ayala, D."           
    ## [58] "Gremmel, J."          "Pham, T."             "Rambonilaza, M."     
    ## [61] "Ben Adj Abdallah, K." "Boschet, C."          "Pillot, J."          
    ## [64] "Aubrun, C."           "Bouet, B."            "Deldreve, V."        
    ## [67] "Migneaux, M."         "Aouadi, N."           "Le Net, J."          
    ## [70] "Bouleau, G"           "Vergneau, F."         "Thomas, A."          
    ## [73] "Girard, S."           "Petit, K."            "Stricker, A. E."     
    ## [76] "LATOUR, Jeanne"       "Conchon, P."          "Ivanovsky, V."       
    ## [79] "Cazals, C."           "Legat, Y."            "Kuentz-Simonet, V."  
    ## [82] "Ginter, Z."           "Leccia-Phelpin, O."   "Banos, V"            
    ## [85] "Roussary, A."         "Mainguy, G."          "De Godoy Leski, C."  
    ## [88] "Andro, L."            "Dachary-Bernard, J."  "Drouaud, F."         
    ## [91] "Uny, D."              "LeGat, Y."            "Chambon, C."         
    ## [94] "Guerendel, F."        "Boutet, A.C."

# Récupération de données bibliométriques

Les données telles que le nombre de citations ne sont pas présentes dans
l’export IrsteaDoc. Il faut donc chercher ces informations par une
requête sur les principaux moteurs de recherche dédiés. Scopus a fourni
le plus de résultats avec 58 retours basés sur le DOI. Environ 40 infos
de citation ont également été récupérées manuellement via google
scholar.

## Construction de la base de DOIs

``` r
## J'ai retrouvé quelques DOI à la main
complement_doi <- read_csv2("complement_doi.csv")

## Ces 16 entrées ne sont que dans HAL (aucune info citation)
doi_hal <- complement_doi %>% filter(str_detect(DOI,"hal-"))

## Ces entrées ont un DOI OK à ajouter
doi_ok <- complement_doi %>% filter(str_detect(DOI,"10.")) %>% select(-citations)

## Ces entrées n'ont pas de DOI mais j'ai relevé quand c'était possible leur nombre de citations
citations <- complement_doi %>% filter(!is.na(citations)) %>% rename(nb_citations=citations) %>% 
  select(BIBTEXKEY,nb_citations)

base_doi <- bib_df %>% 
  filter(NOTE %in% c("Article de revue scientifique à comité de lecture","Communication scientifique avec actes")) %>% 
  select(BIBTEXKEY,AUTHOR,TITLE,DOI) %>% 
  mutate(DOI = str_remove_all(DOI,"http://dx.doi.org/")) %>%
  filter(!BIBTEXKEY %in% doi_ok$BIBTEXKEY) %>%
  bind_rows(doi_ok) %>% drop_na(DOI)
```

## Requête SCOPUS

``` r
## Voici la requête à effectuer sur Scopus > Advanced
Scopus_Request <- base_doi %>% 
  mutate(request = paste0("DOI(",DOI,")")) %>% 
  pull(request) %>% 
  paste0(collapse = " OR ")

## On lit l'export Scopus

scopus_data_raw <- bibliometrix::readFiles("bdd_biblio/scopus_doi.bib") %>% 
  bibliometrix::convert2df(dbsource = "scopus", format = "bibtex")
```

    ## 
    ## Converting your scopus collection into a bibliographic dataframe
    ## 
    ## Articles extracted   58 
    ## Done!
    ## 
    ## 
    ## Generating affiliation field tag AU_UN from C1:  Done!

``` r
scopus_data <- scopus_data_raw  %>% tbl_df() %>% 
  select(DOI = DI,nb_citations = TC) %>%
  arrange(desc(nb_citations))

## On refait la jointure avec les données initiales, et on ajoute les données de citation
new_bib_df <- scopus_data %>%
  mutate(DOI = tolower(DOI)) %>%
  inner_join(base_doi %>% mutate(DOI = tolower(DOI)), by = "DOI") %>%
  select(BIBTEXKEY,nb_citations) %>%
  bind_rows(citations) %>% 
  full_join(bib_df, by = "BIBTEXKEY") %>% 
  unique()
```

Nous avons récupé des information bibliométriques Scopus (dont les
citations) pour 94 ACL /
125.

## Analyse du nombre de citations

``` r
nb_citations_an <- new_bib_df %>% group_by(YEAR) %>% summarise(nb_citations = sum(nb_citations,na.rm=TRUE))
nb_citations_an
```

<div class="kable-table">

| YEAR | nb\_citations |
| ---: | ------------: |
| 2017 |           137 |
| 2018 |            78 |
| 2019 |            26 |
| 2020 |             1 |

</div>

``` r
# On enlève 2020 car plombe le résultat.
nb_moy_citation_an <- mean(nb_citations_an$nb_citations[-4]) 
nb_moy_citation_an
```

    ## [1] 80.33333

On a donc 80 citations en moyenne par an sur la base de 94 documents
parmis les 125 recensés ACL (sur 2017-2019). En toute logique, les
articles publiés en 2017 ont été cités plus de fois (car plus nombreux,
et surtout plus anciens).

# Collaborations

## National

``` r
vec_affiliations <- new_bib_df %>%
  select(AFFILIATION) %>% 
  mutate(delinked = str_split(AFFILIATION, " ; ")) %>% 
  pull(delinked) %>%
  unlist() 

links <- tibble(origin = "INRAE BORDEAUX UR ETBX FRA", collab = vec_affiliations) %>% 
  filter(!collab %in% c("IRSTEA BORDEAUX UR ETBX FRA","INRAE BORDEAUX UR ETBX FRA")) %>% 
  mutate(origin_country = str_sub(origin, start= -3)) %>% 
  mutate(collab_country = str_sub(collab, start= -3)) %>% 
  filter(collab_country == "FRA") %>% 
  select(-origin_country,-collab_country) %>% 
  group_by(origin) %>% 
  count(collab) %>%
  ungroup() 
```

``` r
n_distinct(links$collab)
```

    ## [1] 143

> **ETBX a co-publié avec 143 structures françaises différentes.**

### Vision barplot top 10

Visualisation des 10 structures françaises avec lesquelles ETBX
collabore le plus :

``` r
links %>%
  arrange(desc(n)) %>%
  slice(1:10) %>% 

ggplot(aes(x = reorder(collab,n), y = n)) +
  geom_col(fill = "#00a3a6", color ="black") +
  geom_label(aes(label = n)) +
  coord_flip() +
  theme_inrae() +
  labs(y = "Nombre de co-publications", x = "Structure", title = "Nombre de collaborations nationales")
```

<img src="README_files/figure-gfm/unnamed-chunk-9-1.png" width="100%" />

### Vision network

J’ai tenté de remplacer les noms de structure par des abbréviations pour
que ça soit lisible… mais c’est presque incompréhensible…

``` r
links$collab <- toupper(abbreviate(links$collab))

network <- igraph::graph_from_data_frame(d=links, directed=F) 

plot(network, edge.width = E(network)$importance/2)
```

<img src="README_files/figure-gfm/unnamed-chunk-10-1.png" width="100%" />

## International

``` r
vec_affiliations <- new_bib_df %>%
  filter(NOTE %in% c("Article de revue scientifique à comité de lecture","Communication scientifique avec actes")) %>% 
  select(AFFILIATION) %>% 
  mutate(delinked = str_split(AFFILIATION, " ; ")) %>% 
  pull(delinked) %>%
  unlist() 

links <- tibble(origin = "INRAE BORDEAUX UR ETBX FRA", collab = vec_affiliations) %>% 
  filter(!collab %in% c("IRSTEA BORDEAUX UR ETBX FRA","INRAE BORDEAUX UR ETBX FRA")) %>% 
  mutate(origin_country = str_sub(origin, start= -3)) %>% 
  mutate(collab_country = str_sub(collab, start= -3)) %>% 
  mutate(collab_country = toupper(collab_country)) %>% 
  group_by(origin_country) %>% 
  count(collab_country) %>%
  ungroup() %>%
  select(origin_country,collab_country,importance=n) %>% 
  filter(!collab_country %in% c("FRA","-")) %>% 
  mutate(origin_country = recode(origin_country,"FRA"="ETBX")) 
```

``` r
n_distinct(links$collab_country)
```

    ## [1] 38

> **ETBX a co-publié avec 38 pays différents.**

### Vision barplot top 10

Visualisation des 10 pays avec lesquels ETBX collabore le plus :

``` r
links %>%
  arrange(desc(importance)) %>%
  slice(1:10) %>% 

ggplot(aes(x = reorder(collab_country,importance), y = importance)) +
  geom_col(fill = "#00a3a6", color ="black") +
  geom_label(aes(label = importance)) +
  coord_flip() +
  theme_inrae() +
  labs(y = "Nombre de co-publications", x = "Pays", title = "Top 10 des pays collaborateurs")
```

<img src="README_files/figure-gfm/unnamed-chunk-13-1.png" width="100%" />

### Vision network

``` r
network <- igraph::graph_from_data_frame(d=links, directed=F) 

plot(network, edge.width = E(network)$importance/2)
```

<img src="README_files/figure-gfm/unnamed-chunk-14-1.png" width="100%" />
