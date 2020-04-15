source("./ETL/WorldSources/eu_cdc_etl.r")
source("./Graphing/ggplot/common_graphs.r")
library(dplyr)
library(ggplot2)
library(grid)
library(gridExtra)
library(gtable)

GEOID_COLOR_CODES <- c(
    "AT" = "pink", # Belgium
    "CN" = "red", # China
    "DK" = "purple", # Denmark
    "EL" = "darkblue", #Greece
    "ES" = "orange", # Spain
    "FR" = "darkblue", # France
    "IT" = "green", # Italy≈
    "LU" = "cadetblue2", # Luxembourg
    "NL" = "orange", # Netherlands
    "PL" = "black", # Poland
    "PT" = "red", # Portugal
    "UK" = "azure4", # UK
    "US" = "blue" # US
)

OUTPUT_COLUMN_NAMES <- c(
    "cases",
    "deaths",
    "deathsSum",
    "casesSum"
)

DrawGountryGroupToSharedPng <- function(group_data, group_geoIds, group_name, title, x_label) {
    file_name <- file_name <- paste("Output/World/world_", group_name, ".png", sep="")

    x_column_name = "ID"

    p1 <- PlotDimensionForRegionSet(group_data, x_column_name, group_geoIds, "geoId", "cases", GEOID_COLOR_CODES) + xlab(x_label) + ylab("Daily Cases")
    p2 <- PlotDimensionForRegionSet(group_data, x_column_name, group_geoIds, "geoId", "deaths", GEOID_COLOR_CODES) + xlab(x_label) + ylab("Daily Deaths")
    p3 <- PlotDimensionForRegionSet(group_data, x_column_name, group_geoIds, "geoId", "casesSum", GEOID_COLOR_CODES) + xlab(x_label) + ylab("Total Cases")
    p4 <- PlotDimensionForRegionSet(group_data, x_column_name, group_geoIds, "geoId", "deathsSum", GEOID_COLOR_CODES) + xlab(x_label) + ylab("Total Deaths")
    g <- arrangeGrob(
        p1 + theme(legend.position="none"), 
        p2 + theme(legend.position="none"), 
        p3 + theme(legend.position="none"), 
        p4 + theme(legend.position="none"), 
        ncol=2, 
        nrow=2
    )

    legend = gtable_filter(ggplot_gtable(ggplot_build(p1)), "guide-box")

    title <- paste("World: ", title, sep="")
    max_date <- paste(max(group_data$dateRep))
    footer <- paste("Source: European Centre for Disease Prevention and Control (", max_date, ")", sep="")

    final <- grid.arrange(g, legend, ncol = 2, widths=c(1.1, 0.1), top = textGrob(title, gp=gpar(fontsize=20, font=3)), bottom = footer)
    ggsave(file_name, plot = final, width = 16, height = 10, dpi = 300)
}

##### Graphs of days since country hit 100 cases

world_data <- ReadWorldData()

world_data <- subset(world_data, cases > 100)
world_data$ID <- sequence(rle(as.character(world_data$geoId))$lengths)

str(world_data$geoId)

large_outbreaks <- c("CN", "ES", "FR", "IT", "PL", "UK", "US")
small_outbreaks <- c("AT", "DK", "LU", "NL", "PL")
iberian_outbreaks <- c("ES", "FR", "PT")

group1_data <- filter(world_data, geoId %in% large_outbreaks)
group2_data <- filter(world_data, geoId %in% small_outbreaks)
iberian_data <- filter(world_data, geoId %in% iberian_outbreaks)

x_label <- "Days since 100 cases"

## Output Images ##
DrawGountryGroupToSharedPng(group1_data, large_outbreaks, "large-outbreaks", "Large Outbreaks", x_label)
DrawGountryGroupToSharedPng(group2_data, small_outbreaks, "small-outbreaks", "Small EU Outbreaks", x_label)
DrawGountryGroupToSharedPng(iberian_data, iberian_outbreaks, "iberian-outbreaks", "Spain and Neighbors", x_label)
