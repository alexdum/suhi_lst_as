#show raster values on the map
show_pop <- function(x = NULL, y = NULL, rdat = NULL, proxy = NULL) {
  cell <- cellFromXY(rdat, c(x, y))
  if (!is.null(cell)) {
    xy <- xyFromCell(rdat, cell)
    val = rdat[cell]
    if (!is.na(val)) proxy %>% clearPopups() %>% addPopups(xy[1],xy[2], popup = paste("LST: ", round(val,1)))
  }
}