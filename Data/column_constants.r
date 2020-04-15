# Stores all sets of column names and root names

# All root names for total_, daily_, etc. graphable values
GRAPHABLE_COLUMN_ROOT_NAMES = c(
    "hospitalized",
    "recovered",
    "icu",
    "quarantined",
    "positive",
    "deaths",
    "cases",
    "tests",
    "active"
)

# Set of all columns that should exist for regional data sets
COLUMNS = c(
    "date", # 1
    "country_code", # 2
    "country_name", # 3
    "region_code",  # 4
    "region_name",
    #"lat",
    #"long",
    "daily_hospitalized", # 5
    "total_hospitalized", # 6
    "daily_recovered", # 7
    "total_recovered", #
    "daily_icu", #
    "total_icu", #
    "daily_quarantined",
    "total_quarantined",

    "total_positive",
    "total_positive_variation",
    "new_positive",

    "daily_recovered", #
    "total_recovered", #
    "daily_deaths", #
    "total_deaths", #
    "daily_cases", #
    "total_cases", #
    "daily_tests",
    "total_tests"
    #"note_it"
    #"note_en"
)