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
library(terra)
library(reticulate)
library(shinycssloaders)


#https://shiny.rstudio.com/gallery/superzip-example.htmlhttps://shiny.rstudio.com/gallery/superzip-example.html

source("utils/graphs_funs.R")
source("utils/show_pop.R")
source("utils/leaflet_fun.R")
source_python("utils/extract_point.py") 

width_panels <- c(2,7)

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

cities_map.buff <- st_read("www/data/shp/cities_buff_one_file.shp") %>% 
                  dplyr::filter(name %in% cities_map$name )

# pentru dropdown parameters maps
choices_map <- read.csv("www/data/tabs/slelect_input_parameters.csv") 
choices_map <-   setNames(choices_map$choice, choices_map$parameter)

# pentru dropdown parameters maps europ
choices_map_europe_daily <- read.csv("www/data/tabs/slelect_input_parameters_europe_daily.csv") 
choices_map_europe_daily <- setNames(choices_map_europe_daily$choice, choices_map_europe_daily$parameter)
choices_map_europe_monthly <- read.csv("www/data/tabs/slelect_input_parameters_europe_monthly.csv") 
choices_map_europe_monthly <- setNames(choices_map_europe_monthly$choice, choices_map_europe_monthly$parameter)
       

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

# read ncs
lst.max <- terra::rast("www/data/ncs/wmo_6_msg_lst_as_daily_max.nc")
dats.lst.max  <- as.Date(names(lst.max) %>% gsub("MLST-AS_days=", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 
dats.lst.max <- dats.lst.max[dats.lst.max <=  max(dt.lst$date)]

lst.avg <- terra::rast("www/data/ncs/wmo_6_msg_lst_as_daily_avg.nc")
dats.lst.avg  <- as.Date(names(lst.avg) %>% gsub("MLST-AS_days=", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 
dats.lst.avg <- dats.lst.max[dats.lst.avg <=  max(dt.lst$date)]

lst.min <- terra::rast("www/data/ncs/wmo_6_msg_lst_as_daily_min.nc")
dats.lst.min  <- as.Date(names(lst.min) %>% gsub("MLST-AS_days=", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 
dats.lst.min <- dats.lst.max[dats.lst.min <=  max(dt.lst$date)]

lst.mm <- terra::rast("www/data/ncs/wmo_6_msg_lst_as_daily_dineof_tmm.nc")
dats.lst.mm <- as.Date(names(lst.mm) %>% gsub("MLST-AS_days=", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 

lst.mn <- terra::rast("www/data/ncs/wmo_6_msg_lst_as_daily_dineof_tmn.nc")
dats.lst.mn <- as.Date(names(lst.mn) %>% gsub("MLST-AS_days=", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 

lst.mx <- terra::rast("www/data/ncs/wmo_6_msg_lst_as_daily_dineof_tmx.nc")
dats.lst.mx <- as.Date(names(lst.mx) %>% gsub("MLST-AS_days=", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 


# for mac
if (Sys.info()[1] == "Darwin") {
  # read daily lst
  lst.maxx <- raster::stack("www/data/ncs/wmo_6_msg_lst_as_daily_max.nc") 
  dats.lst.max  <- as.Date(names(lst.maxx) %>% gsub("X", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 
  dats.lst.max <- dats.lst.max[dats.lst.max <=  max(dt.lst$date)]
  lst.max <- rast(lst.maxx)
  
  lst.avgg <- raster::stack("www/data/ncs/wmo_6_msg_lst_as_daily_avg.nc")
  dats.lst.avg  <- as.Date(names(lst.avgg) %>% gsub("X", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 
  dats.lst.avg <- dats.lst.max[dats.lst.avg <=  max(dt.lst$date)]
  lst.avg <- rast(lst.avgg)
  
  lst.minn <- raster::stack("www/data/ncs/wmo_6_msg_lst_as_daily_min.nc")
  dats.lst.min  <- as.Date(names(lst.minn) %>% gsub("X", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 
  dats.lst.min <- dats.lst.max[dats.lst.min <=  max(dt.lst$date)]
  lst.min <- rast(lst.minn)
  
  lst.mavg <- raster::stack("www/data/ncs/wmo_6_msg_lst_as_daily_dineof_tmm.nc")
  dats.lst.mm <- as.Date(names(lst.mavg) %>% gsub("X", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 
  lst.mm <- rast(lst.mavg)
  lst.mmin <- raster::stack("www/data/ncs/wmo_6_msg_lst_as_daily_dineof_tmn.nc")
  dats.lst.mn <- as.Date(names(lst.mmin) %>% gsub("X", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 
  lst.mn <- rast(lst.mmin)
  lst.mmax <- raster::stack("www/data/ncs/wmo_6_msg_lst_as_daily_dineof_tmx.nc")
  dats.lst.mx <- as.Date(names(lst.mmax) %>% gsub("X", "",.) %>% as.integer(), origin = "1970-1-1 00:00:00") 
  lst.mx <- rast(lst.mmax)
  
}


