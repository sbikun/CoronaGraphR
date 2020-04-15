
library(ggplot2)
library(gridExtra)
library(gtable)
library(grid)

# Given a set of regions plot as lines related to an ID parameter
# world_data
PlotDimensionForRegionSet <- function(data, x_col_name, region_ids, region_id_col_name, dimension_name, color_codes) {
    g <- ggplot(data, aes_string(x=x_col_name, y=dimension_name, col=region_id_col_name)) + 
        geom_line() +
        scale_color_manual(values = color_codes) +
        geom_smooth()
    return(g)
}

# Plots lines for all regions in a given data set
PlotDimensionForRegions <- function(data, x_col_name, region_id_col_name, dimension_name, line_colors) {

}

# Draws 4 graphs to one plot and adds a legend at the bottom
# spain_communities
GraphDimensionForCountry <- function(regional_data, country_data, dimension_name, country_name, color_codes) {

    total_dimension_name = paste("total_", dimension_name, sep = "")
    daily_dimension_name = paste("daily_", dimension_name, sep = "")

    str(color_codes)

    p1 <- ggplot(country_data, aes_string(x="date", y=total_dimension_name)) + geom_line()
    p2 <- ggplot(country_data, aes_string(x="date", y=daily_dimension_name)) + geom_line() + geom_smooth()
    p3 <- ggplot(regional_data, aes_string(x="date", y=total_dimension_name, col="region_code")) + geom_line()
    p4 <- ggplot(regional_data, aes_string(x="date", y=daily_dimension_name, col="region_code")) + geom_line()

    if (!is.na(color_codes)) {
        p3 <- p3 + scale_color_manual(values = color_codes)
        p4 <- p4 + scale_color_manual(values = color_codes)
    }

    g <- arrangeGrob(
        p1 + theme(legend.position="none"), 
        p2 + theme(legend.position="none"),
        p3 + theme(legend.position="none"),
        p4 + theme(legend.position="none"),
        ncol=2,
        nrow=2
    )

    legend <- gtable_filter(ggplot_gtable(ggplot_build(p3)), "guide-box")
    title <- paste(country_name, dimension_name, sep=" - ")
    footer <- paste(max(country_data$date))
    final <- grid.arrange(g, legend, ncol = 2, widths=c(1.15, 0.25), bottom = footer, top = textGrob(title, gp=gpar(fontsize=20, font=3)))
    return(final)

}

# Draws a graph for all of a country
DrawGraphForCountry <- function(country_data, dimension_name, country_name) {

}

# Output all available graphable dimensions as png
# italy_data, daily_graphs
OutputAllDimensionsAsPng <- function(regional_data, country_data, country_name, color_codes) {
    empty_columns <- apply(regional_data, 2, function(x) any(is.na(x)))

    # Generate output path
    output_path <- paste("Output/", country_name, sep="")
    dir.create(output_path, showWarnings = FALSE)

    for(i in GRAPHABLE_COLUMN_ROOT_NAMES) {
        total_name <- paste("total_", i, sep="")
        if(!empty_columns[total_name]) {
            file_name <- paste(output_path, "/", i, ".png", sep="")
            g <- GraphDimensionForCountry(regional_data, country_data, i, country_name, color_codes)
            ggsave(file_name, plot = g, width = 16, height = 10, dpi = 300)
        }
    }
}
