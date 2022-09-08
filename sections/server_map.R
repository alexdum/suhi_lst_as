
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
  
  vals <- seq(floor(min(filteredData()$uhi.min)),ceiling(max(filteredData()$uhi.min)), 0.1)
  pal_rev <- colorNumeric(
    "RdYlBu",
    vals,
    reverse = F)
  pal <- colorNumeric(
    "RdYlBu",
    vals,
    reverse = T)
  print(summary(filteredData()$uhi.min))
  cities.filt <- cities_map |> right_join(filteredData(), by = c("city" = "id"))
  
  proxy <- leafletProxy("map", data = cities.filt) %>%
    clearShapes() %>%
    addPolygons(
      label = ~htmlEscape(uhi.min),
      group = "City borders",
      fillColor = ~pal(uhi.min),
      color = ~pal(uhi.min),
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
