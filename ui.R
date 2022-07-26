
source("sections/ui_graphs.R", local = T)
source("sections/ui_about.R", local = T)
# Define UI for application that draws a histogram

ui <- shinyUI(
  
  ui <- function(req) { 
    fluidPage(theme = shinytheme("spacelab"),
              
              tags$head(
                
                tags$style(
                  type = "text/css",

                  # "header {
                  #   border: 1px solid blue;
                  #   height: 150px;
                  #   display: flex;                   /* defines flexbox */
                  #     flex-direction: column;          /* top to bottom */
                  #     justify-content: space-between;  /* first item at start, last at end */
                  # }",
                  # "section {
                  #   border: 1px solid blue;
                  #   height: 150px;
                  #   display: flex;                   /* defines flexbox */
                  #     align-items: flex-end;           /* bottom of the box */
                  # }",
                  "body {padding-top: 70px;}",
                  #
                )
                
              ),
              useShinyjs(),
              
              navbarPage(
                "SUHI explorer",    collapsible = T, fluid = T, id = "tabs", position =  "fixed-top",
                
                ui_graphs,
                ui_about,
              )
    )
  }
)
