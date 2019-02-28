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
    filter(flights, price >= priceFilter[1] & price <= priceFilter[2])
  })
  
  # render Map
  output$europeMap <- renderLeaflet({
    map <- leaflet(data = map_points()) %>%
      addProviderTiles("Stamen.Toner") %>%
      #addProviderTiles("Stamen.Terrain") %>%
      #addProviderTiles("Esri.NatGeoWorldMap") %>%
      setView(lng = 3, lat = 42, zoom = 3.5) #%>%
      #addCircles(lng = ~ lng, lat= ~ lat, popup = ~ paste(as.character(price), '€'))
    map
  })
  
  observe({
    colorBy <- input$mapColor
    colorData <- flights[[colorBy]]
    sizeBy <- input$mapSize
    
    if (colorBy == "price") {
      # Continuous values.
      pal <- colorBin("viridis", colorData, 7, pretty = FALSE)
    } else {
      # Categorical values.
      pal <- colorFactor("viridis", colorData)
    }
    
    if (sizeBy == "price") {
      # Continuous
      radius <- flights[[sizeBy]] / max(flights[[sizeBy]]) * maxRadius
    } else {
      # Categorical
      radius <- ifelse(flights[[sizeBy]] == "True", maxRadius, minRadius)
    }
    
    leafletProxy("europeMap", data = flights) %>%
      #clearShapes() %>%
      addCircles(~lng, ~lat,
                 stroke=FALSE, fillOpacity=0.8, radius = radius,
                 fillColor=pal(colorData),
                 popup = ~ paste(paste0(as.character(price), '€'), airport)) %>%
      addLegend("topright", pal=pal, values=colorData, title=colorBy,
                layerId="colorLegend")
  })
  
  
  # Calculate statistics
  # todo
  
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

}