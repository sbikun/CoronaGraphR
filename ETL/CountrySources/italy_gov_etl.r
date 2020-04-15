#these libraries need to be loaded
library(utils)
library(httr)
library(stringr)

# http://www.salute.gov.it/portale/nuovocoronavirus/dettaglioContenutiNuovoCoronavirus.jsp?area=nuovoCoronavirus&id=5351&lingua=italiano&menu=vuoto
# https://github.com/pcm-dpc/COVID-19/blob/master/dati-regioni/dpc-covid19-ita-regioni.csv

##########
# Reads and normalizes data from the Spanish government's official data.
# Provides diff columns that are grouped by community
#
# Input File format:
# Columns [data, stato, codice_regione, denominazione_regione, lat, long, ricoveraticon_sintomi, terapia_intensiva, totale_ospedalizzati, isolamento_domiciliare, totale_positivi, variazione_totale_positivi, nuovi_positivi, dimessi_guariti, deceduti, totale_casi, tamponi, note_it, note_en]
# Columns (ENG) [date, country, region_code, region_name, lat, long, recovered, uci, hospitalized, quarantined, total_positive, total_positive_variation, new_positive, recovered, deaths, total_cases, swabs, note_it, note_en]
# Dates are converted from strings to dates
#
# Parameters
#   csv_file_name - Full path of the file to read using read.csv
#
# Output
#   cv read and normalized to translated names
#   [date, country, region_code, region_name, lat, long, recovered, uci, hospitalized, quarantined, total_positive, total_positive_variation, new_positive, recovered, deaths, total_cases, swabs, note_it, note_en]
##########
ReadItalyDataFromCSV <- function(csv_file_name) {
    GET(csv_file_name, authenticate(":", ":", type="ntlm"), write_disk(tf <- tempfile(fileext = ".csv")))

    #read the Dataset sheet into “R”. The dataset will be called "data".
    data <- read.csv(tf)
    translated_colnames <- c(
        'date', 'country_code', 'region_code', 'region_name', 'lat', 'long', 'total_recovered',
        'total_icu', 'total_hospitalized', 'total_quarantined', 'total_active', 'total_active_variation',
        'daily_active', 'total_recovered', 'total_deaths', 'total_cases', 'total_tests', 'note_it', 'note_en'
    )
    colnames(data) <- translated_colnames

    data$date <- strtrim(data$date, 10)
    data$date <- as.Date(data[["date"]], format="%Y-%m-%d")

    return(data)
}
