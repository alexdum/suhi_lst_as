hc_plot <- function(input, xaxis_series, filename_save, cols, names, ytitle) {
  
  hh <-  
    highchart(type = "stock")  |>
    hc_xAxis(type = "date") |>
    hc_add_series(input,type = "line", hcaes_string("date", xaxis_series[1]), color = cols[1], name = names[1]) |>
    hc_add_series(input,type = "line", hcaes_string("date", xaxis_series[2]), color = cols[2], name = names[2]) |>
    hc_legend(enabled = T) |>
    hc_exporting(
      enabled = TRUE, # always enabled
      filename =  filename_save) |>
    hc_yAxis(title = list(text = ytitle),
             opposite = TRUE,
             minorTickInterval = "auto",
             minorGridLineDashStyle = "LongDashDotDot",
             showFirstLabel = FALSE,
             showLastLabel = FALSE
    )
  
  
  return(hh)
}