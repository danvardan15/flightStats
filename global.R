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
flights$date_of_flight <- paste(flights$month_of_flight, flights$year_of_flight)

# store as factor to preserve chronological order
flights$month_of_purchase = factor(flights$month_of_purchase, levels = month.abb)
flights$month_of_flight = factor(flights$month_of_flight, levels = month.abb)

#round price
flights$price = round(flights$price, 2)

# variables
flightFeatures <- c("month of flight" = "month_of_flight", 
                    "month of purchase" = "month_of_purchase",
                    "months in advance" = "months_in_advance",
                    "duration [min]" = "duration", 
                    "distance [km]" = "dist",
                    "price [€]" = "price")

flightTypes <- c("country" = "countryCode", "airline" = "airline", 
                 "on sale" = "sale", "year of flight" = "year_of_flight")

table_vars  <- c("airport", "airline", "price", "date_of_flight")
table_names <- c("Airport", "Airline", "Price €", "Date of flight")


mapColor_vars <- c("months in advance" = "months_in_advance", "price" = "price",
                   "airline" = "airline", "country" = "countryCode")

features_to_filter <- c("airline", "year of flight" = "year_of_flight")

airlines <- unique(flights$airline)
yearsFlight <- unique(flights$year_of_flight)

# Constant
maxRadius <-  50000

# Useful functions

# mode of numerical or categorical
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# function to get month character from number
getmonth <- function(n) {
  month.abb[n]
}