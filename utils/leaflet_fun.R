# functie harta
leaflet_fun <- function(data, raster, domain, cols, cols_rev, title) {
  
  
  map <- leaflet(
    data = data,
    options = leafletOptions(minZoom = 3, maxZoom = 12)) %>%
    setView(25, 46, zoom = 3) %>%
    setMaxBounds(-12, 27.58, 56, 71.5) %>%
    #addMapPane(name = "raster", zIndex = 410) %>%
    addMapPane(name = "citie", zIndex = 415) %>%
    addMapPane(name = "maplabels", zIndex = 420) %>%
    addLayersControl(
      baseGroups = "CartoDB.PositronNoLabels",
      overlayGroups = c("Labels", "City borders")) %>%
    addProviderTiles("CartoDB.PositronNoLabels") %>%
    addRasterImage(
      raster, colors = cols, opacity = .8
      # options = leafletOptions(pane = "raster")
    )  %>%
    addPolygons(
      color = "#444444", weight = 1, smoothFactor = 0.5,
      opacity = 0.7, fillOpacity = 0.1,
      highlightOptions = highlightOptions(color = "white", weight = 2,
                                          bringToFront = TRUE),
      options = pathOptions(pane = "citie"),
      group = "City borders"
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
    ) %>%
    leafem::addMouseCoordinates() %>%
    clearControls() %>%
    addLegend(
      title = title,
      position = "bottomright",
      pal = cols_rev, values = domain,
      opacity = 1,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
    )
  return(map)
}