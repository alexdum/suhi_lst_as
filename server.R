

server <- shinyServer(function(input, output, session) {
  
  
  
  output$suhi <- renderHighchart({
    
    uhi <- read.csv(paste0("www/data/tabs/suhi/suhi_",input$city,"_v02.csv")) %>%
      mutate(date = as.Date(date))
    
    #grafic cu lst
    highchart(type = "stock")  |>
      hc_xAxis(type = "datetime") |>
      hc_add_series(uhi,type = "line", hcaes(date, uhi.max), color = "#800026", name = "SUHI Max") |>
      hc_add_series(uhi,type = "line", hcaes(date, uhi.min), color = "#fd8d3c", name = "SUHI Min") |>
      hc_legend(enabled = T) |>
      hc_exporting(
        enabled = TRUE, # always enabled
        filename =  paste0(input$city, "_suhi")
      )
    
    
  })
  
  output$lst <- renderHighchart({
    
    lst <- read.csv(paste0("www/data/tabs/suhi/stats_",input$city,"_v02.csv")) %>%
      mutate(date = as.Date(date))
 
    #grafic cu lst
    highchart(type = "stock")  |>
      hc_xAxis(type = "datetime") |>
      hc_add_series(lst,type = "line", hcaes(date, med.urb), color = "#ef3b2c", name = "Urban") |>
      hc_add_series(lst,type = "line", hcaes(date, med.rur), color = "#9ecae1", name = "Rural") |>
      hc_legend(enabled = T) |>
      hc_exporting(
        enabled = TRUE, # always enabled
        filename =  paste0(input$city, "_lst")
      )
    
  })
  

  
  
})
