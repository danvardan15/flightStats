server <- function(input,output, session){
  
  # Reactive components
  
  # Subset of data filtered by airline
  flights_subset <- reactive({
      req(input$selected_airline)
      req(input$selected_year)
      flights1 <- filter(flights, airline %in% input$selected_airline)
      filter(flights1, year_of_flight %in% input$selected_year)  
  })
  
  # Subset of data filtered by airline
  map_points <- reactive({
    priceFilter <- input$priceFilter
    req(priceFilter)
    filter(flights, price >= priceFilter[1] & price <= priceFilter[2])
  })
  
  # event for clicking the map
  flightAirport <- eventReactive(
    eventExpr = input$europeMap_marker_click, 
    valueExpr = {
      loc <- input$europeMap_marker_click
      flights_to_airport <- map_points()[cmpfloat(map_points()$lat, loc$lat),]
      flights_to_airport <- flights_to_airport[cmpfloat(flights_to_airport$lng, loc$lng),]
      flights_to_airport
    })
  
  # render Map
  output$europeMap <- renderLeaflet({
    map <- leaflet() %>%
      addProviderTiles("Stamen.Toner") %>%
      setView(lng = lng_init, lat = lat_init, zoom = zoom_init)
    map
  })
  
  # Handle circles on top of the map
  observe({
    colorBy <- input$mapColor
    colorData <- map_points()[[colorBy]]
    radius <- map_points()[["price"]] / max(map_points()[["price"]]) * maxRadius
    
    if (colorBy == "price") {
      # Continuous values.
      pal <- colorBin("viridis", colorData, 7, pretty = FALSE)
    } else {
      # Categorical values.
      pal <- colorFactor("viridis", colorData)
    }
    
    leafletProxy("europeMap", data = map_points()) %>%
      addCircleMarkers(~lng, ~lat,
                 fillOpacity=1, radius = radius,
                 fillColor=pal(colorData), stroke=FALSE,
                 popup = ~ paste(paste0(as.character(price), '€'), airport)) %>%
      addLegend("topright", pal=pal, values=colorData, title=colorBy,
                layerId="colorLegend")
  })
  
  # Create data table of flights to the selected airport
  output$airporttable <- DT::renderDataTable({
    flights_sample <- flightAirport() %>%
      select(tableMap_vars)
    DT::datatable(data = flights_sample,
                  colnames = tableMap_names,
                  width = 200)
  })
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = flights_subset(), 
           aes_string(x = input$x, y = input$y, color = input$z, size='price')) +
      geom_point()
  })
  
  # Create data table
  output$flightstable <- DT::renderDataTable({
    flights_sample <- brushedPoints(flights_subset(), brush = input$plot_brush) %>%
    select(table_vars)
    DT::datatable(data = flights_sample,
                  colnames = table_names)
  })
  
  # Calculate statistics
  output$statsFlights <- renderText({
    x_data <- flights_subset() %>% pull(input$x)
    if(is.numeric(x_data)) {
      # stats for numerical data
      avg_x <-  x_data %>% mean() %>% round(2)
      std_x <- x_data  %>% std() %>% round(2)
      stat_vals <- c("Mean:", avg_x, "Standard deviation:", std_x)
    }else{
      # stats for non numerical data (Months in this case)
      mod_x <- x_data  %>% getmode() %>% getmonth()
      n_x <-  x_data %>% length()
      stat_vals <- c("Mode:", mod_x, "Number of data points:", n_x)
    }
    string <-  paste("Statistics of", input$x, "\n",
                     stat_vals[1], stat_vals[2], "\n", stat_vals[3], stat_vals[4])
    string
  })
  

}