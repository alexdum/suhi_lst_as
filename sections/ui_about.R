ui_about <- tabPanel(
  "About",icon = icon("info"), value = "#about", id = "#about",
  
  
  fluidRow( 
    h4("About"),
    includeMarkdown("sections/about.md"),
    leafletOutput("map.about", height = 500) %>% withSpinner(size = 0.5)
  )
  
  
  
  
)
