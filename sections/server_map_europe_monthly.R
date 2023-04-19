# https://stackoverflow.com/questions/54679054/r-leaflet-use-pane-with-addrasterimage                                  format(max(dats.act), "%B %d, %Y")))

# colors continental urban scale
domain_indicator <- c(-50, 60)
pal_rev_indicator <- colorNumeric("RdYlBu", domain = domain_indicator, reverse = F, na.color = "transparent")
pal_indicator <- colorNumeric("RdYlBu", domain = domain_indicator, reverse = T, na.color = "transparent")

output$text_map_europe_monthly <- renderText({
  
  switch( # alege nume indicator care să fie afișat
    which(c("mn", "mm" ,"mx","cwmn00", "hwmn20","hwmx35") %in% input$parameter_europe_monthly),
    name_indicator <- "LST monthly minimum",
    name_indicator <- "LST monthly average",
    name_indicator <- "LST monthly maximum",
    name_indicator <- "CW (cold waves defined as monthly maximum no of consecutive days when LST min ≤ 0)",
    name_indicator <- "HW20 (heat waves defined as monthly maximum no of consecutive days when LST min ≥ 20)",
    name_indicator <- "HW35 (heat waves defined as monthky maximum no of consecutive days whenLST max  ≥ 35)"
  )
  
  paste0(input$month_indicator," : ",name_indicator," (click on map to see or plot the grid value)")
  
})


reac_lst_indicator <- reactive ({
  
  index <- which(format(dats.lst.mm, "%Y %b") %in% input$month_indicator)
  
  switch (
    which(c("mn", "mm" ,"mx", "cwmn00", "hwmn20","hwmx35") %in% input$parameter_europe_monthly),
    lst <- lst.mn,
    lst <- lst.mm,
    lst <- lst.mx,
    lst <- lst.cwmn00,
    lst <- lst.hwmn20,
    lst <- lst.hwmx35
  )
  
  lst <- lst[[index]]
  list(lst = lst, index = index)
  
}) %>%
  bindCache(input$month_indicator,  input$parameter_europe_monthly) %>%
  bindEvent(isolate(input$tab_maps), input$month_indicator, input$parameter_europe_monthly)

output$map_europe_indicator <- renderLeaflet({
  leaflet_fun(
    cities_map, lst.mm[[isolate(reac_lst_indicator()$index)]], 
    domain = domain_indicator, cols = pal_indicator, cols_rev = pal_rev_indicator 
    )
})

observe({
  lst <- reac_lst_indicator()$lst
  leafletProxy("map_europe_indicator") %>%
    clearImages() %>%
    addRasterImage(lst, colors = pal_indicator, opacity = .8)
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
      fil.nc <- paste0("www/data/ncs/wmo_6_msg_lst_as_daily_dineof_t", input$parameter_europe_monthly,".nc")
      dd <- extract_point(fname = fil.nc , lon = xy[1], lat = xy[2], variable = 'MLST-AS') 
      # pentru afisare conditional panel si titlu grafic coordonates
      condpan_monthly.txt <- ifelse(
        is.na(mean(dd, na.rm = T)) | is.na(cell), 
        "nas", 
        paste0("Extracted LST ",input$param_europe_monthly," values for point lon = ",round(click$lng, 5)," lat = "  , round(click$lat, 5))
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


