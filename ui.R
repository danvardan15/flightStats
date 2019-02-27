ui <- fluidPage(
  
  navbarPage("STATS_change", id="shinyApp",
   # Sidebar layout with a input and output definitions
   tabPanel("Flight data",
     
      # Inputs(s)
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                    draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                    width = 400, height = "auto",
        #Select variable for y-axis
        selectInput(inputId = "y", 
                    label = "Y-axis:",
                    choices = flightFeatures, 
                    selected = "Scheduled departure"),
        
        # Select variable for x-axis
        selectInput(inputId = "x", 
                    label = "X-axis:",
                    choices = flightFeatures,
                    selected = "actual_duration"),
        
        # Select variable for color
        selectInput(inputId = "z", 
                    label = "Color by:",
                    choices = flightTypes,
                    selected = "airline"),
        
        # Select which airlines to plot
        checkboxGroupInput(inputId = "selected_type",
                   label = "Select airline(s):",
                   choices = airlineChoices,
                   selected = c("U2", "FR", "EW")),
        
        dataTableOutput(outputId = "flightstable")
                    
      ),
    
    # Output(s)
    mainPanel(
      HTML(paste("<h2>Stats comparison:</h2>")),
      htmlOutput(outputId = "corrcoef"),
      plotOutput(outputId = "scatterplot", brush = "plot_brush"),
      br(),
      plotOutput(outputId = "densityplot")
    )
   ),
   tabPanel("Map",
     leafletOutput("europeMap",height = 1000)
   )
  )
)