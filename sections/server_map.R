
filteredData <- eventReactive(
  list(isolate(input$tab_maps), input$days_suhi), {
    dt.suhi.filt <- dt.suhi[date == input$days_suhi]
    dt.lst.filt <- dt.lst[date == input$days_suhi]
    merge(dt.suhi.filt,  dt.lst.filt, by.x.y = "id")
    
  }
)


# harta leaflet -----------------------------------------------------------
output$map <- renderLeaflet ({
  leaflet(data = cities_map,
          options = leafletOptions(
            minZoom = 3, maxZoom = 12
          ) 
  ) %>%
    leaflet.extras::addBootstrapDependency() %>%
    setView(25, 46, zoom = 3) %>%
    setMaxBounds(-13.5, 30, 57, 65) %>% 
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
  
})


observe({
  
  print(head(filteredData()))
  param <- input$parameter
  print(param)
  param_data <- filteredData() %>% select(id, param)
  names(param_data)[2] <- "values"
  
  print(head(param_data))
  print(param)
  print(min(param_data[,2], na.rm = T))
  cities.filt <- cities_map |> right_join(param_data, by = c("city" = "id"))
  

  vals <- seq(floor(min(param_data[,2], na.rm = T)),ceiling(max(param_data[, 2], na.rm = T)), 0.1)
  pal_rev <- colorNumeric(
    "RdYlBu",
    vals,
    reverse = F)
  pal <- colorNumeric(
    "RdYlBu",
    vals,
    reverse = T)
  
  proxy <- leafletProxy("map", data = cities.filt) %>%
    clearShapes() %>%
    addPolygons(
      label = ~htmlEscape(paste("id", param)),
      group = "City borders",
      fillColor = ~pal(values),
      color = ~pal(values),
      fillOpacity = 1,
      opacity = 1
      
    ) %>% 
    clearControls() %>%
    addLegend(
      position = "bottomright",
      pal = pal_rev, values = vals,
      opacity = 1,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
    )
  
})
