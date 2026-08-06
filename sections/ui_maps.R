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
            class = "d-flex justify-content-between align-items-center flex-wrap gap-2",
            span(class = "card-header-title", icon("city"), " Cities Coverage"),
            span(class = "stat-badge", icon("clock"), paste("Updated", format(max(dt.lst$date), "%Y-%m-%d")))
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
            "parameter", "Parameter:", 
            choices_map, 
            selected = choices_map[2]
          ),
          dateInput(
            'days_suhi',
            label = 'Day:',
            min = min(dt.lst$date) |> as.Date(),
            max = max(dt.lst$date) |> as.Date(),
            value = max(dt.lst$date) |> as.Date()
          ),
          downloadButton('downloadDataMap', 'Download Data', class = "btn-primary w-100"),
          h6(textOutput("text_down_urb"), class = "text-muted mt-2")
        ),
        layout_columns(
          col_widths = c(6, 6),
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
            class = "d-flex justify-content-between align-items-center flex-wrap gap-2",
            span(class = "card-header-title", icon("globe-europe"), " Continental Coverage"),
            span(class = "stat-badge", icon("clock"), paste("Updated", format(max(dats.lst.avg), "%Y-%m-%d")))
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
            "param_europe_daily", "Parameter:", 
            choices_map_europe_daily, 
            selected = choices_map_europe_daily[1]
          ),
          dateInput(
            'days_europe',
            label = 'Day:',
            min = min(dats.lst.avg),
            max = max(dats.lst.avg),
            value = max(dats.lst.avg)
          ),
          radioButtons(
            "radio", label = "On map click:",
            choices = 
              list(
                "Display current values on popup" = 1, 
                "Plot timeseries (below map)" = 2
              ), 
            selected = 2
          ),
          conditionalPanel(
            condition = "input.radio == 2 && output.lst_rast && output.condpan != 'nas'",
            downloadButton('downloadLST', 'Download Data', class = "btn-primary w-100")
          )
        ),
        layout_columns(
          col_widths = c(6, 6),
          card(
            full_screen = TRUE,
            class = "equal-height-card glass-card",
            card_header(div(class = "card-header-title", icon("map-marked-alt"), textOutput("text_map_europe", inline = TRUE))),
            card_body(
              leafletOutput("map.europe", height = "100%") %>% withSpinner(size = 0.5)
            )
          ),
          div(
            class = "h-100 d-flex flex-column",
            conditionalPanel(
              condition = "input.radio == 2 && output.condpan != 'nas'",
              style = "height: 100%; display: flex; flex-direction: column;",
              card(
                full_screen = TRUE,
                class = "equal-height-card glass-card",
                card_header(div(class = "card-header-title", icon("chart-area"), " Timeseries")),
                card_body(
                  highchartOutput("lst_rast", height = "100%") %>% withSpinner(size = 0.5)
                )
              )
            ),
            conditionalPanel(
              condition = "input.radio == 2 && output.condpan == 'nas'",
              style = "height: 100%; display: flex; flex-direction: column;",
              card(
                class = "equal-height-card glass-card",
                card_header(div(class = "card-header-title", icon("info-circle"), " Timeseries")),
                card_body(
                  class = "d-flex flex-column align-items-center justify-content-center text-center p-4",
                  div(
                    class = "py-4 text-center",
                    icon("hand-pointer", class = "fa-3x mb-3 text-muted"),
                    p(class = "text-muted fs-6 mb-0", "Click anywhere on the map to extract local LST time series.")
                  )
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
            class = "d-flex justify-content-between align-items-center flex-wrap gap-2",
            span(class = "card-header-title", icon("sliders-h"), " Continental Climate Indicators"),
            span(class = "stat-badge", icon("clock"), paste("Updated", format(max(dt.lst$date), "%Y-%m-%d")))
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
            "parameter_europe_monthly", "Parameter:", 
            choices_map_europe_monthly, 
            selected = choices_map_europe_monthly[2]
          ),
          selectInput(
            'month_indicator',
            label = 'Month:',
            unique(format(dats.lst.mx, "%Y %b")),
            selected = max(dats.lst.mx) |> format("%Y %b")
          ),
          radioButtons(
            "radio_mon", label = "On map click:",
            choices = 
              list(
                "Display current values on popup" = 1, 
                "Plot timeseries (below map)" = 2
              ), 
            selected = 2
          ),
          conditionalPanel(
            condition = "input.radio_mon == 2 && output.lst_rast && output.condpan_monthly != 'nas'",
            downloadButton('downloadLST_mon', 'Download Data', class = "btn-primary w-100")
          )
        ),
        layout_columns(
          col_widths = c(6, 6),
          card(
            full_screen = TRUE,
            class = "equal-height-card glass-card",
            card_header(div(class = "card-header-title", icon("map-marked-alt"), textOutput("text_map_europe_monthly", inline = TRUE))),
            card_body(
              leafletOutput("map_europe_indicator", height = "100%") %>% withSpinner(size = 0.5)
            )
          ),
          div(
            class = "h-100 d-flex flex-column",
            conditionalPanel(
              condition = "input.radio_mon == 2 && output.condpan_monthly != 'nas'",
              style = "height: 100%; display: flex; flex-direction: column;",
              card(
                full_screen = TRUE,
                class = "equal-height-card glass-card",
                card_header(div(class = "card-header-title", icon("chart-area"), " Timeseries")),
                card_body(
                  highchartOutput("lst_rast_mon", height = "100%") %>% withSpinner(size = 0.5)
                )
              )
            ),
            conditionalPanel(
              condition = "input.radio_mon == 2 && output.condpan_monthly == 'nas'",
              style = "height: 100%; display: flex; flex-direction: column;",
              card(
                class = "equal-height-card glass-card",
                card_header(div(class = "card-header-title", icon("info-circle"), " Timeseries")),
                card_body(
                  class = "d-flex flex-column align-items-center justify-content-center text-center p-4",
                  div(
                    class = "py-4 text-center",
                    icon("hand-pointer", class = "fa-3x mb-3 text-muted"),
                    p(class = "text-muted fs-6 mb-0", "Click anywhere on the map to extract local LST time series.")
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)
