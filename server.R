server <- function(input,output, session){
  
  # Reactive components
  
  # Subset of data filtered by airline
  flights_subset <- reactive({
      req(input$selected_type)
      filter(flights, airline %in% input$selected_type)
  })
  
  # Calculate statistics
  output$corrcoef <- renderUI({
    r <- round(cor(flights_subset()[, input$x],
                   as.double(flights_subset()[, input$y]), use = "pairwise"), 3
               )
    HTML(
        paste(input$x, "v. ", input$y),
        "\t",
        paste("<br>Correlation coefficient: ", input$y, "=", r),
        paste("<h6> Valid for linear dependencies </h6>")
        )
  })
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = flights_subset(), 
           aes_string(x = input$x, y = input$y, color = input$z,
                      size = "arrival_delay")) +
      geom_point()
  })
  
  # Create  density object the plotOutput function is expecting
  output$densityplot <- renderPlot({
    ggplot(data = flights_subset(), 
           aes_string(x = input$x)) +
      geom_bar()
  })
  
  # Create data table
  output$flightstable <- DT::renderDataTable({
    flights_sample <- brushedPoints(flights_subset(), brush = input$plot_brush) %>%
    select(c('flight_id', 'airline', 'airport'))
    DT::datatable(data = flights_sample,
                  rownames = FALSE)
  })
  
  # render Map
  output$europeMap <- renderLeaflet({
    map <- leaflet() %>%
      addTiles() %>%
      setView(lng = 5, lat = 42 , zoom = 5)
    map
  })  
  

}