
source("./ETL/country_data.r")
source("./Graphing/ggplot/common_graphs.r")
source("./Data/Graphics/spain_region_colors.r")
library(ggplot2)
library(gridExtra)

# Draw lines for women's march and lockdown
AppendVerticalLines <- function() {
    abline(v=as.Date("03/08/2020", format="%m/%d/%Y"), col="pink") # Women's March    
    abline(v=as.Date("03/22/2020", format="%m/%d/%Y"), col="pink") # Women's March + 2 weeks
    abline(v=as.Date("03/13/2020", format="%m/%d/%Y"), col="black") # Lockdown
    abline(v=as.Date("03/27/2020", format="%m/%d/%Y"), col="black") # Lockdown + 2 weeks
}

####### Read Spain Data  ########
# Prep community data 
spain_community_data <- ReadDataForCountry("Spain")

# Prep Spain data
spain <- ConvertCommunityToNational(spain_community_data)

####### Do some output #########

str(SPAIN_COLOR_CODES)

# cases, hospitalized, icu, deaths, recovered
#GraphDimensionForCountry(spain_community_data, spain, "deaths", "Spain", SPAIN_COLOR_CODES)

# Output latest Madrid data
madrid_data <- subset(spain_community_data, region_code=="MD")
madrid_data <- subset(madrid_data, total_cases > 100)
#madrid_data$ID <- sequence(rle(as.character(madrid_data$region_code))$lengths)

str(tail(madrid_data, 1))
print(ggplot(madrid_data, aes(x=date, y=total_hospitalized)) + geom_line() + xlim(as.Date("03/01/2020", format = "%m/%d/%Y"), as.Date("06/01/2020", format = "%m/%d/%Y")) + stat_smooth(method="gam", fullrange=TRUE))

