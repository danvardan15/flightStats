library(shiny)
library(leaflet)
library(dplyr)
library(ggplot2)
library(tools)
library(DT)

flights <- read.csv("/home/danielv/Documents/bccn/R_tut/flight_app/sample.csv",
                    header = TRUE, stringsAsFactors = FALSE)

#dates from number to string
flights$month_of_purchase <- month.abb[flights$month_of_purchase]
flights$month_of_flight <- month.abb[flights$month_of_flight]
flights$year_of_purchase <- as.character(flights$year_of_purchase)
flights$year_of_flight <- as.character(flights$year_of_flight)

# store as factor to preserve chronological order
flights$month_of_purchase = factor(flights$month_of_purchase, levels = month.abb)
flights$month_of_flight = factor(flights$month_of_flight, levels = month.abb)

# variables
flightFeatures <- c("month of flight" = "month_of_flight", 
                    "month of purchase" = "month_of_purchase",
                    "months in advance" = "months_in_advance",
                    "duration [min]" = "duration", 
                    "distance [km]" = "dist",
                    "price [€]" = "price")

flightTypes <- c("country" = "countryCode", "airline" = "airline", 
                 "on sale" = "sale", "year of flight" = "year_of_flight")

airlines <- unique(flights$airline)

table_vars  <- c('airport', 'airline', 'price', 'month_of_flight', 'year_of_flight')
table_names <- c('Airport', 'Airline', 'Price €', 'Month of flight', 'Year of flight')

