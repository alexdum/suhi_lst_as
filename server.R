

server <- shinyServer(function(input, output, session) {
  
 
  
  output$chart2 <- renderHighchart({
    
    uhi_day <- read.csv(paste0("www/data/tabs/",input$city,".csv")) %>%
             mutate(date = as.Date(date))
    uhi_day.longf <- uhi_day %>% dplyr::select(date, uhi.max, uhi.min) %>%
      pivot_longer(!date, names_to = "area", values_to = "uhi") 
    
    hchart(
      uhi_day.longf, "line",
      hcaes(x = date, y = uhi, group = area) ,
      color = c( "red", "blue")
    ) %>%
      hc_xAxis(
        title = list(text = "Days") # Large bolded titles
      ) %>%
      hc_yAxis(
        title = list(text = "LST AS [°C]") # Large bolded titles
      ) %>% 
      hc_navigator(
        enabled = TRUE, baseSeries = 1
      ) %>% 
      hc_rangeSelector(
        enabled = TRUE,
        selected = 3
      )  %>% 
      hc_exporting(
        enabled = TRUE, # always enabled
        filename = paste0(input$city, "_uhi_lst_as")
      )
    
  })
  

})
