library(shiny)
library(shinythemes)
library(highcharter)
library(tidyr)
library(dplyr)

ui_graphs <- tabPanel(
  "Graphs",value = "#graphs", id = "#graphs",icon = icon("chart-line"),
  #tags$br(""),
  tabsetPanel( 
    id = "tab_suhi",
    tabPanel(
      value = "suhi",
      title = "SUHI & LST",
      tags$h6(" "),
      tags$h5("Surface Urban Heat Island (SUHI) and Land Surface Temperature (LST) as detected from LST AS SEVIRI product"),
      #tags$h6(" "),
      tags$br(""),
      sidebarLayout(
        fluid = T,
        sidebarPanel(
          width = 2,
          selectInput("city", "City:", choices, selected = choices[sample(1:length(choices), 1)]),
          downloadButton('downloadData', 'Download')
        ),
        mainPanel( 
          width = 8,
          fluidRow(
            wellPanel(
            textOutput("text_uhi"),
            highchartOutput("suhi")
            ),
            wellPanel(
            textOutput("text_lst"),
            highchartOutput("lst")
            )
          )
        )
      )
    )
  )
)


