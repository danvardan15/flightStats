server <- function(input,output, session){
  
  # Reactive components
  
  # Subset of data filtered by airline
  flights_subset <- reactive({
      req(input$selected_type)
      filter(flights, airline %in% input$selected_type)
  })
  
  # Subset of data filtered by airline
  map_points <- reactive({
    priceFilter <- input$priceFilter
    req(priceFilter)
    filter(flights, price %in% (priceFilter[1]:priceFilter[2]))
  })
  
  # render Map
  output$europeMap <- renderLeaflet({
    map <- leaflet(data = map_points()) %>%
      #addProviderTiles("Esri.WorldImagery") %>%
      addProviderTiles("Stamen.Toner") %>%
      setView(lng = 3, lat = 42, zoom = 3.5) %>%
      addCircles(lng = ~ lng, lat= ~ lat, popup = ~ paste(as.character(price), '€'))
    map
  })
  
  # Calculate statistics
  # todo
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = flights_subset(), 
           aes_string(x = input$x, y = input$y, color = input$z,
                      size = "price")) +
      geom_point()
  })
  
  # Create data table
  output$flightstable <- DT::renderDataTable({
    flights_sample <- brushedPoints(flights_subset(), brush = input$plot_brush) %>%
    select(table_vars)
    DT::datatable(data = flights_sample,
                  colnames = table_names)
  })

}