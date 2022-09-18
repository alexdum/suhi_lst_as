
ui_maps <- tabPanel(
  "Maps",value = "#maps", id = "#maps",icon = icon("map"),
  #tags$br(""),
  tabsetPanel( 
    id = "tab_maps",
    tabPanel(
      value = "suhi_maps",
      title = "SUHI & LST",
      tags$h6(" "),
      tags$h5("Cities for which Surface Urban Heat Island (SUHI) and Land Surface Temperature (LST) has been calculated from LST AS SEVIRI product"),
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
            leafletOutput("map")
          )
        )
      )
    ),
    tabPanel(
      value = "cont_maps",
      title = "LST",
      tags$h6(" "),
      tags$h5("Spatial distribution of LST data at continental scale"),
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
                  "Plot timeseries" = 2
                ), 
              selected = 1
              #   downloadButton('downloadDataMap', 'Download'),
            )
            #   downloadButton('downloadDataMap', 'Download'),
          )
        ),
        column(
          width = 9,
          wellPanel(
            textOutput("text_map_europe")
          ),
          wellPanel(
            leafletOutput("map.europe")
          ),
          # show graphs only when data available
          conditionalPanel(
            condition = "input.radio == 2 && output.condpan != 'nas'",
            wellPanel(
              highchartOutput("lst_rast")
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
    )
  )
)





