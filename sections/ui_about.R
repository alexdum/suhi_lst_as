ui_about <- tabPanel(
  "About",icon = icon("info"), value = "#about", id = "#about",
  card(
    card_header("About"),
    card_body(
      includeMarkdown("sections/about.md"),
      leafletOutput("map.about", height = 500) %>% withSpinner(size = 0.5)
    )
  )
)
