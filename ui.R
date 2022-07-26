library(shiny)
library(shinythemes)
library(highcharter)
library(tidyr)
library(dplyr)

# Define UI for application that draws a histogram
fluidPage(
  sidebarLayout(
    fluid = T,
    
    sidebarPanel(
      width = 3,
      
      selectInput("city", "City:",
                  c("Bucuresti" = "bucuresti",
                    "Berlin" = "berlin",
                    "Roma" = "roma"))
      
      
    ),
    mainPanel( 
      width = 9,
      fluidRow(
        highchartOutput("chart2")
      )
    )
  )
)
