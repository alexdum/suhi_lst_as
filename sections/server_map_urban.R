
filteredData <- eventReactive(
  list(input$days_suhi), {
    dt.suhi.filt <- dt.suhi[date == input$days_suhi]
    dt.lst.filt <- dt.lst[date == input$days_suhi]
    merge(dt.suhi.filt,  dt.lst.filt, by = "id")
    
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
    setMaxBounds(-12, 27.58, 56, 71.5) %>% 
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
  # print(param.label)
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
  paste(params()$param.label, "computed for major cities:", input$days_suhi,"(to view the time series graph, click on the city)")
}) 
observe({
  
  req(input$tabs == "#maps")
  # req(input$tab_maps == "suhi_maps")
  
  cities.filt <- cities_map |> right_join(params()$param_data, by = c("city" = "id"))
  
  
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


# reactive values plot ----------------------------------------------------
plot_vars <- reactiveValues(
  city = NULL
)
observe({ 
  plot_vars$city <- input$map_shape_click$id
})

output$plot_city <- renderHighchart({
  
  if (is.null(plot_vars$city)) plot_vars$city <- input$city # pentru pronire variabile default
  uhi <- fread(paste0("www/data/tabs/suhi/suhi_",plot_vars$city,"_v02.csv"))[,c("date", "uhi.min", "uhi.max")]
  lst <- fread(paste0("www/data/tabs/suhi/stats_",plot_vars$city,"_v02.csv"))[,c("date", "med.urb", "med.rur")]
  
  datas <- 
    merge(uhi, lst, by= "date") |>
    filter(date <= input$days_suhi)
  
  # nume grafic
  name <- select_input_cities$label[select_input_cities$choice == plot_vars$city]
  param <-  names(choices_map)[choices_map == params()$param]
  # culoare grafic in functie de parametru
  color <- map_urban_graph_color(param)
  
  hc_plot(
    input =  datas, xaxis_series = params()$param, filename_save = paste0(plot_vars$city , "_", params()$param),
    cols =  color, names = paste(name, param), ytitle = "°C"
  )
})  |>
  bindCache(input$days_suhi,input$parameter,input$map_shape_click$id) #|>
#   bindEvent(input$map_shape_click$id)# pentru cache


output$downloadDataMap <- downloadHandler(
  filename = function() {
    paste0('data_map-', gsub(" " , "_",params()$param.label),"_",input$days_suhi, '.csv')
  },
  content = function(con) {
    write.csv(params()$param_data %>% dplyr::select("id", "values"), con)
  }
)
