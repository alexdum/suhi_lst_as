library(shiny)
library(shinythemes)
library(highcharter)
library(tidyr)
library(dplyr)

ui_graphs <- tabPanel(
  "Graphs and maps",value = "#maps", id = "#maps",
  #tags$br(""),
  tabsetPanel( 
    id = "tab_suhi",
    tabPanel(
      value = "suhi",
      title = "SUHI",
      tags$h6(" "),
      HTML("Surface urban heat island (SUHI) detected form LST AS SEVIRI product"),
      
      tags$br(""),
      sidebarLayout(
        fluid = T,
        sidebarPanel(
          width = 3,
          selectInput("city", "City:", choices)
        ),
        mainPanel( 
          width = 9,
          fluidRow(
            highchartOutput("chart2")
          )
        )
      )
    )
  )
)


