
source("sections/ui_graphs.R", local = T)
source("sections/ui_maps.R", local = T)
source("sections/ui_about.R", local = T)

app_theme <- bs_theme(
  version = 5,
  bootswatch = "spacelab",
  primary = "#1f7a8c",
  secondary = "#f18f01",
  "body-bg" = "#f6f8fb",
  "app-brand-font-weight" = "700",
  "app-brand-letter-spacing" = "0.5px"
)

ui <- function(req) { 
  fluidPage(
    theme = app_theme,
    tags$head(
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
      tags$style(
        type = "text/css",
        "
        body { padding-top: 72px; }
        .app-brand { font-weight: var(--app-brand-font-weight); letter-spacing: var(--app-brand-letter-spacing); }
        .navbar, .navbar .container-fluid { align-items: center; min-height: 62px; }
        .navbar-brand { display: flex; align-items: center; padding: 12px 14px; margin-right: 1rem; }
        .navbar-nav > li > a, .navbar-nav .nav-link { padding: 12px 14px; display: flex; align-items: center; height: 100%; }
        .bslib-card { box-shadow: 0 6px 24px rgba(9, 30, 66, 0.08); border: none; }
        .sidebar-card .btn { width: 100%; }
        #city + .selectize-control .selectize-input { min-height: 48px; padding: 10px 12px; }
        #city + .selectize-control .selectize-dropdown-content { max-height: 70vh !important; overflow-y: auto; }
        .selectize-dropdown { z-index: 2000; }
        .section-lead { padding: 12px 0 16px 0; }
        "
      )
    ),
    useShinyjs(),
    navbarPage(
      title = div(class = "app-brand", "Urban Clim explorer"),
      selected = "#about",
      collapsible = TRUE,
      fluid = TRUE,
      id = "tabs",
      position =  "fixed-top",
      ui_graphs,
      ui_maps,
      ui_about
    )
  )
}
