#source("italy_data.r")
#source("./ETL/CountrySources/spain_gov_etl.r")

source("./ETL/country_data.r")


#spain_regional_data <- ReadSpainCommunityDataFromCSV("https://covid19.isciii.es/resources/serie_historica_acumulados.csv")
spain_regional_data <-ReadDataForCountry("Spain")
spain_regions <- unique(spain_regional_data$region_code)
madrid_data <- subset(spain_regional_data, region_code=="MD")
madrid_data <- subset(madrid_data, total_cases > 100)
madrid_data <- tail(madrid_data, -3)
madrid_data$ID <- seq.int(nrow(madrid_data))

#italy_regional_data <- ReadItalyDataFromCSV("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv")
italy_regional_data <- ReadDataForCountry("Italy")
lombardy_data <- subset(italy_regional_data, italy_regional_data$region_code=="3")
lombardy_data <- subset(lombardy_data, total_cases > 100)
lombardy_data$ID <- seq.int(nrow(lombardy_data))

str(nrow(lombardy_data))

str(nrow(madrid_data))

#plot(lombardy_data$ID, lombardy_data$total_icu, type="l")
#lines(madrid_data$ID, madrid_data$total_icu, col="red")

plot(madrid_data$ID, madrid_data$total_hospitalized, type="b", col="red")
lines(lombardy_data$ID, lombardy_data$total_hospitalized)
