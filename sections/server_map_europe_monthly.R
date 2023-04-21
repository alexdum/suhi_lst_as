# https://stackoverflow.com/questions/54679054/r-leaflet-use-pane-with-addrasterimage                                  format(max(dats.act), "%B %d, %Y")))


output$text_map_europe_monthly <- renderText({
  
  switch( # alege nume indicator care să fie afișat
    which(c("mn", "mm" ,"mx","cwmn00", "trmn20","hwmx35", "hwdi", "cwdi") %in% input$parameter_europe_monthly),
    name_indicator <- "LST monthly minimum",
    name_indicator <- "LST monthly average",
    name_indicator <- "LST monthly maximum",
    name_indicator <- "CW - cold waves defined as monthly maximum no of consecutive days when LST min ≤ 0 °C",
    name_indicator <- "TR20 - number of consecutive days when daily minimum temperature ≥ 20 °C",
    name_indicator <- "HW35 - heat waves defined as monthky maximum no of consecutive days whenLST max  ≥ 35 °C",
    name_indicator <- "HWDI - the number of days per time period where in intervals of at least 6 consecutive days the daily maximum temperature is more than 5 degrees above a reference value. The reference value is calculated as the mean of maximum temperatures of a five day",
    name_indicator <- "CWDI - the number of days per time period where in intervals of at least 6 consecutive days the daily minimum temperature is more than 5 degrees below a reference value. The reference value is calculated  as the mean of minimum temperatures of a five day")
  
  paste0(input$month_indicator," : ",name_indicator," (click on map to see or plot the grid value)")
  
})


reac_lst_indicator <- reactive ({
  
  index <- which(format(dats.lst.mm, "%Y %b") %in% input$month_indicator)
  indicator <- input$parameter_europe_monthly
  # indicator <- "mm" 
  
  switch (
    which(c("mn", "mm" ,"mx", "cwmn00", "trmn20","hwmx35", "hwdi", "cwdi") %in% input$parameter_europe_monthly),
    lst <- lst.mn,
    lst <- lst.mm,
    lst <- lst.mx,
    lst <- lst.cwmn00,
    lst <- lst.trmn20,
    lst <- lst.hwmx35,
    lst <- lst.hwdi,
    lst <- lst.cwdi
  )
  
  
  lst <- lst[[index]]
  lst[lst > 50] <- 50
  lst[lst  < -50] <- -50
  #if (indicator %in% c("cwmn00", "trmn20","hwmx35")) lst[lst ==0] <- NA # na pentru cand nu ai zile cu indicator
  domain <- terra::minmax(lst)
  
  map_leg <- mapa_fun_cols(indic = indicator, domain )
  
  
  list(lst = lst, index = index, domain = domain, pal =  map_leg$pal, pal_rev =  map_leg$pal_rev,  
       tit_leg  =   map_leg$tit_leg)
  
}) %>%
  bindCache(input$month_indicator,  input$parameter_europe_monthly) %>%
  bindEvent(isolate(input$tab_maps), input$month_indicator, input$parameter_europe_monthly)

output$map_europe_indicator <- renderLeaflet({
  leaflet_fun(
    cities_map,
    isolate(reac_lst_indicator()$lst), 
    domain =   isolate(reac_lst_indicator()$domain),
    cols = isolate(reac_lst_indicator()$pal), 
    cols_rev = isolate(reac_lst_indicator()$pal_rev),
    title = isolate(reac_lst_indicator()$tit_leg)
  )
})

observe({
  lst <- reac_lst_indicator()$lst
  leafletProxy("map_europe_indicator") %>%
    clearImages() %>%
    addRasterImage(
      lst, 
      colors = reac_lst_indicator()$pal,  
      opacity = .8 ) %>%
    clearControls() %>%
    leaflet::addLegend(
      title = reac_lst_indicator()$tit_leg,
      position = "bottomright",
      pal = reac_lst_indicator()$pal_rev, values =  reac_lst_indicator()$domain,
      opacity = 1,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
    )
})

# reactive values pentru plot lst time series din raster
values_plot_lst_mon <- reactiveValues(input = NULL, title = NULL, cors = NULL)

observe({
  proxy <- leafletProxy("map_europe_indicator")
  click <- input$map_europe_indicator_click
  lst <- reac_lst_indicator()$lst
  # afiseaza popup sau grafic time series
  if (input$radio_mon == 1 & !is.null(click)) {
    show_pop(x = click$lng, y = click$lat, rdat = lst, proxy = proxy)
  } else {
    proxy %>% clearPopups()
    # grafic timeseries
    if (!is.null(click)) {
      cell <- terra::cellFromXY(lst, cbind(click$lng, click$lat))
      xy <- terra::xyFromCell(lst, cell)
      
      if (input$parameter_europe_monthly %in% c("cwmn00", "trmn20","hwmx35","hwdi", "cwdi")) {
        fil.nc <- paste0("www/data/ncs/wmo_6_msg_lst_as_", input$parameter_europe_monthly,".nc")
        variable_sel = input$parameter_europe_monthly
      } else {
        fil.nc <- paste0("www/data/ncs/wmo_6_msg_lst_as_daily_dineof_t", input$parameter_europe_monthly,".nc")
        variable_sel = 'MLST-AS'
      }
      dd <- extract_point(fname = fil.nc , lon = xy[1], lat = xy[2], variable = variable_sel) 
      # pentru afisare conditional panel si titlu grafic coordonates
      condpan_monthly.txt <- ifelse(
        is.na(mean(dd, na.rm = T)) | is.na(cell), 
        "nas", 
        paste0("Extracted value ",input$param_europe_monthly," values for point lon = ",round(click$lng, 5)," lat = "  , round(click$lat, 5))
      )
      output$condpan_monthly <- renderText({
        condpan_monthly.txt 
      })
      outputOptions(output, "condpan_monthly", suspendWhenHidden = FALSE)
      # subseteaza in dunctie de data selectata
      ddf <- data.frame(date = as.Date(names(dd)), lst = round(dd, 1)) %>% slice(1:reac_lst_indicator()$index)
      
      # valori pentru plot la reactive values
      values_plot_lst_mon$title <- condpan_monthly.txt
      values_plot_lst_mon$input <- ddf
      values_plot_lst_mon$cors <- paste0(round(click$lng, 5), "_", round(click$lat, 5))
    }
  }
})

# plot actualizat daca schimb si coordonatee
output$lst_rast_mon <- renderHighchart({
  req(!is.na(values_plot_lst_mon$input))
  hc_plot(
    input =  values_plot_lst_mon$input , xaxis_series = c("lst"), filename_save = "lst_mon",
    cols = c("#800026"), names = c("LST"), ytitle = "LST [°C]",
    title =   values_plot_lst_mon$title
  )
})

output$downloadLST_mon <- downloadHandler(
  filename = function() {
    paste0('indicator_',input$parameter_europe_monthly,"_", values_plot_lst_mon$cors, '.csv')
  },
  content = function(con) {
    write.csv(values_plot_lst_mon$input, con)
  }
)


