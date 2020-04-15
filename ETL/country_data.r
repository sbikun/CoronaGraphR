# Centralized location for simlifying reading in data and filling out missing columns

source("./ETL/CountrySources/italy_gov_etl.r")
source("./ETL/CountrySources/spain_gov_etl.r")
source("./ETL/CountrySources/util.r")

ReadDataForCountry <- function(country_name) {
    country_name_caps <- toupper(country_name)
    country_data <- switch(
        country_name_caps,
        "ITALY" = ReadItalyDataFromCSV("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv"),
        "SPAIN" = ReadSpainCommunityDataFromCSV("https://covid19.isciii.es/resources/serie_historica_acumulados.csv"),
        NA
    )

    country_data <- GenerateDailyDiffs(country_data, "region_code")
    country_data <- AddMissingColumns(country_data)

    return(country_data)
}

GenerateDailyDiffs <- function(infection_data, dimension_name) {
    infection_data <- GenerateDiffColumn(infection_data, dimension_name, "recovered")
    infection_data <- GenerateDiffColumn(infection_data, dimension_name, "icu")
    infection_data <- GenerateDiffColumn(infection_data, dimension_name, "hospitalized")
    infection_data <- GenerateDiffColumn(infection_data, dimension_name, "deaths")
    infection_data <- GenerateDiffColumn(infection_data, dimension_name, "cases")
    infection_data <- GenerateDiffColumn(infection_data, dimension_name, "quarantined")
    infection_data <- GenerateDiffColumn(infection_data, dimension_name, "active")
    infection_data <- GenerateDiffColumn(infection_data, dimension_name, "tests")

    return(infection_data)
}

ConvertCommunityToNational <- function(country_data) {
    sp <- aggregate(. ~date, data=country_data, sum, na.rm=TRUE, na.action=NULL)
    return(sp)
}
