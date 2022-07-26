library(shiny)
library(shinythemes)
library(highcharter)
library(tidyr)
library(dplyr)
library(shinyjs)

# listă orașe din tabel selectInput
select_input_cities <- read.csv("www/data/tabs/select_input_cities.csv")
choices <- setNames(select_input_cities$choice,select_input_cities$label)
