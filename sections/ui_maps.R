ui_maps <- tabPanel(
  "Maps", value = "#maps", icon = icon("map-marked-alt"),
  tabsetPanel( 
    id = "tab_maps",
    tabPanel(
      value = "suhi_mapa",
      title = "SUHI & Cities LST",
      card(
        class = "mb-3 glass-card",
        card_header(
          div(
            class = "d-flex justify-content-between align-items-center flex-wrap gap-2 w-100",
            span(class = "card-header-title", icon("city", class = "me-2"), "Cities Coverage"),
            div(
              class = "d-flex align-items-center gap-2",
              span(class = "stat-badge", icon("clock"), paste("Updated", format(max(dt.lst$date), "%Y-%m-%d"))),
              span(
                class = "info-tooltip-icon text-info", 
                `data-bs-toggle` = "tooltip", 
                `data-bs-placement` = "left", 
                title = "Surface Urban Heat Island (SUHI) and Land Surface Temperature (LST) coverage for all monitored cities from the LST AS SEVIRI product.", 
                icon("info-circle")
              )
            )
          )
        ),
        card_body(
          p(class = "card-text-lead", "Surface Urban Heat Island (SUHI) and Land Surface Temperature (LST) coverage for all monitored cities from the LST AS SEVIRI product.")
        )
      ),
      layout_sidebar(
        fill = TRUE,
        gap = "1rem",
        sidebar = sidebar(
          title = "Display options",
          open = list(desktop = "open", mobile = "closed"),
          selectInput(
            "parameter", 
            label = tagList(
              "Parameter:",
              span(
                class = "text-muted ms-1 info-tooltip-icon",
                `data-bs-toggle` = "tooltip",
                `data-bs-placement` = "top",
                title = "Choose between SUHI intensity (°C) or raw Land Surface Temperature (LST).",
                icon("info-circle")
              )
            ), 
            choices_map, 
            selected = choices_map[2]
          ),
          dateInput(
            'days_suhi',
            label = tagList(
              "Day:",
              span(
                class = "text-muted ms-1 info-tooltip-icon",
                `data-bs-toggle` = "tooltip",
                `data-bs-placement` = "top",
                title = "Select date to display spatial temperature distribution across European cities.",
                icon("info-circle")
              )
            ),
            min = min(dt.lst$date) |> as.Date(),
            max = max(dt.lst$date) |> as.Date(),
            value = max(dt.lst$date) |> as.Date()
          ),
          div(
            `data-bs-toggle` = "tooltip",
            `data-bs-placement` = "top",
            title = "Download spatial city heat metrics for the selected date.",
            downloadButton('downloadDataMap', 'Download Data', class = "btn-primary w-100")
          ),
          h6(textOutput("text_down_urb"), class = "text-muted mt-2")
        ),
        layout_columns(
          col_widths = c(6, 6),
          gap = "1rem",
          card(
            full_screen = TRUE,
            class = "equal-height-card glass-card",
            card_header(div(class = "card-header-title", icon("map-marked-alt"), textOutput("text_map", inline = TRUE))),
            card_body(
              leafletOutput("map", height = "100%") %>% withSpinner(size = 0.5)
            )
          ),
          card(
            full_screen = TRUE,
            class = "equal-height-card glass-card",
            card_header(div(class = "card-header-title", icon("chart-line"), textOutput("city_time_series_title", inline = TRUE))),
            card_body(
              highchartOutput("plot_city", height = "100%") %>% withSpinner(size = 0.5)
            )
          )
        )
      )
    ),
    tabPanel(
      value = "cont_maps",
      title = "LST",
      card(
        class = "mb-3 glass-card",
        card_header(
          div(
            class = "d-flex justify-content-between align-items-center flex-wrap gap-2 w-100",
            span(class = "card-header-title", icon("globe-europe", class = "me-2"), "Continental Coverage"),
            div(
              class = "d-flex align-items-center gap-2",
              span(class = "stat-badge", icon("clock"), paste("Updated", format(max(dats.lst.avg), "%Y-%m-%d"))),
              span(
                class = "info-tooltip-icon text-info", 
                `data-bs-toggle` = "tooltip", 
                `data-bs-placement` = "left", 
                title = "Spatial distribution of Land Surface Temperature (LST) at continental scale across WMO Region 6.", 
                icon("info-circle")
              )
            )
          )
        ),
        card_body(
          p(class = "card-text-lead", "Spatial distribution of Land Surface Temperature (LST) at continental scale across WMO Region 6.")
        )
      ),
      layout_sidebar(
        fill = TRUE,
        gap = "1rem",
        sidebar = sidebar(
          title = "Display options",
          open = list(desktop = "open", mobile = "closed"),
          selectInput(
            "param_europe_daily", 
            label = tagList(
              "Parameter:",
              span(
                class = "text-muted ms-1 info-tooltip-icon",
                `data-bs-toggle` = "tooltip",
                `data-bs-placement` = "top",
                title = "Choose daily LST statistic: Day, Night, Average, Minimum, Maximum, or Diurnal Temperature Range (DTR).",
                icon("info-circle")
              )
            ), 
            choices_map_europe_daily, 
            selected = choices_map_europe_daily[1]
          ),
          dateInput(
            'days_europe',
            label = tagList(
              "Day:",
              span(
                class = "text-muted ms-1 info-tooltip-icon",
                `data-bs-toggle` = "tooltip",
                `data-bs-placement` = "top",
                title = "Select date for continental WMO Region 6 spatial map.",
                icon("info-circle")
              )
            ),
            min = min(dats.lst.avg),
            max = max(dats.lst.avg),
            value = max(dats.lst.avg)
          ),
          radioButtons(
            "radio", 
            label = tagList(
              "On map click:",
              span(
                class = "text-muted ms-1 info-tooltip-icon",
                `data-bs-toggle` = "tooltip",
                `data-bs-placement` = "top",
                title = "Choose interaction mode when clicking on the map: show instant popup value or generate point time series graph.",
                icon("info-circle")
              )
            ),
            choices = 
              list(
                "Display current values on popup" = 1, 
                "Plot timeseries (below map)" = 2
              ), 
            selected = 2
          ),
          conditionalPanel(
            condition = "input.radio == 2 && output.condpan != 'nas'",
            div(
              `data-bs-toggle` = "tooltip",
              `data-bs-placement` = "top",
              title = "Export extracted raster time series for the clicked coordinate.",
              downloadButton('downloadLST', 'Download Data', class = "btn-primary w-100")
            )
          )
        ),
        layout_columns(
          col_widths = c(6, 6),
          gap = "1rem",
          card(
            full_screen = TRUE,
            class = "equal-height-card glass-card",
            card_header(div(class = "card-header-title", icon("map-marked-alt"), textOutput("text_map_europe", inline = TRUE))),
            card_body(
              leafletOutput("map.europe", height = "100%") %>% withSpinner(size = 0.5)
            )
          ),
          card(
            full_screen = TRUE,
            class = "equal-height-card glass-card",
            card_header(div(class = "card-header-title", icon("chart-area"), " Timeseries")),
            card_body(
              class = "d-flex flex-column h-100",
              conditionalPanel(
                condition = "input.radio == 2 && output.condpan != 'nas'",
                style = "height: 100%; display: flex; flex-direction: column;",
                highchartOutput("lst_rast", height = "100%") %>% withSpinner(size = 0.5)
              ),
              conditionalPanel(
                condition = "input.radio == 2 && output.condpan == 'nas'",
                style = "height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center;",
                div(
                  class = "py-4 text-center text-muted",
                  role = "status",
                  "aria-live" = "polite",
                  icon("hand-pointer", class = "fa-3x mb-3 text-primary opacity-75"),
                  p(class = "fs-6 mb-0 text-dark fw-medium", "Click anywhere on the map to extract local LST time series.")
                )
              ),
              conditionalPanel(
                condition = "input.radio == 1",
                style = "height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center;",
                div(
                  class = "py-4 text-center text-muted",
                  role = "status",
                  "aria-live" = "polite",
                  icon("info-circle", class = "fa-3x mb-3 text-primary opacity-75"),
                  p(class = "fs-6 mb-0 text-dark fw-medium", "Popup mode active. Click any location on the map to view values in a popup window.")
                )
              )
            )
          )
        )
      )
    ),
    tabPanel(
      value = "clim_ind",
      title = "Indicators",
      card(
        class = "mb-3 glass-card",
        card_header(
          div(
            class = "d-flex justify-content-between align-items-center flex-wrap gap-2 w-100",
            span(class = "card-header-title", icon("sliders-h", class = "me-2"), "Continental Climate Indicators"),
            div(
              class = "d-flex align-items-center gap-2",
              span(class = "stat-badge", icon("clock"), paste("Updated", format(max(dt.lst$date), "%Y-%m-%d"))),
              span(
                class = "info-tooltip-icon text-info", 
                `data-bs-toggle` = "tooltip", 
                `data-bs-placement` = "left", 
                title = "Climate indicators computed from daily minimum, maximum, and average Land Surface Temperature.", 
                icon("info-circle")
              )
            )
          )
        ),
        card_body(
          p(class = "card-text-lead", "Climate indicators computed from daily minimum, maximum, and average Land Surface Temperature.")
        )
      ),
      layout_sidebar(
        fill = TRUE,
        gap = "1rem",
        sidebar = sidebar(
          title = "Display options",
          open = list(desktop = "open", mobile = "closed"),
          selectInput(
            "parameter_europe_monthly", 
            label = tagList(
              "Parameter:",
              span(
                class = "text-muted ms-1 info-tooltip-icon",
                `data-bs-toggle` = "tooltip",
                `data-bs-placement` = "top",
                title = "Monthly composite climate indicators derived from daily SEVIRI satellite observations.",
                icon("info-circle")
              )
            ), 
            choices_map_europe_monthly, 
            selected = choices_map_europe_monthly[2]
          ),
          selectInput(
            'month_indicator',
            label = tagList(
              "Month:",
              span(
                class = "text-muted ms-1 info-tooltip-icon",
                `data-bs-toggle` = "tooltip",
                `data-bs-placement` = "top",
                title = "Select target month and year for climate index visualization.",
                icon("info-circle")
              )
            ),
            unique(format(dats.lst.mx, "%Y %b")),
            selected = max(dats.lst.mx) |> format("%Y %b")
          ),
          radioButtons(
            "radio_mon", 
            label = tagList(
              "On map click:",
              span(
                class = "text-muted ms-1 info-tooltip-icon",
                `data-bs-toggle` = "tooltip",
                `data-bs-placement` = "top",
                title = "Choose interaction mode for monthly climate indicator maps.",
                icon("info-circle")
              )
            ),
            choices = 
              list(
                "Display current values on popup" = 1, 
                "Plot timeseries (below map)" = 2
              ), 
            selected = 2
          ),
          conditionalPanel(
            condition = "input.radio_mon == 2 && output.condpan_monthly != 'nas'",
            div(
              `data-bs-toggle` = "tooltip",
              `data-bs-placement` = "top",
              title = "Download monthly indicator time series for clicked coordinate.",
              downloadButton('downloadLST_mon', 'Download Data', class = "btn-primary w-100")
            )
          )
        ),
        layout_columns(
          col_widths = c(6, 6),
          gap = "1rem",
          card(
            full_screen = TRUE,
            class = "equal-height-card glass-card",
            card_header(div(class = "card-header-title", icon("map-marked-alt"), textOutput("text_map_europe_monthly", inline = TRUE))),
            card_body(
              leafletOutput("map_europe_indicator", height = "100%") %>% withSpinner(size = 0.5)
            )
          ),
          card(
            full_screen = TRUE,
            class = "equal-height-card glass-card",
            card_header(div(class = "card-header-title", icon("chart-area"), " Timeseries")),
            card_body(
              class = "d-flex flex-column h-100",
              conditionalPanel(
                condition = "input.radio_mon == 2 && output.condpan_monthly != 'nas'",
                style = "height: 100%; display: flex; flex-direction: column;",
                highchartOutput("lst_rast_mon", height = "100%") %>% withSpinner(size = 0.5)
              ),
              conditionalPanel(
                condition = "input.radio_mon == 2 && output.condpan_monthly == 'nas'",
                style = "height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center;",
                div(
                  class = "py-4 text-center text-muted",
                  role = "status",
                  "aria-live" = "polite",
                  icon("hand-pointer", class = "fa-3x mb-3 text-primary opacity-75"),
                  p(class = "fs-6 mb-0 text-dark fw-medium", "Click anywhere on the map to extract local LST time series.")
                )
              ),
              conditionalPanel(
                condition = "input.radio_mon == 1",
                style = "height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center;",
                div(
                  class = "py-4 text-center text-muted",
                  role = "status",
                  "aria-live" = "polite",
                  icon("info-circle", class = "fa-3x mb-3 text-primary opacity-75"),
                  p(class = "fs-6 mb-0 text-dark fw-medium", "Popup mode active. Click any location on the map to view values in a popup window.")
                )
              )
            )
          )
        )
      )
    )
  )
)
