
source("./ETL/country_data.r")
source("./Graphing/ggplot/common_graphs.r")

italy_data <- ReadDataForCountry("Italy")
italy_data

# Prep Italy data
italy <- ConvertCommunityToNational(italy_data)

lombardy_data <- subset(italy_data, italy_data$region_code=="3")

#ggplot(italy_data, aes_string(x="date", y="total_cases", col="region_code")) + geom_line()

#plot(italy$date, italy$total_deaths, type="b")
#plot(italy$date, italy$daily_deaths, type="b", col="red")

#plot(lombardy_data$date, lombardy_data$total_hospitalized, type="l")
#plot(lombardy_data$date, lombardy_data$daily_hospitalized, type="l", col="red")

#OutputAllDimensionsAsPng(italy_data, italy, "Italy")
