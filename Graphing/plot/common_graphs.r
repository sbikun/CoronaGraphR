
source("./ETL/CountrySources/util.r")
source("./Data/column_constants.r")

# Given a set of regions plot as lines related to an ID parameter
PlotDimensionForRegionSet <- function(data, x_col_name, region_ids, region_id_col_name, dimension_name, line_colors) {
    data <- data[data[[region_id_col_name]] %in% region_ids, ]

    plot(data[[x_col_name]], data[[dimension_name]], main=paste("Coronavirus -", dimension_name), xlab="Days since 100 cases", ylab=dimension_name, type="l", lty=0)
    for(i in region_ids) {
        region_data <- data[data[[region_id_col_name]] == i, ]
        lines(region_data[[x_col_name]], region_data[[dimension_name]], col=line_colors[i])
    }
    legend("topleft", legend=region_ids, lwd=1, col=line_colors)
}

# Plots lines for all regions in a given data set
PlotDimensionForRegions <- function(data, x_col_name, region_id_col_name, dimension_name, line_colors) {
    regions <- unique(data[[region_id_col_name]])

    plot(data[[x_col_name]], data[[dimension_name]], main=paste("Coronavirus -", dimension_name), xlab="Days since 100 cases", ylab=dimension_name, type="l", lty=0)
    for(i in regions) {
        region_data <- data[data[[region_id_col_name]] == i, ]
        lines(region_data[[x_col_name]], region_data[[dimension_name]], col=line_colors[i])
    }
}

# Draws 4 graphs to one plot and adds a legend at the bottom
GraphDimensionForCountry <- function(spain_community_data, spain, dimension_name, country_name, color_codes) {
    regions <- unique(spain_community_data[["region_code"]])

    # Graph drawing sections
    # Prep canvas to have 4 graphs and a bottom margin for the legend
    par(mfrow=c(2,2), oma=c(4,1,1,1))

    total_dimension_name = paste("total_", dimension_name, sep = "")
    daily_dimension_name = paste("daily_", dimension_name, sep = "")

    DrawGraphForCountry(spain, total_dimension_name, country_name)
    DrawGraphForCountry(spain, daily_dimension_name, country_name)
    PlotDimensionForRegions(spain_community_data, "date", "region_code", total_dimension_name, color_codes)
    PlotDimensionForRegions(spain_community_data, "date", "region_code", daily_dimension_name, color_codes)

    par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
    plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
    legend("bottom", inset=c(0,0), legend=regions, xpd=TRUE, lwd=1, col=color_codes, horiz=TRUE, cex=0.5)
}

# Draws a graph for all of a country
DrawGraphForCountry <- function(country_data, dimension_name, country_name) {
    plot(country_data$date, country_data[[dimension_name]], main=paste(country_name, dimension_name, sep=" - "), xlab="Date", ylab=dimension_name, type="l")
}

# Output all available graphable dimensions as png
OutputAllDimensionsAsPng <- function(regional_data, country_data, country_name, color_codes) {
    na_columns <- apply(regional_data, 2, function(x) any(is.na(x)))

    # Generate output path
    output_path <- paste("Output/", country_name, sep="")
    dir.create(output_path, showWarnings = FALSE)

    for(i in GRAPHABLE_COLUMN_ROOT_NAMES) {
        total_name <- paste("total_", i, sep="")
        if(!na_columns[total_name]) {
            file_name <- paste(output_path, "/", i, ".png", sep="")
            png(file_name)
            GraphDimensionForCountry(regional_data, country_data, i, country_name, color_codes)
            dev.off() 
        }
    }
}
