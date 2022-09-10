library(shiny)
library(shinythemes)
library(highcharter)
library(tidyr)
library(dplyr)
library(shinyjs)
library(data.table)
library(sf)
library(leaflet)
library(htmltools)
library(RColorBrewer)
library(markdown)
#https://shiny.rstudio.com/gallery/superzip-example.htmlhttps://shiny.rstudio.com/gallery/superzip-example.html

source("utils/graphs_funs.R")

# listă orașe din tabel selectInput care au date cities
cities <- list.files("www/data/tabs/suhi", pattern = "^suhi", full.names = T) %>%
  strsplit(., "suhi_|_v02.csv") %>% do.call(rbind, .) %>% as_tibble() 

select_input_cities <- read.csv("www/data/tabs/select_input_cities.csv") %>%
  arrange(label) %>% 
  filter(!label %in% c("Vaduz","Reykjavik", "Nur Sultan", "Amman", "Monaco", "Beirut", "Baku","Citta di San Marino", "Vatican","Jerusalem", "Valletta", "Monaco Ville" )) %>% 
  left_join(cities, by = c("choice" = "V2"))

# pentru dropdown graphs cities
choices <- setNames(select_input_cities$choice,paste0(select_input_cities$label, " (", select_input_cities$country,")"))
cities_map <- st_read("www/data/shp/cities_one_file.shp") %>% 
  mutate(city =  strsplit(name, "-") %>% do.call(rbind, .) %>% as_tibble() %>% dplyr::select(V2) %>% unlist()) %>%
  filter(city %in% select_input_cities$choice)

# pentru dropdown parameters maps
choices_map <- read.csv("www/data/tabs/slelect_input_parameters.csv") 
choices_map <-   setNames(choices_map$choice, choices_map$parameter)
       

# read all uhi files
files.suhi <- list.files("www/data/tabs/suhi/", "^suhi", full.names = T)
dt.suhi <- lapply(files.suhi, fread) 
names(dt.suhi) <- strsplit(files.suhi, "suhi_|_v") %>% do.call(rbind,.) %>% as_tibble() %>% dplyr::select(V2) %>% unlist()
dt.suhi <- rbindlist(dt.suhi, idcol = "id" )

# read all lst files
files.lst <- list.files("www/data/tabs/suhi/", "^stats", full.names = T)
dt.lst <- lapply(files.lst, fread) 
names(dt.lst) <- strsplit(files.lst, "stats_|_v") %>% do.call(rbind,.) %>% as_tibble() %>% dplyr::select(V2) %>% unlist()
dt.lst <- rbindlist(dt.lst, idcol = "id" )
