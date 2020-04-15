#these libraries need to be loaded
library(utils)
library(httr)  # GET
library(dplyr) # arrange

##########
# Reads and normalizes data from the European Centre for Disease Prevention and Control
# Both cases and deaths are the new numbers reported for that day, not a running sum.

# Input File format:
# Columns [dateRep, day, month, year, cases, deaths, countriesAndTerritories, geoId, country, popData2018]
#
# 
##########
ReadWorldData <- function() {
    GET("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv", authenticate(":", ":", type="ntlm"), write_disk(tf <- tempfile(fileext = ".csv")))

    #read the Dataset sheet into “R”. The dataset will be called "data".
    data <- read.csv(tf)

    #format the date into a format R can actually parse
    data$dateRep <- paste(data$day, "/", data$month, "/", data$year, sep="")
    data$dateRep <- as.Date(data[["dateRep"]], format = "%d/%m/%Y")

    #fix date ordering
    data <- arrange(data, geoId, dateRep)

    data$casesSum <- ave(data$cases, data$geoId, FUN = function(x) cumsum(x))
    data$deathsSum <- ave(data$deaths, data$geoId, FUN = function(x) cumsum(x))

    return(data)
}
