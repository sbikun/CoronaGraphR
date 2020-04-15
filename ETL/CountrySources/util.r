
source("./Data/column_constants.r")

AddMissingColumns <- function(country_data) {
    missing_columns <- setdiff(COLUMNS, names(country_data))
    country_data[missing_columns] <- NA
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

