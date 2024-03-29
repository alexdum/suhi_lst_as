mapa_fun_cols <- function(indic = NA,  domain = NA) {
  # culori interpolate
  # culori culori leaflet ---------------------------------------------------------
  colintRdYlBu <- colorRampPalette(brewer.pal(10,"RdYlBu"),interpolate = "linear")
  colintBuPu <- colorRampPalette(brewer.pal(9,"BuPu"),interpolate = "linear")
  colintYlOrBr <- colorRampPalette(brewer.pal(9,"YlOrBr"),interpolate = "linear")
  
  if (indic %in% c("mn", "mx", "mm")) {
        df.col <- data.frame(
          cols = rev(colintRdYlBu(21)), 
          vals = seq(-50,50,5)
        ) 
      leaflet_titleg <- paste0("<html>", gsub(",","",toString(rep("&nbsp;", 5))), "°C","</html>")
  }
  
  if (indic %in% c("cwmn00","cwdi")) {
    df.col <- data.frame(
      cols = colintBuPu(16), 
      vals = seq(1,31, 2)
    ) 
    leaflet_titleg <- paste0("<html>", "consec. days","</html>")
  }
  
  if (indic %in% c("trmn20","hwmx35", "hwdi")) {
    df.col <- data.frame(
      cols = colintYlOrBr(16), 
      vals = seq(1,31, 2)
    ) 
    leaflet_titleg <- paste0("<html>", "consec. days","</html>")
  }
  
  
  
  # print(head(df.col))
  # print(domain)
  ints <- findInterval(domain, df.col$vals, rightmost.closed = T, left.open = F)
  
  bins <-  df.col$vals[ints[1]:(ints[2] + 1)]
  cols <- df.col$cols[ints[1]:(ints[2])]
  
  # print(bins)
  # print(cols)
  # 
  pal <- colorBin(cols, domain = domain, bins = bins, na.color = "transparent")
  pal2 <- colorBin(cols, domain = domain, bins = bins, reverse = T, na.color = "transparent")
  
  return(list(pal = pal, pal_rev = pal2, tit_leg = leaflet_titleg))
  
}

# indicators_def <- function(indicators) {
#   switch (
#     which(c("heatuspring","heatufall","scorchno","scorchu", "coldu","frostu10", "frostu15","frostu20","prveget", "prfall", "prwinter" ) %in%  indicators),
#     
#     text.desc <- "Cumulative heat units (ΣTmed. > 0°C) in the period 01 February - 10 April",
#     text.desc <- "Cumulative heat units (ΣTmed. > 0°C) in the period 01 September - 31 October",
#     text.desc <- "Scorching heat units (ΣTmax. ≥ 32°C) from 1 June to 31 August",
#     text.desc <- "Scorching heat number of days (Tmax. ≥ 32°C) from 1 June to 31 August",
#     text.desc <- "Cold units (ΣTmed. < 0°C) cumulated during the period 01 November - 31 March",
#     text.desc <- "Frost units (ΣTmin. ≤ -10°C) cumulated in the period 01 December - 28/29 February",
#     text.desc <- "Frost units (ΣTmin. ≤ -15°C) cumulated in the period 01 December - 28/29 February",
#     text.desc <- "Frost units (ΣTmin. ≤ -20°C) cumulated in the period 01 December - 28/29 February",
#     text.desc <- "Precipitatin amounts (l/m²) during the autumn wheat growing season, 01 September to 30 June",
#     text.desc <- "Precipitation amounts (l/m²) during the autumn sowing period, 01 September - 31 October",
#     text.desc <- "Precipitation amounts (l/m²) during the soil water accumulation period, 01 November - 31 March",
#   )
#   return(text.desc)
#   
# }

