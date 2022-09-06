

server <- shinyServer(function(input, output, session) {
  
  
  text.cust <- reactive({
    city <- select_input_cities$label[select_input_cities$choice == input$city]
    list(city = city)
  })
  
  # titluri grafice
  output$text_uhi <- renderText({
    paste("Minimum and maximum Surface Urban Heat Island - ", text.cust()$city)
  })
  output$text_lst <- renderText({
    paste("Urban and Rural Land Surface Temperature - ", text.cust()$city)
  })
  
  
  
  datas <- reactive({
    uhi <- read.csv(paste0("www/data/tabs/suhi/suhi_",input$city,"_v02.csv")) %>%
      mutate(date = as.Date(date))
    lst <- read.csv(paste0("www/data/tabs/suhi/stats_",input$city,"_v02.csv")) %>%
      mutate(date = as.Date(date))
    
    datas <- left_join(uhi,lst, by = c("date"))
    
    list(datas = datas)
  })
  # grafice
  output$suhi <- renderHighchart({
    
    
    hc_plot(
      input = datas()$datas, xaxis_series = c("uhi.max", "uhi.min"), filename_save = paste0(input$city, "_suhi"),
      cols =  c("#800026","#fd8d3c" ), names = c("SUHI Max", "SUHI Min"), ytitle = "SUHI [°C]"
    )
  })
  
  output$lst <- renderHighchart({
    hc_plot(
      input = datas()$datas, xaxis_series = c("med.urb", "med.rur"), filename_save = paste0(input$city, "_lst"),
      cols =  c("#ef3b2c","#9ecae1"), names = c("Urban", "Rural"), ytitle = "LST [°C]"
    )

  })
  
  

  
  output$downloadData <- downloadHandler(
  
      filename = function() {
        paste0('data-', input$city, '.csv')
      },
      content = function(con) {
        write.csv(datas()$datas, con)
      }
    )
  
})
