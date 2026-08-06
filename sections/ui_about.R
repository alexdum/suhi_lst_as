ui_about <- tabPanel(
  "About", icon = icon("info-circle"), value = "#about",
  card(
    class = "glass-card mb-4",
    card_header(
      div(class = "card-header-title", icon("info-circle"), " About Urban Climate Explorer")
    ),
    card_body(
      includeMarkdown("sections/about.md"),
      hr(class = "my-4 opacity-25"),
      h5(class = "fw-bold mb-3", icon("map-marked-alt"), " Monitored Cities Location Map"),
      leafletOutput("map.about", height = 500) %>% withSpinner(size = 0.5)
    )
  )
)
