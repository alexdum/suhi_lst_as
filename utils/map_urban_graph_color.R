map_urban_graph_color <- function(parameter) {
  if(parameter == "SUHI Min") {
    color <- "#fd8d3c"
  } else if (parameter == "SUHI Max") {
    color <- "#800026"
  } else if (parameter == "Urban LST") {
    color <- "#ef3b2c" 
  } else {
    color <- "#9ecae1" 
  }
  return(color)
}

