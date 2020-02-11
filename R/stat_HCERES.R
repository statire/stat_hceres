# TODO : 
# Définir le statut de chercheur pour les métriques "nombre de publications par chercheur" (chez EABX, ils ont pris CR/DR). Et récupérer (Cathy ?) une liste des statuts
# Traiter les éventuels conflits de noms composés

library(tidyverse)
library(purrr)

## Package pour l'import de .bib
library(bib2df)

## Thème INRAE
source("R/theme_inrae.R")

# Liste des fichiers bib irsteadoc
list_bib <- list.files(pattern = ".bib")

# Import et mise en tableau
bib_df <- purrr::map_df(list_bib,bib2df::bib2df)


# 1. Barplot du nombre d'entrées par catégorie (tout auteur confondu) --------
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
  labs(title = "Nombre d'entrées bibliographiques par catégorie de document", subtitle = "Tous les agents confondus") +
  theme(axis.title = element_blank()) +
  ggsave("Figures/Barplot_entrees_document.png", dpi = "retina", width = 17, height = 8.79)

## Chercheurs uniquement
## TODO

# 2. Nombre d'ACL (article comité de lecture) par année ----------------------
## Note : J'ai compté les actes de colloques comme ACL.

## Tout auteur confondu
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
  geom_label(aes(y = n_publi,label = n_publi)) +
  scale_fill_inrae(name = "Catégorie")+
  theme_inrae() +
  theme(axis.title.x = element_blank())+
  labs(title = "Nombre d'ACL par année", subtitle = "Tous les agents confondus", y = "Nombre d'ACL")  +
  ggsave("Figures/Barplot_ACL_Annee.png", dpi = "retina", width = 13.2, height = 8.79)


## Chercheurs uniquement
## TODO

# 3. Top 10 auteurs ETBX (a garder en interne je suppose...) --------------------------------------------------

# Il y 5 entrées qui sont problématiques (pas le meme nombre d'auteur et d"affilliation, qui sont les critères que j'utilise) et à corriger manuellement (pour le moment retirées) :
a_traiter <-  c("PUB00057566","PUB00057565","PUB00061139","PUB00063885","PUB00056781")

## Attention il faudra regrouper manuellement certains noms composés ... Adeline Alonso-Ugaglia par exemple de BSA y est 2 fois (et ça a sûrement pu arriver pour des gens d'ETBX). Dans ce cas là, les noter et on fusionnera ici ces noms avant de faire des stats/graphes.

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

top_10_auteurs <- bib_df %>%
  select(BIBTEXKEY,NOTE, AUTHOR, TITLE, YEAR, AFFILIATION) %>% 
  unnest(AUTHOR) %>% 
  filter(AUTHOR %in% auteurs_ETBX) %>% 
  group_by(AUTHOR) %>% 
  summarise(n_key = n_distinct(BIBTEXKEY)) %>% 
  ungroup() %>% 
  arrange(desc(n_key)) %>% 
  slice(1:10) %>% pull(AUTHOR)

## 3.1 Top d'entrées par auteur ETBX
bib_df %>% select(BIBTEXKEY,NOTE, AUTHOR, TITLE, YEAR, AFFILIATION) %>% 
  unnest(AUTHOR) %>% 
  filter(AUTHOR %in% auteurs_ETBX) %>% 
  group_by(AUTHOR) %>% 
  summarise(n_key = n_distinct(BIBTEXKEY)) %>% 
  ungroup() %>% 
  arrange(desc(n_key)) %>% 
  filter(AUTHOR %in% top_10_auteurs) %>%
  
  ggplot(aes(x = reorder(AUTHOR, n_key), y =  n_key)) +
  geom_col(fill = "#00a3a6", color = "black") +
  geom_label(aes(label = n_key)) +
  coord_flip() +
  guides(fill = FALSE) +
  theme_inrae() +
  labs(y = "Nombre d'entrées")+
  theme(axis.title.y = element_blank())


