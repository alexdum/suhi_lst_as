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
  paste0("Satellite Observed Tropospheric NO₂ Concentration - montlhy means January 01, 2020 - ", 
         format(input, "%B %d, %Y"))
})

# set color palette
color_pal <- colorNumeric(rev(c('#0A0615','#190D3D','#a50026','#d73027','#f46d43','#fdae61','#fee090','#ffffbf','#e0f3f8','#abd9e9','#74add1','#4575b4')),
                          domain = c(-30, 60),
                          na.color = "transparent")

# pal = colorNumeric(c("#7f007f", "#0000ff",  "#007fff", "#00ffff", "#00bf00", "#7fdf00",
#                      "#ffff00", "#ff7f00", "#ff3f00", "#ff0000", "#bf0000"), values(sst.tz),  na.color = "transparent")


#lst <- lst.avg[[which(as.character(dats.lst.avg) %in% as.character("2021-01-01"))]]

reactiveAct <- eventReactive(
  list(isolate(input$tab_maps), input$days_europe), {
    
    index <- which(as.character(dats.lst.avg) %in% as.character(input$days_europe))
    print(input$days_europe)
    list(index = index)
  })

output$map_europe <- renderLeaflet({
  leaflet( 
    options = leafletOptions(minZoom = 3, maxZoom = 12)) %>%
    setView(25, 46, zoom = 3) %>%
    setMaxBounds(-13.5, 30, 57, 65) %>% 
    
    #ddTiles(group = "OSM ") %>%
    #addProviderTiles(providers$Stamen.Toner, group = "Toner (default)") %>%
    addProviderTiles(providers$Stamen.TonerLite) %>%
    addProviderTiles(providers$Stamen.TonerLabels) %>%
    addRasterImage( lst.avg[[isolate(reactiveAct()$index)]], colors = color_pal, opacity = .8)  %>%
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

  lst <- lst.avg[[reactiveAct()$index]]
  leafletProxy("map_europe") %>%
    clearImages() %>%
    addProviderTiles(providers$Stamen.TonerLite) %>%
    addRasterImage(lst, colors = color_pal, opacity = .8)  %>%
  addProviderTiles(providers$Stamen.TonerLabels) 
  
  
  
})