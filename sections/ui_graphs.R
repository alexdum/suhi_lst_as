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
        class = "d-flex justify-content-between align-items-center flex-wrap gap-2 w-100",
        span(class = "card-header-title", icon("city", class = "me-2"), "Cities Analytics & Time Series"),
        div(
          class = "d-flex align-items-center gap-2",
          span(class = "stat-badge", icon("clock"), paste("Updated", format(max(dt.lst$date), "%Y-%m-%d"))),
          span(
            class = "info-tooltip-icon text-info", 
            `data-bs-toggle` = "tooltip", 
            `data-bs-placement` = "left", 
            title = "Surface Urban Heat Island (SUHI) and Land Surface Temperature (LST) time series from the LST AS SEVIRI satellite product.", 
            icon("info-circle")
          )
        )
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
        "city",
        label = span(
          "City:",
          span(
            class = "text-muted ms-1 info-tooltip-icon",
            `data-bs-toggle` = "tooltip",
            `data-bs-placement` = "top",
            title = "Select a European city to view its Surface Urban Heat Island (SUHI) and Land Surface Temperature (LST) historical time series.",
            icon("info-circle")
          )
        ),
        choices,
        selected = choices[sample(1:length(choices), 1)],
        options = list(dropdownParent = "body")
      ),
      div(
        `data-bs-toggle` = "tooltip",
        `data-bs-placement` = "top",
        title = "Download the complete daily time series data for the selected city as a CSV file.",
        downloadButton('downloadData', 'Download Data', class = "btn-primary w-100 mt-2")
      )
    ),
    layout_columns(
      col_widths = c(6, 6),
      gap = "1rem",
      card(
        full_screen = TRUE,
        class = "equal-height-card glass-card",
        card_header(
          div(
            class = "d-flex justify-content-between align-items-center w-100",
            div(class = "card-header-title", icon("temperature-high"), textOutput("text_uhi", inline = TRUE)),
            span(
              class = "text-muted ms-1 info-tooltip-icon",
              `data-bs-toggle` = "tooltip",
              `data-bs-placement` = "top",
              title = "SUHI represents the Surface Urban Heat Island intensity (°C anomaly relative to rural reference).",
              icon("info-circle")
            )
          )
        ),
        card_body(
          highchartOutput("suhi", height = "100%") %>% withSpinner(size = 0.5)
        )
      ),
      card(
        full_screen = TRUE,
        class = "equal-height-card glass-card",
        card_header(
          div(
            class = "d-flex justify-content-between align-items-center w-100",
            div(class = "card-header-title", icon("thermometer-half"), textOutput("text_lst", inline = TRUE)),
            span(
              class = "text-muted ms-1 info-tooltip-icon",
              `data-bs-toggle` = "tooltip",
              `data-bs-placement` = "top",
              title = "LST represents the Land Surface Temperature (surface skin temperature in °C).",
              icon("info-circle")
            )
          )
        ),
        card_body(
          highchartOutput("lst", height = "100%") %>% withSpinner(size = 0.5)
        )
      )
    )
  )
)
