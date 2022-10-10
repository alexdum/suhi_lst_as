server <- shinyServer(function(input, output, session) {
  
  source(file = "utils/tabs_url.R", local = T)
  # add sections
  source(file = "sections/server_about.R", local = T)
  source(file = "sections/server_graphs.R", local = T)
  source(file = "sections/server_map_urban.R", local = T)
  source(file = "sections/server_map_europe.R", local = T)
  
  # run code before accesing section
  outputOptions(output, "map.europe", suspendWhenHidden = FALSE)
  outputOptions(output, "lst", suspendWhenHidden = FALSE)
  outputOptions(output, "suhi", suspendWhenHidden = FALSE)
  outputOptions(output, "map", suspendWhenHidden = FALSE)

  
})


