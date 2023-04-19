text.cust <- reactive({
  city <- select_input_cities$label[select_input_cities$choice == input$city]
  list(city = city)
}) 

# titluri grafice
output$text_uhi <- renderText({
  paste("Minimum and maximum Surface Urban Heat Island - ", text.cust()$city)
})
output$text_lst <- renderText({
  paste("Urban and Rural Mean Land Surface Temperature - ", text.cust()$city)
})

datas <- reactive({
  uhi <- fread(paste0("www/data/tabs/suhi/suhi_",input$city,"_v02.csv"))[,c("date", "uhi.min", "uhi.max")]
  lst <- fread(paste0("www/data/tabs/suhi/stats_",input$city,"_v02.csv"))[,c("date", "med.urb", "med.rur")]
  # uhi <- fread(paste0("www/data/tabs/suhi/suhi_amman_v02.csv"))[,c("date", "uhi.min", "uhi.max")]
  # lst <- fread(paste0("www/data/tabs/suhi/stats_amman_v02.csv"))[,c("date", "med.urb", "med.rur")]
  
  datas <- merge(uhi, lst, by.x.y = "date")
  
  list(datas = datas)
}) 
# grafice
output$suhi <- renderHighchart({
  
  hc_plot(
    input = datas()$datas, xaxis_series = c("uhi.max", "uhi.min"), filename_save = paste0(input$city, "_suhi"),
    cols =  c("#800026","#fd8d3c" ), names = c("SUHI Max", "SUHI Min"), ytitle = "SUHI [°C]"
  )
}) %>% bindCache(input$city)

output$lst <- renderHighchart({
  hc_plot(
    input = datas()$datas, xaxis_series = c("med.urb", "med.rur"), filename_save = paste0(input$city, "_lst"),
    cols =  c("#ef3b2c","#9ecae1"), names = c("Urban", "Rural"), ytitle = "LST [°C]"
  )
  
})  %>% bindCache(input$city)

output$downloadData <- downloadHandler(
  
  filename = function() {
    paste0('data-', input$city, '.csv')
  },
  content = function(con) {
    write.csv(datas()$datas, con)
  }
)