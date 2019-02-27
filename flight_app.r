library(shiny)
library(ggplot2)
library(dplyr)
library(tools)
library(chron)

flights <- read.csv("/home/danielv/Documents/bccn/R_tut/DATA/flights_creation.csv",
                 header = TRUE, stringsAsFactors = FALSE)

#add column with hours
flights$departure_hour = format(strptime(flights$scheduled_departure,
                                         '%Y-%m-%d %T'), '%H')

# Define UI for application that plots features of flights
ui <- fluidPage(
  
  # Application title
  titlePanel("Flight stats browser"),
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs(s)
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("Scheduled departure hour" = "departure_hour", 
                              "Departure delay" = "departure_delay",
                              "Arrival delay" = "arrival_delay",
                              "Estimated duration" = "estimated_duration", 
                              "Actual duration" = "actual_duration"), 
                  selected = "Scheduled departure"),
      
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("Scheduled departure hour" = "departure_hour", 
                              "Departure delay" = "departure_delay", 
                              "Arrival delay" = "arrival_delay",
                              "Estimated duration" = "estimated_duration", 
                              "Actual duration" = "actual_duration"),
                  selected = "actual_duration"),
      
      # Select variable for color
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("Country" = "country", 
                              "Airline" = "airline", 
                              "Airport" = "airport", 
                              "Estimated duration" = "estimated_duration"),
                  selected = "country"),
      
      # Select which airlines to plot
      checkboxGroupInput(inputId = "selected_type",
                         label = "Select airline(s):",
                         choices = c("EasyJet" = "U2",
                                     "Lufthansa" = "LH",
                                     "Eurowings" = "EW",
                                     "Ryanair" = "FR"),
                         selected = c("U2", "FR", "EW"))
      
    ),
    
    # Output(s)
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )

)

# Server
server <- function(input, output) {
  
  # Create a subset of data filtering for selected title types
  flights_subset <- reactive({
    req(input$selected_type)
    filter(flights, airline %in% input$selected_type)
  })
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = flights_subset(), 
           aes_string(x = input$x, y = input$y, color = input$z,
                      size = "arrival_delay")) +
      geom_point()
  })
  
  
  
}


# Create the Shiny app object
shinyApp(ui = ui, server = server)