

server <- shinyServer(function(input, output, session) {
  
  
  
  output$suhi <- renderHighchart({
    
    uhi_day <- read.csv(paste0("www/data/tabs/suhi/suhi_",input$city,"_v02.csv")) %>%
      mutate(date = as.Date(date))
    uhi_day.longf <- uhi_day %>% dplyr::select(date, uhi.max, uhi.min) %>%
      pivot_longer(!date, names_to = "area", values_to = "values") 
    #grafic cu suhi
    hc_plot(
      input = uhi_day.longf , yaxis = "SUHI [°C]", filename_save =  paste0(input$city, "_uhi"), cols =  c( "red", "blue")
    )
    
  })
  
  output$lst <- renderHighchart({
    
    lst <- read.csv(paste0("www/data/tabs/suhi/stats_",input$city,"_v02.csv")) %>%
      mutate(date = as.Date(date))
    lst.longf <- lst %>% dplyr::select(date,  min.urb,     min.rur, max.urb,  max.rur) %>%
      pivot_longer(!date, names_to = "area", values_to = "values") 
    #grafic cu lst
    hc_plot(
      input = lst.longf,
      
      yaxis = "LST [°C]",
      filename_save = paste0(input$city, "_lst"), 
      cols =  c( "#a50f15","#ef3b2c","#4292c6","#9ecae1")
    )
    
  })
  

  
  
})
