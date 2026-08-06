library(shiny)
library(highcharter)
library(tidyr)
library(dplyr)

ui_graphs <- tabPanel(
  "Graphs", value = "#graphs", icon = icon("chart-line"),
  tabsetPanel( 
    id = "tab_suhi",
    tabPanel(
      value = "suhi",
      title = "SUHI & LST",
      card(
        class = "mb-3 glass-card",
        card_header(
          div(
            class = "d-flex justify-content-between align-items-center flex-wrap gap-2",
            span(class = "card-header-title", icon("city"), " Cities Analytics & Time Series"),
            span(class = "stat-badge", icon("clock"), paste("Updated", format(max(dt.lst$date), "%Y-%m-%d")))
          )
        ),
        card_body(
          p(class = "card-text-lead", "Surface Urban Heat Island (SUHI) and Land Surface Temperature (LST) time series from the LST AS SEVIRI satellite product.")
        )
      ),
      layout_sidebar(
        fill = TRUE,
        gap = "1rem",
        sidebar = sidebar(
          title = "City & data",
          open = list(desktop = "open", mobile = "closed"),
          selectizeInput(
            "city", "City:", choices,
            selected = choices[sample(1:length(choices), 1)],
            options = list(dropdownParent = "body")
          ),
          downloadButton('downloadData', 'Download Data', class = "btn-primary w-100 mt-2")
        ),
        layout_columns(
          gap = "1rem",
          card(
            class = "glass-card",
            card_header(div(class = "card-header-title", icon("temperature-high"), " Surface Urban Heat Island")),
            card_body(
              textOutput("text_uhi"),
              highchartOutput("suhi") %>% withSpinner(size = 0.5)
            )
          ),
          card(
            class = "glass-card",
            card_header(div(class = "card-header-title", icon("thermometer-half"), " Land Surface Temperature")),
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
