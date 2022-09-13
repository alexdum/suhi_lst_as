# data vezi in global
# omi.act <- raster::stack("data/OMI-Aura/OMI-Aura_L3-OMNO2d_monthly.nc")
# omi.act <- omi.act/10^15  
# dats.act <- as.Date(names(omi.act), "X%Y.%m.%d")
# 
# omi.act[omi.act > 8] <- 8
# omi.act[omi.act < 2] <- 2

# output$mapno2_act.text <- renderText(paste0("Satellite Observed Tropospheric NO₂ Concentration - montlhy means January 01, 2020 - ", 
#                                             format(max(dats.act), "%B %d, %Y")))

output$text_map_europe <- renderText({
  paste0("Daily LST ",input$param_europe," values: ", format(input$days_europe, "%B %d, %Y"))
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
    print(summary(lst))
    list(lst = lst)
  })

output$map_europe <- renderLeaflet({
  leaflet( 
    options = leafletOptions(minZoom = 3, maxZoom = 12)) %>%
    setView(25, 46, zoom = 3) %>%
    setMaxBounds(-13.5, 30, 57, 65) %>% 
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
  
})


observe({
  
  # colors continental urban scale
  domain <- c(-40, 60)
  pal_rev <- colorNumeric("RdYlBu", domain = domain, reverse = F, na.color = "transparent")
  pal <- colorNumeric("RdYlBu", domain = domain, reverse = T, na.color = "transparent")

  lst <- reactiveAct()$lst
  leafletProxy("map_europe") %>%
    clearImages() %>%
    addProviderTiles("CartoDB.PositronNoLabels") %>%
    addProviderTiles("Stamen.TonerLines") %>%
    addRasterImage(lst, colors = pal, opacity = .8)  %>%
    addProviderTiles("CartoDB.PositronOnlyLabels") %>%
    clearControls() %>%
    addLegend(
      title =  "     °C",
      position = "bottomright",
      pal = pal_rev, values = domain,
      opacity = 1,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
    )
  
})