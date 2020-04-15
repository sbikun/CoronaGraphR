
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

    str(colnames(country_data))
    country_data <- GenerateDailyDiffs(country_data, "region_code")
    str(colnames(country_data))
    country_data <- AddMissingColumns(country_data)
    str(colnames(country_data))

    return(country_data)
}

GenerateDiffColumn <- function(infection_data, dimension_name, base_column_name) {
    col_names <- colnames(infection_data)

    total_name <- paste("total_", base_column_name, sep="")
    daily_name <- paste("daily_", base_column_name, sep="")

    if(total_name %in% col_names) {
        if(!(daily_name %in% col_names)) {
            infection_data[[daily_name]] <- ave(infection_data[[total_name]], infection_data[[dimension_name]], FUN = function(x) c(NA, diff(x)))
        }
    }

    return(infection_data)
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


spain_data <- ReadDataForCountry("Spain")

c <- apply(spain_data, 2, function(x) any(is.na(x)))
c["total_tests"]

