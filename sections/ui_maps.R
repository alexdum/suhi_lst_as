library(shiny)
library(shinythemes)
library(highcharter)
library(tidyr)
library(dplyr)

ui_maps <- tabPanel(
  "Maps",value = "#maps", id = "#maps",icon = icon("map"),
  #tags$br(""),
  tabsetPanel( 
    id = "tab_maps",
    tabPanel(
      value = "suhi_maps",
      title = "SUHI Map",
      tags$h6(" "),
      tags$h5("Cities for which SUHI has been calculated from LST AS SEVIRI product"),
      #tags$h6(" "),
      tags$br(""),
      sidebarLayout(
        fluid = T,
        sidebarPanel(
          width = 3,
          selectInput(
            "parameter", "Prameter:", 
            choices_map, 
            selected = choices_map[2]
          ),
          dateInput(
            'days_suhi',
            label = 'Select day',
            min = min(dt.lst$date) |> as.Date(),
            max = max(dt.lst$date) |> as.Date(),
            value = max(dt.lst$date) |> as.Date()
          )
        )
        ,
        mainPanel(
          width = 9,
          fluidRow(
            leafletOutput("map")
          )
        )
      )
    )
  )
)





