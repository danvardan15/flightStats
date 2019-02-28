library(shiny)
library(leaflet)
library(dplyr)
library(ggplot2)
library(tools)
library(DT)

flights <- read.csv("/home/danielv/Documents/bccn/R_tut/flight_app/sample.csv",
                    header = TRUE, stringsAsFactors = FALSE)

#month from number to string
flights$month_of_purchase <- month.abb[c(flights$month_of_purchase)]
flights$month_of_travel <- month.abb[c(flights$month_of_travel)]

flights$month_of_purchase = factor(flights$month_of_purchase, levels = month.abb)
flights$month_of_travel = factor(flights$month_of_travel, levels = month.abb)

# variables
flightFeatures <- c("month of travel" = "month_of_travel", 
                    "month of purchase" = "month_of_purchase",
                    "months in advance" = "months_in_advance",
                    "duration [min]" = "duration", 
                    "distance [km]" = "dist",
                    "price [€]" = "price")

flightTypes <- c("country" = "countryCode", "airline" = "airline", 
                 "on sale" = "sale", "year of travel" = "year_of_travel")

airlines <- unique(flights$airline)

table_vars <- c('airport', 'airline', 'price', 'month_of_travel', 'year_of_travel')

