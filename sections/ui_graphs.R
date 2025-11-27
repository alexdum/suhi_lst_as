library(shiny)
library(shinythemes)
library(highcharter)
library(tidyr)
library(dplyr)

ui_graphs <- tabPanel(
  "Graphs",value = "#graphs", id = "#graphs",icon = icon("chart-line"),
  tabsetPanel( 
    id = "tab_suhi",
    tabPanel(
      value = "suhi",
      title = "SUHI & LST",
      card(
        class = "mb-3",
        card_header("Cities coverage"),
        card_body(
          p("SUHI and LST time series from the LST AS SEVIRI product."),
          span(class = "badge bg-secondary", paste("Updated", format(max(dt.lst$date), "%Y-%m-%d")))
        )
      ),
      layout_sidebar(
        fill = TRUE,
        gap = "1rem",
        sidebar = card(
          class = "sidebar-card",
          card_header("City & data"),
          card_body(
            selectizeInput(
              "city", "City:", choices,
              selected = choices[sample(1:length(choices), 1)],
              options = list(dropdownParent = "body")
            ),
            downloadButton('downloadData', 'Download', class = "mt-2")
          )
        ),
        layout_columns(
          gap = "1rem",
          card(
            card_header("Surface Urban Heat Island"),
            card_body(
              textOutput("text_uhi"),
              highchartOutput("suhi") %>% withSpinner(size = 0.5)
            )
          ),
          card(
            card_header("Land Surface Temperature"),
            card_body(
              textOutput("text_lst"),
              highchartOutput("lst") %>% withSpinner(size = 0.5)
            )
          )
        )
      )
    )
  )
)
