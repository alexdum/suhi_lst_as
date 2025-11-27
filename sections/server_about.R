
# Build once per session to avoid re-running the pipeline on every render
base_map <- leaflet( 
  data = cities_map,
  options = leafletOptions(minZoom = 3, maxZoom = 12)) %>%
  setView(25, 46, zoom = 3) %>%
  setMaxBounds(-12, 27.58, 56, 71.5) %>%
  addMapPane(name = "citieb", zIndex = 415) %>%
  addMapPane(name = "citie", zIndex = 417) %>% 
  addMapPane(name = "maplabels", zIndex = 420) %>% 
  addLayersControl(
    baseGroups = "CartoDB.PositronNoLabels",
    overlayGroups = c("Labels", "City borders", "City borders buffer")) %>%
  addProviderTiles("CartoDB.PositronNoLabels") %>%
  addPolygons(
    color = "#444444", weight = 1, smoothFactor = 0.5,
    opacity = 0.9, fillOpacity = 0.1,
    highlightOptions = highlightOptions(color = "white", weight = 2,
                                        bringToFront = TRUE),
    label = ~paste(toupper(city)),
    options = pathOptions(pane = "citie"),
    group = "City borders"
  ) %>%
  addPolygons(
    data = cities_map.buff,
    color = "red", weight = 1, smoothFactor = 0.5,
    opacity = 0.9, fillOpacity = 0,
    options = pathOptions(pane = "citieb"),
    group = "City borders buffer"
  ) %>%
  addProviderTiles(
    "CartoDB.PositronOnlyLabels",
    options = pathOptions(pane = "maplabels"),
    group = "Labels"
  ) %>%
  addEasyButton(
    easyButton(
      icon    = "glyphicon glyphicon-home", title = "Reset zoom",
      onClick = JS("function(btn, map){ map.setView([46, 25], 3); }")
    )
  ) %>%
  addScaleBar(
    position = c("bottomleft"),
    options = scaleBarOptions(metric = TRUE)
  )

output$map.about <- renderLeaflet({
  base_map
})
