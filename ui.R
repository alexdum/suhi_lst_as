source("sections/ui_graphs.R", local = T)
source("sections/ui_maps.R", local = T)
source("sections/ui_about.R", local = T)

app_theme <- bs_theme(
  version = 5,
  primary = "#e76f51",
  secondary = "#f4a261",
  bg = "#faf6f5",
  fg = "#2b2d42",
  "link-color" = "#bd3a1d"
)

hero_banner <- div(
  class = "container-fluid px-4",
  div(
    class = "hero-banner",
    div(
      class = "hero-banner-content",
      div(
        class = "hero-title-group",
        h1(class = "hero-title", "Urban Climate Explorer"),
        p(class = "hero-subtitle", "Monitoring Surface Urban Heat Island (SUHI) & Land Surface Temperature (LST) dynamics across European cities.")
      ),
      div(
        class = "hero-metrics-grid",
        div(
          class = "metric-card",
          div(class = "metric-icon", icon("city")),
          div(
            class = "metric-details",
            span(class = "metric-value", if (exists("select_input_cities")) paste(nrow(select_input_cities)) else "43"),
            span(class = "metric-label", "Cities Monitored")
          )
        ),
        div(
          class = "metric-card",
          div(class = "metric-icon", icon("globe-europe")),
          div(
            class = "metric-details",
            span(class = "metric-value", "WMO Region 6"),
            span(class = "metric-label", "Coverage Area")
          )
        ),
        div(
          class = "metric-card",
          div(class = "metric-icon", icon("satellite")),
          div(
            class = "metric-details",
            span(class = "metric-value", "LSA-SAF SEVIRI"),
            span(class = "metric-label", "Dataset")
          )
        ),
        div(
          class = "metric-card",
          div(class = "metric-icon", icon("calendar-check")),
          div(
            class = "metric-details",
            span(class = "metric-value", if (exists("dt.lst") && !is.null(dt.lst$date)) format(max(dt.lst$date), "%d %b %Y") else "Latest"),
            span(class = "metric-label", "Latest Update")
          )
        )
      )
    )
  )
)

ui <- function(req) { 
  fluidPage(
    theme = app_theme,
    tags$head(
      tags$meta(charset = "utf-8"),
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1, shrink-to-fit=no"),
      tags$meta(name = "description", content = "Urban Climate Explorer - Interactive monitoring of Surface Urban Heat Island (SUHI) dynamics and Land Surface Temperature (LST) across European cities using LSA-SAF SEVIRI satellite data."),
      tags$meta(name = "keywords", content = "Urban Heat Island, SUHI, LST, Land Surface Temperature, Climate Indicators, Remote Sensing, SEVIRI, WMO Region 6"),
      tags$meta(name = "author", content = "Urban Climate Research Team"),
      tags$title("Urban Climate Explorer | SUHI & LST Monitoring"),
      tags$link(rel = "preconnect", href = "https://fonts.googleapis.com"),
      tags$link(rel = "preconnect", href = "https://fonts.gstatic.com", crossorigin = "anonymous"),
      tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800&display=swap"),
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
      tags$script(HTML("
        $(document).ready(function() {
          function initTooltips() {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle=\"tooltip\"]'));
            tooltipTriggerList.map(function (tooltipTriggerEl) {
              return bootstrap.Tooltip.getOrCreateInstance(tooltipTriggerEl);
            });
          }
          initTooltips();
          $(document).on('shiny:value shiny:idle shiny:value-recalculating', function() {
            setTimeout(initTooltips, 200);
          });
        });
      "))
    ),
    useShinyjs(),
    navbarPage(
      title = div(class = "app-brand", "Urban Climate Explorer"),
      selected = "#about",
      header = hero_banner,
      collapsible = TRUE,
      fluid = TRUE,
      id = "tabs",
      position = "fixed-top",
      ui_graphs,
      ui_maps,
      ui_about
    )
  )
}
