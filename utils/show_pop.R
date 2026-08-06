show_pop <- function(x = NULL, y = NULL, val = NULL, proxy = NULL) {
  if (!is.null(val) && !is.na(val)) {
    proxy %>% clearPopups() %>% addPopups(x, y, popup = paste0("<b>Value:</b> ", round(val, 1)))
  }
}