hc_plot <- function(input, yaxis, filename_save, cols) {
  
  hh <- hchart(
    input, "line",
    hcaes(x = date, y = uhi, group = area) ,
    color = cols
  ) %>%
    hc_xAxis(
      title = list(text = "Days") # Large bolded titles
    ) %>%
    hc_yAxis(yaxis,
      title = list(text = yaxis) # Large bolded titles
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
      filename =  filename_save
    )
  
  return(hh)
}