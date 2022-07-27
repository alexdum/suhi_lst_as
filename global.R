library(shiny)
library(shinythemes)
library(highcharter)
library(tidyr)
library(dplyr)
library(shinyjs)

# listă orașe din tabel selectInput
select_input_cities <- read.csv("www/data/tabs/select_input_cities.csv") %>%
                     arrange(label) %>% filter(!label %in% c("Reykjavik", "Nur Sultan"))
choices <- setNames(select_input_cities$choice,paste0(select_input_cities$label, " (", select_input_cities$country,")"))


