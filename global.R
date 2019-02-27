library(shiny)
library(leaflet)
library(dplyr)
library(ggplot2)
library(tools)
library(DT)

flights <- read.csv("/home/danielv/Documents/bccn/R_tut/DATA/flights_creation.csv",
                    header = TRUE, stringsAsFactors = FALSE)

#add column with hours
flights$departure_hour = format(strptime(flights$scheduled_departure,
                                         '%Y-%m-%d %T'), '%H')

# variables
airlineChoices <- c("EasyJet" = "U2", "Lufthansa" = "LH",
                    "Eurowings" = "EW", "Ryanair" = "FR")

flightFeatures <- c("Scheduled departure hour" = "departure_hour", 
                    "Departure delay" = "departure_delay",
                    "Arrival delay" = "arrival_delay",
                    "Estimated duration" = "estimated_duration", 
                    "Actual duration" = "actual_duration")

flightTypes <- c("Country" = "country", "Airline" = "airline", 
                 "Airport" = "airport", "Estimated duration" = "estimated_duration")


