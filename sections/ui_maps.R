
ui_maps <- tabPanel(
  "Maps",value = "#maps", id = "#maps",icon = icon("map"),
  tabsetPanel( 
    id = "tab_maps",
    tabPanel(
      id = "suhi_mapa",
      title = "SUHI & Cities LST",
      card(
        class = "mb-3",
        card_header("Cities coverage"),
        card_body(
          p("SUHI and LST coverage for all cities from the LST AS SEVIRI product."),
          span(class = "badge bg-secondary", paste("Updated", format(max(dt.lst$date), "%Y-%m-%d")))
        )
      ),
      layout_sidebar(
        fill = TRUE,
        gap = "1rem",
        sidebar = card(
          class = "sidebar-card",
          card_header("Display options"),
          card_body(
            selectInput(
              "parameter", "Prameter:", 
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
            downloadButton('downloadDataMap', 'Download', class = "w-100"),
            h6(textOutput("text_down_urb"), class = "text-muted mt-2")
          )
        ),
        card(
          card_header(textOutput("text_map")),
          card_body(
            leafletOutput("map", height = 500) %>% withSpinner(size = 0.5)
          )
        ),
        card(
          card_header(textOutput("city_time_series_title")),
          card_body(
            highchartOutput("plot_city") %>% withSpinner(size = 0.5)
          )
        )
      )
    ),
    tabPanel(
      value = "cont_maps",
      title = "LST",
      card(
        class = "mb-3",
        card_header("Continental coverage"),
        card_body(
          p("Spatial distribution of LST at continental scale."),
          span(class = "badge bg-secondary", paste("Updated", format(max(dats.lst.avg), "%Y-%m-%d")))
        )
      ),
      layout_sidebar(
        fill = TRUE,
        gap = "1rem",
        sidebar = card(
          class = "sidebar-card",
          card_header("Display options"),
          card_body(
            selectInput(
              "param_europe_daily", "Prameter:", 
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
              "radio", label = "Click on map behavior",
              choices = 
                list(
                  "Display current values on popup" = 1, 
                  "Plot timeseries (below map)" = 2
                ), 
              selected = 1
            ),
            conditionalPanel(
              condition = "input.radio == 2 && output.lst_rast && output.condpan != 'nas'",
              downloadButton('downloadLST', 'Download', class = "w-100")
            )
          )
        ),
        card(
          card_header(textOutput("text_map_europe")),
          card_body(
            leafletOutput("map.europe", height = 500) %>% withSpinner(size = 0.5)
          )
        ),
        conditionalPanel( # show graphs only when data available
          condition = "input.radio == 2 && output.condpan != 'nas'",
          card(
            card_header("Timeseries"),
            card_body(
              highchartOutput("lst_rast") %>% withSpinner(size = 0.5)
            )
          )
        ),
        conditionalPanel(
          condition = "input.radio == 2 && output.condpan == 'nas'",
          card(
            card_header("Timeseries"),
            card_body(
              p("You must click on an area with LST values available")
            )
          )
        )
      )
    ),
    tabPanel(
      value = "clim_ind",
      title = "Indicators",
      card(
        class = "mb-3",
        card_header("Continental coverage"),
        card_body(
          p("Climate indicators computed from daily minimum, maximum, and average LST."),
          span(class = "badge bg-secondary", paste("Updated", format(max(dt.lst$date), "%Y-%m-%d")))
        )
      ),
      layout_sidebar(
        fill = TRUE,
        gap = "1rem",
        sidebar = card(
          class = "sidebar-card",
          card_header("Display options"),
          card_body(
            selectInput(
              "parameter_europe_monthly", "Parameter:", 
              choices_map_europe_monthly, 
              selected = choices_map_europe_monthly[2]
            ),
            selectInput(
              'month_indicator',
              label = 'Month:',
              dats.lst.mx |> format("%Y %b"),
              selected = max(dats.lst.mx) |> format("%Y %b")
            ),
            radioButtons( # radio button show values
              "radio_mon", label = "Click on map behavior",
              choices = 
                list(
                  "Display current values on popup" = 1, 
                  "Plot timeseries (below map)" = 2
                ), 
              selected = 1
            ),
            conditionalPanel( # show download when data available
              condition = "input.radio_mon == 2 && output.lst_rast && output.condpan_monthly != 'nas'",
              downloadButton('downloadLST_mon', 'Download', class = "w-100")
            )
          )
        )
        ,
        card(
          card_header(textOutput("text_map_europe_monthly")),
          card_body(
            leafletOutput("map_europe_indicator", height = 500) %>% withSpinner(size = 0.5)
          )
        ),
        conditionalPanel( # show graphs only when data available
          condition = "input.radio_mon == 2 && output.condpan_monthly != 'nas'",
          card(
            card_header("Timeseries"),
            card_body(
              highchartOutput("lst_rast_mon") %>% withSpinner(size = 0.5)
            )
          )
        ),
        conditionalPanel(
          condition = "input.radio_mon == 2 && output.condpan_monthly == 'nas'",
          card(
            card_header("Timeseries"),
            card_body(
              p("You must click on an area with indicator values available")
            )
          )
        )
      )
    )
  )
)
