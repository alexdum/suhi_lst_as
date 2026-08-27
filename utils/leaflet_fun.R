# helper OpenFreeMap vector tiles (separated base and top labels)
addOpenFreeMap <- function(map) {
  htmlwidgets::onRender(
    map,
    "
      function(el, x) {
        var map = this;
        if (typeof L.maplibreGL === 'function') {
          // 1. Base map without labels in tilePane
          L.maplibreGL({
            style: 'styles/positron_nolabels.json',
            interactive: false,
            pane: 'tilePane'
          }).addTo(map);

          // 2. Transparent labels layer placed on top in maplabels pane (zIndex 420)
          var labelsLayer = L.maplibreGL({
            style: 'styles/positron_onlylabels.json',
            interactive: false,
            pane: 'maplabels'
          }).addTo(map);

          if (map.layerManager) {
            map.layerManager.addLayer(labelsLayer, 'tile', null, 'Labels');
          }
        }
      }
    "
  )
}

# functie harta
leaflet_fun <- function(data, raster, domain, cols, cols_rev, title) {
  
  
  map <- leaflet(
    data = data,
    options = leafletOptions(minZoom = 3, maxZoom = 12, doubleClickZoom = FALSE)) %>%
    setView(25, 46, zoom = 3) %>%
    setMaxBounds(-12, 27.58, 56, 71.5) %>%
    #addMapPane(name = "raster", zIndex = 410) %>%
    addMapPane(name = "citie", zIndex = 415) %>%
    addMapPane(name = "maplabels", zIndex = 420) %>%
    addOpenFreeMap() %>%
    addLayersControl(
      overlayGroups = c("Labels", "City borders")) %>%
    addRasterImage(
      raster, colors = cols, opacity = .8
      # options = leafletOptions(pane = "raster")
    )  %>%
    addPolygons(
      color = "#444444", weight = 1, smoothFactor = 0.5,
      opacity = 0.7, fillOpacity = 0.1,
      highlightOptions = highlightOptions(color = "white", weight = 2,
                                          bringToFront = TRUE),
      options = pathOptions(pane = "citie"),
      group = "City borders"
    ) %>%
    addEasyButton(
      easyButton(
        icon    = "glyphicon glyphicon-home", title = "Reset zoom",
        onClick = JS("function(btn, map){ map.setView([46, 25], 3); }")
      )
    ) %>%
    addScaleBar(
      position = c("bottomleft"),
      options = scaleBarOptions(metric = TRUE)
    ) %>%
    leafem::addMouseCoordinates() %>%
    clearControls() %>%
    addLegend(
      title = title,
      position = "bottomright",
      pal = cols_rev, values = domain,
      opacity = 1,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
    )
  return(map)
}