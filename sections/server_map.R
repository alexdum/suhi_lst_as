
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
    setView(25, 46, zoom = 4) %>%
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



params <- reactive({
 
  param <- input$parameter
  param.label <- names(choices_map[choices_map==param])
  print(param.label)
  list(param = param, param.label = param.label)
})

output$text_map <- renderText({
  paste(params()$param.label, "computed for major cities")
})

observe({
  

  param_data <- filteredData() %>% select(id, params()$param) %>%
    left_join(select_input_cities[,c("label", "choice")], by = c("id" = "choice"))
  names(param_data)[2] <- "values"
  # label pentru hover
  param_data$label <- paste0(param_data$label,": ",param_data$values)
  

  cities.filt <- cities_map |> right_join(param_data, by = c("city" = "id"))
  #print( cities.filt$city)

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
      label = ~htmlEscape(label),
      group = "City borders",
      fillColor = ~pal(values),
      color = ~pal(values),
      fillOpacity = 1,
      opacity = 1,
      layerId = ~city
      
    ) %>% 
    clearControls() %>%
    addLegend(
      title =  gsub("mean", "", params()$param.label),
      position = "bottomright",
      pal = pal_rev, values = vals,
      opacity = 1,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
    )
  
})
