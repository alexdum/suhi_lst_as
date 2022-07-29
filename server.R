

server <- shinyServer(function(input, output, session) {
  
 
  
  output$suhi <- renderHighchart({
    
    uhi_day <- read.csv(paste0("www/data/tabs/suhi/suhi_",input$city,"_v02.csv")) %>%
             mutate(date = as.Date(date))
    uhi_day.longf <- uhi_day %>% dplyr::select(date, uhi.max, uhi.min) %>%
      pivot_longer(!date, names_to = "area", values_to = "uhi") 
    #grafic cu suhi
   hc_plot(uhi_day.longf , yaxis = "SUHI [°C]", filename_save =  paste0(input$city, "_uhi_lst_as"), cols =  c( "red", "blue"))
    
  })
  

})
