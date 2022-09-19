
filteredData <- eventReactive(
  list(input$days_suhi), {
    dt.suhi.filt <- dt.suhi[date == input$days_suhi]
    dt.lst.filt <- dt.lst[date == input$days_suhi]
    merge(dt.suhi.filt,  dt.lst.filt, by.x.y = "id")
    
  }
)


# harta leaflet -----------------------------------------------------------
output$map <- renderLeaflet ({
  leaflet(
    data = cities_map,
    options = leafletOptions(
      minZoom = 3, maxZoom = 12
    ) 
  ) %>%
    leaflet.extras::addBootstrapDependency() %>%
    setView(25, 46, zoom = 3) %>%
    setMaxBounds(-13.5, 30, 57, 65) %>% 
    addMapPane(name = "pol", zIndex = 410) %>%
    addMapPane(name = "maplabels", zIndex = 420) %>%
    addProviderTiles( "CartoDB.PositronNoLabels")   %>% 
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
    ) %>%
    addScaleBar(
      position = c("bottomleft"),
      options = scaleBarOptions(metric = TRUE)
    )
  
})



params <- reactive({
  
  param <- input$parameter
  param.label <- names(choices_map[choices_map==param])
  print(param.label)
  param_data <- filteredData() %>% dplyr::select(id, all_of(param)) %>%
    left_join(select_input_cities[,c("label", "choice")], by = c("id" = "choice"))
  names(param_data)[2] <- "values"
  # label pentru hover
  param_data$label <- paste0(param_data$label,": ",param_data$values)
  list(param = param, param.label = param.label, param_data = param_data)
})

output$text_down_urb <- renderText({
paste("Download", params()$param.label,"data for all cities")
}) 

output$text_map <- renderText({
paste(params()$param.label, "computed for major cities:", input$days_suhi)
}) 
observe({
  
  req(input$tabs == "#maps")
  # req(input$tab_maps == "suhi_maps")
  
  cities.filt <- cities_map |> right_join(params()$param_data, by = c("city" = "id"))
  #print( cities.filt$city)
  
  vals <- range(floor(min(cities.filt$values, na.rm = T)),ceiling(max(cities.filt$values, na.rm = T)))
  pal_rev <- colorNumeric("RdYlBu", vals, reverse = F)
  pal <- colorNumeric( "RdYlBu", vals, reverse = T)
  
  leafletProxy("map", data = cities.filt) %>%
    clearShapes() %>%
    addPolygons(
      label = ~htmlEscape(label),
      group = "City borders",
      fillColor = ~pal(values),
      color = ~pal(values),
      fillOpacity = 1,
      opacity = 1,
      layerId = ~city,
      weight = 8
      
    ) %>% 
    clearControls() %>%
    addLegend(
      title =  paste(gsub("mean", "", params()$param.label),"[°C]"),
      position = "bottomright",
      pal = pal_rev, values = vals,
      opacity = 1,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
    )
})

output$downloadDataMap <- downloadHandler(
  filename = function() {
    paste0('data_map-', gsub(" " , "_",params()$param.label),"_",input$days_suhi, '.csv')
  },
  content = function(con) {
    write.csv(params()$param_data %>% dplyr::select("id", "values"), con)
  }
)
