# culori culori leaflet ---------------------------------------------------------
colintYlOrRd <- colorRampPalette( brewer.pal(9,"YlOrRd"),interpolate = "linear")
colintRdYlBu <- colorRampPalette(brewer.pal(10,"RdYlBu"),interpolate = "linear")
colintBrBG <- colorRampPalette( brewer.pal(11,"BrBG")[1:5],interpolate = "linear")
colintBlues <- colorRampPalette(brewer.pal(9,"Blues"), interpolate = "linear")
colintReds <- colorRampPalette(brewer.pal(9,"Reds"), interpolate = "linear")
colintBuPu <- colorRampPalette(brewer.pal(9,"BuPu"), interpolate = "linear")
colintPuBu <- colorRampPalette(brewer.pal(9,"BuPu"), interpolate = "linear")
colintPuRd <- colorRampPalette(brewer.pal(9,"PuRd"), interpolate = "linear")
colintYlOrBr <- colorRampPalette(brewer.pal(9,"YlOrBr"), interpolate = "linear")
colintinferno <- colorRampPalette(rev(viridis::inferno(14)), interpolate = "linear")
colintGnBu <- colorRampPalette(brewer.pal(9,"GnBu"), interpolate = "linear")
colintRdPu <- colorRampPalette(brewer.pal(9,"RdPu"), interpolate = "linear")
colintBrBG <- colorRampPalette(brewer.pal(11,"BrBG"),interpolate = "linear")
colintYlGn <- colorRampPalette(brewer.pal(9,"YlGn"),interpolate = "linear")
colintPuOr <- colorRampPalette(brewer.pal(9,"PuOr"),interpolate = "linear")
colintOrRd <- colorRampPalette( brewer.pal(9,"OrRd"),interpolate = "linear")
colintPRGn <- colorRampPalette( brewer.pal(11,"PRGn"),interpolate = "linear")
colintPiYG <- colorRampPalette( brewer.pal(11,"PiYG"),interpolate = "linear")
#windabs <- colorRampPalette(rainbow(8)[2:8],interpolate = "linear")
windabs2 <- colorRampPalette(colors = c("#00FF00", "#33FF33", "#66FF66", "#99FF99", "#CCFFCC", "#FFFF00", "#FFCC00", "#FF9900", "#FF6600", "#FF3300", "#FF0000", "#990000"), interpolate = "linear")
colintHWD <- colorRampPalette(colors = c("#FFFF00", "#FFCC00", "#FF9900", "#FF6600", "#FF3300", "#FF0000", "#CC0000", "#990000", "#660000", "#330000"),  interpolate = "linear")
colintCWDabs <- colorRampPalette(colors = c("#00FFFF", "#00CCFF", "#0099FF", "#0066FF", "#0033FF", "#0000FF", "#0000CC", "#000099", "#000066", "#000033"),  interpolate = "linear")
colintCWDano <- colorRampPalette(colors = c("#00FF00", "#33FF33", "#66FF66", "#99FF99", "#CCFFCC", "#FFFFFF", "#CCCCFF", "#9999FF", "#6666FF", "#3333FF", "#0000FF"),  interpolate = "linear")



#windabs2 <- colorRampPalette(c("#6389B3","#5BB2B8", "#3AB284","#3AB284", "#8DCE6B", "#AEC356", "#CAB942", "#AC4D85", "#AC4D85", "#9645A3","#895CAC", "#9C49D5","#D3B4ED", "#F6DFDF" , "white"),interpolate = "linear")
map_func_cols <- function(indic = NA,  domain = NA) {
  # culori interpolate
  
  if (indic %in% c("mn", "mx", "mm")) {
        df.col <- data.frame(
          cols = rev(colintRdYlBu(21)), 
          vals = seq(-50,50,5)
        ) 
    
      leaflet_titleg <- paste0("<html>", gsub(",","",toString(rep("&nbsp;", 5))), "°C","</html>")
  
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

