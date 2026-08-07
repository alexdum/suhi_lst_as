ui_about <- tabPanel(
  "About", icon = icon("info-circle"), value = "#about",
  card(
    class = "glass-card mb-4",
    card_header(
      div(
        class = "d-flex justify-content-between align-items-center w-100", 
        span(class = "card-header-title", icon("info-circle", class = "me-2"), "About Urban Climate Explorer"),
        span(
          class = "info-tooltip-icon text-info", 
          `data-bs-toggle` = "tooltip", 
          `data-bs-placement` = "left", 
          title = "Learn more about the Urban Climate Explorer dashboard and its methodology.", 
          icon("info-circle")
        )
      )
    ),
    card_body(
      includeMarkdown("sections/about.md")
    )
  ),
  card(
    class = "glass-card mb-4",
    card_header(
      div(class = "card-header-title", icon("map-marked-alt"), " Monitored Cities Location Map & Rural Buffers")
    ),
    card_body(
      leafletOutput("map.about", height = 520) %>% withSpinner(size = 0.5)
    )
  )
)
