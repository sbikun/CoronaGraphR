# This script can be run to output daily graphs as pngs for all countries

source("./ETL/country_data.r")
source("./Graphing/ggplot/common_graphs.r")
source("./Data/Graphics/spain_region_colors.r")

############################
# COUNTRIES
############################

####### Read Italy Data ######
italy_data <- ReadDataForCountry("Italy")
italy <- ConvertCommunityToNational(italy_data)

# Conversion to character needs to be done here so sum() works in ConvertCommunityToNational function.
# Earlier conversion makes the interger a factor, which can't be summed.
italy_data$region_code <- as.character(italy_data$region_code)

####### Read Spain Data  ########
spain_community_data <- ReadDataForCountry("Spain")
spain <- ConvertCommunityToNational(spain_community_data)

####### Do some output #########
#OutputAllDimensionsAsPng(italy_data, italy, "Italy", NA)
OutputAllDimensionsAsPng(spain_community_data, spain, "Spain", SPAIN_COLOR_CODES)
