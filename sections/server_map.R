# harta leaflet -----------------------------------------------------------
output$map <- renderLeaflet ({
  leaflet(cities_map,
          options = leafletOptions(
            minZoom = 3, maxZoom = 12
          ) 
  ) %>%
    addPolygons(
      label = ~htmlEscape(name),
      group = "City borders") %>%
    leaflet.extras::addBootstrapDependency() %>%
    setView(25, 46, zoom = 3) %>%
    setMaxBounds(-13.5, 30, 57, 75) %>% 
    addMapPane(name = "pol", zIndex = 410) %>%
    addMapPane(name = "maplabels", zIndex = 420) %>%
    addProviderTiles(
      "CartoDB.PositronNoLabels"
    )   %>% 
    addEasyButton(
      easyButton (
        icon    = "glyphicon glyphicon-home", title = "Reset zoom",
        onClick = JS("function(btn, map){ map.setView([46, 25], 3); }")
      )
    )   %>%
    addLayersControl(
      baseGroups = "CartoDB.PositronNoLabels",
      overlayGroups = c("Labels", "City borders"))  %>% 
    addProviderTiles(
      "CartoDB.PositronOnlyLabels",
      options = pathOptions(pane = "maplabels"),
      group = "Labels"
    ) 
  # leaflet.extras2::addEasyprint(
  #   options =
  #     leaflet.extras2::easyprintOptions(
  #       title = 'Print map',
  #       position = 'topleft',
  #       exportOnly = T,
  #       sizeModes = c('A4Landscape', 'A4 Landscape')
  #     )
  # )
  #%>%
  #leaflet.extras::addResetMapButton() %>%
  # leaflet.extras::addSearchFeatures(
  #   targetGroups  = 'region',
  #   options = leaflet.extras::searchFeaturesOptions(
  #     zoom=10, 
  #     openPopup=FALSE,
  #     propertyName = "name",
  #     hideMarkerOnCollapse = TRUE,
  #     firstTipSubmit = TRUE
  #     # textErr = "Locația nu a fost găsită", 
  #     # textCancel = "Anulare",
  #     # textPlaceholder = "Căutare..."
  #   )
  # )
  
})