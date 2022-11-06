# https://stackoverflow.com/questions/54679054/r-leaflet-use-pane-with-addrasterimage                                  format(max(dats.act), "%B %d, %Y")))

# colors continental urban scale
domain_daily <- c(-30, 70)
pal_rev_daily <- colorNumeric("RdYlBu", domain = domain_daily, reverse = F, na.color = "transparent")
pal_daily <- colorNumeric("RdYlBu", domain = domain_daily, reverse = T, na.color = "transparent")

output$text_map_europe <- renderText({
  paste0("Daily LST ",input$param_europe," values: ", format(input$days_europe, "%B %d, %Y") ," (click on map to see or plot the LST value)")
})


#lst <- lst.avg[[which(as.character(dats.lst.avg) %in% as.character("2021-01-01"))]]

reactiveAct <- reactive ({
  index <- which(as.character(dats.lst.avg) %in% as.character(input$days_europe))
  
  
  switch (
    which(c("avg","min","max" ) %in%  input$param_europe_daily),
    lst <- lst.avg,
    lst <- lst.min,
    lst <- lst.max
  )
  
  
  lst <- lst[[index]]
  list(lst = lst, index = index)
}) %>% 
  bindCache(input$days_europe,  input$param_europe_daily) %>% 
  bindEvent(isolate(input$tab_maps), input$days_europe,  input$param_europe_daily)

output$map.europe <- renderLeaflet({
  leaflet( 
    data = cities_map,
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
    addProviderTiles("Stamen.TonerLines") %>% 
    addRasterImage(
      lst.avg[[isolate(reactiveAct()$index)]], colors = pal_daily, opacity = .8
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
      title =  "     °C",
      position = "bottomright",
      pal = pal_rev_daily, values = domain_daily,
      opacity = 1,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
    )
  
})


observe({
  
  #withProgress(message = 'Plot LST data', value = 0, {
  lst <- reactiveAct()$lst
  leafletProxy("map.europe") %>%
    clearImages() %>%
    #addProviderTiles("CartoDB.PositronNoLabels") %>%
    #addProviderTiles("Stamen.TonerLines") %>%
    addRasterImage(lst, colors = pal_daily, opacity = .8)  
  #addProviderTiles("CartoDB.PositronOnlyLabels") %>%
  # Pause for 0.1 seconds to simulate a long computation.
  #Sys.sleep(0.1)
  #  })
})

# reactive values pentru plot lst time series din raster
values_plot_lst <- reactiveValues(input = NULL, title = NULL, cors = NULL)

# Observer to show Popups on click https://stackoverflow.com/questions/37523323/identify-position-of-a-click-on-a-raster-in-leaflet-in-r
observe({ 
  proxy <- leafletProxy("map.europe")
  click <- input$map.europe_click
  lst <- reactiveAct()$lst
  # afiseaza popup sau grafic time series
  if (input$radio == 1 & !is.null(click)) {
    show_pop(x = click$lng, y = click$lat, rdat = lst, proxy = proxy)
  } else {
    proxy %>% clearPopups()
    # grafic timeseries
    if (!is.null(click)) {
      cell <- terra::cellFromXY(lst, cbind(click$lng, click$lat))
      xy <- terra::xyFromCell(lst, cell)
      dd <- extract_point(fname = paste0("www/data/ncs/wmo_6_msg_lst_as_daily_dineof_", input$param_europe_daily,".nc"), lon = xy[1], lat = xy[2], variable = 'MLST-AS') 
      # pentru afisare conditional panel si titlu grafic coordonates
      condpan.txt <- ifelse(
        is.na(mean(dd, na.rm = T)) | is.na(cell), 
        "nas", 
        paste0("Extracted LST ",input$param_europe_daily," values for point lon = ",round(click$lng, 5)," lat = "  , round(click$lat, 5))
      )
      output$condpan <- renderText({
        condpan.txt 
      })
      outputOptions(output, "condpan", suspendWhenHidden = FALSE)
      # subseteaza in dunctie de data selectata
      ddf <- data.frame(date = as.Date(names(dd)), lst = round(dd, 1)) %>% slice(1:reactiveAct()$index)
      
      # valori pentru plot la reactive values
      values_plot_lst$title <- condpan.txt
      values_plot_lst$input <- ddf
      values_plot_lst$cors <- paste0(round(click$lng, 5), "_", round(click$lat, 5))
      
    }
  }
})

# plot actualizat daca schimb si coordonatee
output$lst_rast <- renderHighchart({
  req(!is.na(values_plot_lst$input))
  hc_plot(
    input =  values_plot_lst$input , xaxis_series = c("lst"), filename_save = "lst",
    cols = c("#800026"), names = c("LST"), ytitle = "LST [°C]",
    title =   values_plot_lst$title
  )
})


output$downloadLST <- downloadHandler(
  filename = function() {
    paste0('lst_',input$param_europe_daily,"_", values_plot_lst$cors, '.csv')
  },
  content = function(con) {
    write.csv(values_plot_lst$input, con)
  }
)


# 