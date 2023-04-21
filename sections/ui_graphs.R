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
      tags$h5(paste0("Surface Urban Heat Island (SUHI) and Land Surface Temperature 
                     (LST) as detected from LST AS SEVIRI product (last processed date ",  max(dt.lst$date),").")),
      #tags$h6(" "),
      tags$br(""),
      fluidRow(
        column(
          width = width_panels[1],
          wellPanel(
            selectInput("city", "City:", choices, selected = choices[sample(1:length(choices), 1)]),
            downloadButton('downloadData', 'Download')
          )
        ),
        column( 
          width = width_panels[2],
          fluidRow(
            wellPanel(
              textOutput("text_uhi"),
              highchartOutput("suhi") %>% withSpinner(size = 0.5)
            ),
            wellPanel(
              textOutput("text_lst"),
              highchartOutput("lst") %>% withSpinner(size = 0.5)
            )
          )
        )
      )
    )
  )
)


