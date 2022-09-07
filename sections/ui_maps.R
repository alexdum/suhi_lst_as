library(shiny)
library(shinythemes)
library(highcharter)
library(tidyr)
library(dplyr)

ui_maps <- tabPanel(
  "Maps",value = "#maps", id = "#maps",icon = icon("map"),
  #tags$br(""),
  tabsetPanel( 
    id = "tab maps",
    tabPanel(
      value = "suhi_maps",
      title = "SUHI",
      tags$h6(" "),
      tags$h5("Cities for which SUHI has been calculated from LST AS SEVIRI product"),
      #tags$h6(" "),
      tags$br(""),
      # sidebarLayout(
      #   fluid = T,
      #   sidebarPanel(
      #     width = 3
      #     
      #   ),
      #   mainPanel( 
      #     width = 9,
          fluidRow(
            leafletOutput("map")
          )
    #     )
    #   )
    )
  )
)