## 3.2 Top d'ACL par auteur ETBX
bib_df %>% select(BIBTEXKEY,NOTE, AUTHOR, TITLE, YEAR, AFFILIATION) %>% 
  unnest(AUTHOR) %>% 
  filter(AUTHOR %in% auteurs_ETBX) %>% 
  filter(NOTE %in% c("Article de revue scientifique à comité de lecture","Communication scientifique avec actes")) %>% 
  group_by(AUTHOR) %>% 
  summarise(n_key = n_distinct(BIBTEXKEY)) %>% 
  ungroup() %>% 
  arrange(desc(n_key)) %>% 
  filter(AUTHOR %in% top_10_auteurs) %>%
  
  ggplot(aes(x = reorder(AUTHOR, n_key), y =  n_key)) +
  geom_col(fill = "#00a3a6", color = "black") +
  geom_label(aes(label = n_key)) +
  coord_flip() +
  guides(fill = FALSE) +
  theme_inrae() +
  labs(y = "Nombre d'ACL")+
  theme(axis.title.y = element_blank())



# 4. Analyse nombre de citations -------------------------------------------


# 4.1 Requête Scopus & manuelle basée sur DOI -----------------------------

## J'ai retrouvé quelques DOI à la main
complement_doi <- read_csv2("complement_doi.csv")

## Ces 16 entrées ne sont que dans HAL (aucune info citation)
doi_hal <- complement_doi %>% filter(str_detect(DOI,"hal-"))

## Ces entrées ont un DOI OK à ajouter
doi_ok <- complement_doi %>% filter(str_detect(DOI,"10.")) %>% select(-citations)

## Ces entrées n'ont pas de DOI mais j'ai relevé quand c'était possible leur nombre de citations
citations <- complement_doi %>% filter(!is.na(citations)) %>% rename(nb_citations=citations) %>% 
  select(BIBTEXKEY,nb_citations)

## Base des DOI actualisée
base_doi <- bib_df %>% 
  filter(NOTE %in% c("Article de revue scientifique à comité de lecture","Communication scientifique avec actes","Article de revue technique à comité de lecture")) %>% 
  select(BIBTEXKEY,AUTHOR,TITLE,DOI) %>% 
  mutate(DOI = str_remove_all(DOI,"http://dx.doi.org/")) %>%
  filter(!BIBTEXKEY %in% doi_ok$BIBTEXKEY) %>%
  bind_rows(doi_ok) %>% drop_na(DOI)


## 1ère requête par le DOI : 58 publis retrouvées sur Scopus (+ que sur WoS) 

## Voici la requête à effectuer sur Scopus > Advanced
Scopus_Request <- base_doi %>% 
  mutate(request = paste0("DOI(",DOI,")")) %>% 
  pull(request) %>% 
  paste0(collapse = " OR ")

## On lit l'export Scopus
scopus_data <- readFiles("bdd_biblio/scopus_doi.bib") %>% 
  convert2df(dbsource = "scopus", format = "bibtex") %>% tbl_df() %>% 
  select(DOI = DI,nb_citations = TC) %>%
  arrange(desc(nb_citations))

## On refait la jointure avec les données initiales, et on ajoute les données de citation
new_bib_df <- scopus_data %>%
  mutate(DOI = tolower(DOI)) %>%
  inner_join(base_doi %>% mutate(DOI = tolower(DOI)), by = "DOI") %>%
  select(BIBTEXKEY,nb_citations) %>%
  bind_rows(citations) %>% 
  full_join(bib_df, by = "BIBTEXKEY")

# Nous voilà donc avec des données de citation obtenues pour 94/124 ACL.


# 4.2 Statistiques sur les citations --------------------------------------
nb_citations_an <- new_bib_df %>% group_by(YEAR) %>% summarise(nb_citations = sum(nb_citations,na.rm=TRUE))
nb_moy_citation_an <- mean(nb_citations_an$nb_citations[-4]) # On enlève 2020 car plombe le résultat.

# On a donc 80 citations en moyenne par an sur la base de 94 documents parmis les 124 recensés ACL (sur 2017-2019).