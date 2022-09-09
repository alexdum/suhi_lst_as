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
      title = "SUHI & LST",
      tags$h6(" "),
      tags$h5("Cities for which Surface Urban Heat Island (SUHI) and Land Surface Temperature (LST) has been calculated from LST AS SEVIRI product"),
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
            label = 'Day:',
            min = min(dt.lst$date) |> as.Date(),
            max = max(dt.lst$date) |> as.Date(),
            value = max(dt.lst$date) |> as.Date()
          ),
          downloadButton('downloadDataMap', 'Download'),
        )
        ,
        mainPanel(
          width = 9,
          wellPanel(
            textOutput("text_map")
          ),
          wellPanel(
            leafletOutput("map")
          )
        )
      )
    )
  )
)





