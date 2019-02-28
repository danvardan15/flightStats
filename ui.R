ui <- fluidPage(
  
  title = 'Flight prices',
  navbarPage("Departures from Berlin TXL", id="shinyApp",
   # tabPanel for the map
   tabPanel("Map",
            leafletOutput("europeMap",height = 1000),
            
            # Inputs(s)
            absolutePanel(id = "mapControl", class = "panel panel-default",
                          draggable = TRUE,  top=170, left = 30, right = "auto", bottom = "auto",
                          width = 330, height = "auto",
                          
                          # Slider Input to filter out price
                          sliderInput(inputId = "priceFilter",
                                      label = "price range",
                                      min = 0, max = max(flights$price),
                                      value = c(min(flights$price), 100)
                          ),
                          # Select variable for color
                          selectInput(inputId = "mapColor", 
                                      label = "Color by:",
                                      choices = mapColor_vars,
                                      selected = "airline"),
                          
                          # Select variable for size
                          selectInput(inputId = "mapSize", 
                                      label = "Size by:",
                                      choices = mapSize_vars,
                                      selected = "price")
                          
            )
   ),
   # tabPanel for data visualization and statistics
   tabPanel("Flights data",
     
      # Inputs(s)
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                    draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                    width = 400, height = "auto",
        #Select variable for y-axis
        selectInput(inputId = "y", 
                    label = "Y-axis:",
                    choices = flightFeatures, 
                    selected = "price"),
        
        # Select variable for x-axis
        selectInput(inputId = "x", 
                    label = "X-axis:",
                    choices = flightFeatures,
                    selected = "months in advance"),
        
        # Select variable for color
        selectInput(inputId = "z", 
                    label = "Color by:",
                    choices = flightTypes,
                    selected = "airline"),
        
        # Select which airlines to plot
        checkboxGroupInput(inputId = "selected_type",
                   label = "Select airline(s):",
                   choices = airlines,
                   selected = airlines)
      ),
    
    # Output(s)
    mainPanel(
      h2("Departures from TXL"),
      plotOutput(outputId = "scatterplot", brush = "plot_brush"),
      
      h3("Select data points to get information"), br(),
      dataTableOutput(outputId = "flightstable")
    )
   )
  )
)