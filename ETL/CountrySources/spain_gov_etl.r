source("./ETL/CountrySources/util.r")

##########
# Reads and normalizes data from the Spanish government's official data.
# Provides diff columns that are grouped by community
# Input File format:
# Columns [CCA Codigo ISO, Fecha, Casos, Hospitalizados, UCI, Fallecidos]
# Final line is text explaining the use of the data
# Dates are converted from strings to dates
# Parameters
#   csv_file_name - Full path of the file to read using read.csv
# Output
#   cv read and normalized to translated names
#   [region_code, date, total_cases, daily_cases, total_hospitalized, daily_hospitalized, total_icu, daily_icu, total_deaths, daily_deaths, total_recovered, daily_recovered]
##########
ReadSpainCommunityDataFromCSV <- function(csv_file_name) {
    cv <- read.csv(csv_file_name, check.names=FALSE)
    cv <- head(cv, -3) # Remove last row with explanation text
    cv[is.na(cv)] <- 0
    translated_colnames <- c('region_code', 'date', 'total_cases', 'total_hospitalized', 'total_icu', 'total_deaths', 'total_recovered')
    colnames(cv) <- translated_colnames
    cv$date <- as.Date(cv[["date"]], format = "%d/%m/%Y")
    #cv$country_code <- 'ES'
    #cv$country_name <- "Spain"
    cv$total_active <- (cv$total_cases - cv$total_recovered - cv$total_deaths)
    str(cv$total_active)

    return(cv)
}


GenerateDailyDiffs <- function(infection_data, dimension_name) {
    infection_data$daily_cases <- ave(infection_data$total_cases, infection_data[[dimension_name]], FUN = function(x) c(NA, diff(x)))
    infection_data$daily_hospitalized <- ave(infection_data$total_hospitalized, infection_data[[dimension_name]], FUN = function(x) c(NA, diff(x)))
    infection_data$daily_icu <- ave(infection_data$total_icu, infection_data[[dimension_name]], FUN = function(x) c(NA, diff(x)))
    infection_data$daily_deaths <- ave(infection_data$total_deaths, infection_data[[dimension_name]], FUN = function(x) c(NA, diff(x)))
    infection_data$daily_recovered <- ave(infection_data$total_recovered, infection_data[[dimension_name]], FUN = function(x) c(NA, diff(x)))
    infection_data$daily_active <- ave(infection_data$total_active, infection_data[[dimension_name]], FUN = function(x) c(NA, diff(x)))

    return(infection_data)
}
