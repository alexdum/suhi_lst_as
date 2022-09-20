
ui_maps <- tabPanel(
  "Maps",value = "#maps", id = "#maps",icon = icon("map"),
  #tags$br(""),
  tabsetPanel( 
    id = "tab_maps",
    tabPanel(
      value = "suhi_maps",
      title = "SUHI & Cities LST",
      tags$h6(" "),
      tags$h5(paste("Cities for which Surface Urban Heat Island (SUHI) and Land Surface Temperature (LST) 
              has been calculated from LST AS SEVIRI product (last processed date",  max(dt.lst$date),").")),
      #tags$h6(" "),
      tags$br(""),
      fluidRow(
        column(
          width = 3,
          wellPanel(
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
            downloadButton('downloadDataMap', 'Download'),
            h6(textOutput("text_down_urb"))
          )
        )
        ,
        column(
          width = 9,
          wellPanel(
            textOutput("text_map")
          ),
          wellPanel(
            leafletOutput("map", height = 500) %>% withSpinner(size = 0.5)
          )
        )
      )
    ),
    tabPanel(
      value = "cont_maps",
      title = "LST",
      tags$h6(" "),
      tags$h5(paste0("Spatial distribution of LST data at continental scale (last processed date", max(dt.lst$date),").")),
      #tags$h6(" "),
      tags$br(""),
      fluidRow(
        column(
          width = 3,
          wellPanel(
            selectInput(
              "param_europe", "Prameter:", 
              choices_map_europe, 
              selected = choices_map_europe[1]
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
              downloadButton('downloadLST', 'Download')
            )
          )
        ),
        column(
          width = 9,
          wellPanel(
            textOutput("text_map_europe")
          ),
          wellPanel(
            leafletOutput("map.europe", height = 500) %>% withSpinner(size = 0.5)
          ),
          # show graphs only when data available
          conditionalPanel(
            condition = "input.radio == 2 && output.condpan != 'nas'",
            wellPanel(
              highchartOutput("lst_rast") %>% withSpinner(size = 0.5)
            )
          ),
          conditionalPanel(
            condition = "input.radio == 2 && output.condpan == 'nas'",
            wellPanel(
              p("You must click on an area with LST values available")
            )
          )
        )
      )
    ),
    tabPanel(
      value = "clim_ind",
      title = "Indicators",
      tags$h6(" "),
      tags$h5("TBA"),
    )
  )
)





