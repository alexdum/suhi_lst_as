ui_about <- tabPanel(
  "About", icon = icon("info-circle"), value = "#about",
  card(
    class = "glass-card mb-4",
    card_header(
      div(class = "card-header-title", icon("info-circle"), " About Urban Climate Explorer")
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
