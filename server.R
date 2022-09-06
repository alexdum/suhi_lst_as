

server <- shinyServer(function(input, output, session) {
  
  
  
  output$suhi <- renderHighchart({
    
    uhi <- read.csv(paste0("www/data/tabs/suhi/suhi_",input$city,"_v02.csv")) %>%
      mutate(date = as.Date(date))
    
    hc_plot(
      input = uhi, xaxis_series = c("uhi.max", "uhi.min"), filename_save = paste0(input$city, "_suhi"),
           cols =  c("#800026","#fd8d3c" ), names = c("SUHI Max", "SUHI Min")
      )
  
    
  })
  
  output$lst <- renderHighchart({
    
    lst <- read.csv(paste0("www/data/tabs/suhi/stats_",input$city,"_v02.csv")) %>%
      mutate(date = as.Date(date))
 
    
    hc_plot(
      input = lst, xaxis_series = c("med.urb", "med.rur"), filename_save = paste0(input$city, "_lst"),
      cols =  c("#ef3b2c","#9ecae1"), names = c("Urban", "Rural")
    )
    
  
    
  })
  
  
})
