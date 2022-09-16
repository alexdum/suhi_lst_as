# https://stackoverflow.com/questions/54679054/r-leaflet-use-pane-with-addrasterimage                                  format(max(dats.act), "%B %d, %Y")))

# colors continental urban scale
domain <- c(-40, 60)
pal_rev <- colorNumeric("RdYlBu", domain = domain, reverse = F, na.color = "transparent")
pal <- colorNumeric("RdYlBu", domain = domain, reverse = T, na.color = "transparent")

output$text_map_europe <- renderText({
  paste0("Daily LST ",input$param_europe," values: ", format(input$days_europe, "%B %d, %Y") ," (click on map to see the LST value)")
})


#lst <- lst.avg[[which(as.character(dats.lst.avg) %in% as.character("2021-01-01"))]]

reactiveAct <- eventReactive(
  list(isolate(input$tab_maps), input$days_europe,  input$param_europe), {
    index <- which(as.character(dats.lst.avg) %in% as.character(input$days_europe))
    
    switch (
      which(c("avg","min","max" ) %in%  input$param_europe),
      lst <- lst.avg,
      lst <- lst.min,
      lst <- lst.max
    )
    
    lst <- lst[[index]]
    list(lst = lst, index = index)
  })

output$map.europe <- renderLeaflet({
  leaflet( 
    options = leafletOptions(minZoom = 3, maxZoom = 12)) %>%
    setView(25, 46, zoom = 3) %>%
    setMaxBounds(-13.5, 30, 57, 65) %>%
    addMapPane(name = "raster", zIndex = 410) %>%
    addMapPane(name = "maplabels", zIndex = 420)%>% 
    addProviderTiles("CartoDB.PositronNoLabels") %>%
    addProviderTiles("Stamen.TonerLines") %>%
    addRasterImage(
      lst.avg[[isolate(reactiveAct()$index)]], colors = pal, opacity = .8,
      options = leafletOptions(pane = "raster")
    )  %>%
    addProviderTiles(
      "CartoDB.PositronOnlyLabels",
      options = pathOptions(pane = "maplabels")
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
    )  %>% 
    clearControls() %>%
    addLegend(
      title =  "     °C",
      position = "bottomright",
      pal = pal_rev, values = domain,
      opacity = 1,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
    )
  
})

observe({
  lst <- reactiveAct()$lst
  leafletProxy("map.europe") %>%
    clearImages() %>%
    #addProviderTiles("CartoDB.PositronNoLabels") %>%
    #addProviderTiles("Stamen.TonerLines") %>%
    addRasterImage(lst, colors = pal, opacity = .8)  
  #addProviderTiles("CartoDB.PositronOnlyLabels") %>%
})

#Observer to show Popups on click https://stackoverflow.com/questions/37523323/identify-position-of-a-click-on-a-raster-in-leaflet-in-r
observe({ proxy <- leafletProxy("map.europe")

click <- input$map.europe_click

if (!is.null(click)) {
  lst <- reactiveAct()$lst
  cell <- cellFromXY(lst, c(click$lng, click$lat))
  rc <- rowColFromCell(lst, cell)
  val = lst[cell]
  if (!is.na(val)) proxy %>% clearPopups() %>% addPopups(click$lng,click$lat, popup = paste("LST: ", round(val,1)))
}

})