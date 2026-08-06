library(shiny)
library(highcharter)
library(tidyr)
library(dplyr)

ui_graphs <- tabPanel(
  "Graphs", value = "#graphs", icon = icon("chart-line"),
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
      col_widths = c(6, 6),
      gap = "1rem",
      card(
        full_screen = TRUE,
        class = "equal-height-card glass-card",
        card_header(div(class = "card-header-title", icon("temperature-high"), textOutput("text_uhi", inline = TRUE))),
        card_body(
          highchartOutput("suhi", height = "100%") %>% withSpinner(size = 0.5)
        )
      ),
      card(
        full_screen = TRUE,
        class = "equal-height-card glass-card",
        card_header(div(class = "card-header-title", icon("thermometer-half"), textOutput("text_lst", inline = TRUE))),
        card_body(
          highchartOutput("lst", height = "100%") %>% withSpinner(size = 0.5)
        )
      )
    )
  )
)
