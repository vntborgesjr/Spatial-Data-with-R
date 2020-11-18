# --------------------------------------------------- 
# Interactive mpas with leaflet in R - Plotting Polygons 
# 17 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Spatial Data  -------------------------------------------
# Introduction to Spatial Data
# Load data with a double click

# Print a summary of the `shp` data
summary(shp)

# Print the class of `shp`
class(shp)

# Print the slot names of `shp`
slotNames(shp)

# Exploring Spatial Data
# Glimpse the data slot of shp
glimpse(shp@data)

# Print the class of the data slot of shp
class(shp@data)

# Print GEOID10
shp@data$GEOID10

# Joining Spatial Data
nc_income <- read_csv("Datasets/NC-Zipcode-Income-data.csv")

# Glimpse the nc_income data
glimpse(nc_income)

# Summarize the nc_income data
summary(nc_income)

# Left join nc_income onto shp@data 
shp@data$GEOID10 <- as.double(shp@data$GEOID10)
shp_nc_income <- shp@data %>% 
  left_join(nc_income, by = c("GEOID10" = "zipcode"))

# Print the number of missing values of each variable in shp_nc_income
shp_nc_income  %>%
  summarize_all(funs(sum(is.na(.))))
