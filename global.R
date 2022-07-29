library(shiny)
library(shinythemes)
library(highcharter)
library(tidyr)
library(dplyr)
library(shinyjs)

source("utils/graphs_funs.R")

cities <- list.files("www/data/tabs/suhi", pattern = "^suhi", full.names = T) %>%
          strsplit(., "suhi_|_v02.csv") %>% do.call(rbind, .) %>% as_tibble() 


# listă orașe din tabel selectInput care au date cities
select_input_cities <- read.csv("www/data/tabs/select_input_cities.csv") %>%
  arrange(label) %>% filter(!label %in% c("Reykjavik", "Nur Sultan", "Ammann", "Monaco")) %>% 
  right_join(cities, by = c("choice" = "V2"))

choices <- setNames(select_input_cities$choice,paste0(select_input_cities$label, " (", select_input_cities$country,")"))


