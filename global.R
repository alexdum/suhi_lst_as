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
library(raster)
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
choices <- setNames(select_input_cities$choice, paste0(select_input_cities$label, " (", select_input_cities$country,")"))

cities_map <- st_read("www/data/shp/cities_one_file.shp") %>% 
  mutate(city =  strsplit(name, "-") %>% do.call(rbind, .) %>% as_tibble() %>% dplyr::select(V2) %>% unlist()) %>%
  filter(city %in% select_input_cities$choice)
# pentru dropdown parameters maps
choices_map <- read.csv("www/data/tabs/slelect_input_parameters.csv") 
choices_map <-   setNames(choices_map$choice, choices_map$parameter)
       

# read all uhi files
files.suhi <- paste0(select_input_cities$V1,"suhi_",select_input_cities$choice, "_v02.csv")
dt.suhi <- lapply(files.suhi, fread) 
names(dt.suhi) <- strsplit(files.suhi, "suhi_|_v") %>% do.call(rbind,.) %>% as_tibble() %>% dplyr::select(V2) %>% unlist()
dt.suhi <- rbindlist(dt.suhi, idcol = "id" )

# read all lst files
files.lst <- gsub("/suhi_","/stats_",files.suhi)
dt.lst <- lapply(files.lst, fread) 
names(dt.lst) <- strsplit(files.lst, "stats_|_v") %>% do.call(rbind,.) %>% as_tibble() %>% dplyr::select(V2) %>% unlist()
dt.lst <- rbindlist(dt.lst, idcol = "id" )

# read daily lst
lst.max <- raster::stack("www/data/ncs/wmo_6_msg_lst_as_daily_max.nc")
dats.lst.max  <- as.Date(names(lst.max) %>% gsub("X", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 
dats.lst.max <- dats.lst.max[dats.lst.max <=  max(dt.lst$date)]

lst.avg <- raster::stack("www/data/ncs/wmo_6_msg_lst_as_daily_avg.nc")
dats.lst.avg  <- as.Date(names(lst.avg) %>% gsub("X", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 
dats.lst.avg <- dats.lst.max[dats.lst.avg <=  max(dt.lst$date)]
                 
