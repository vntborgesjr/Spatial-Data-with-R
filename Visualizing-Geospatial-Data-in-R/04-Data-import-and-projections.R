# --------------------------------------------------- 
# Visualizing Spatial Data in R - Data import and projection 
# 13 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Reading in spatial data  -------------------------------------------
# Reading in a shapefile
library(sp)
library(rgdal)

# Use dir() to find directory name
dir("Datasets")

# Call dir() with directory name
dir("Datasets/nynta_16c")

# Read in shapefile with readOGR(): neighborhoods
neighborhoods <- readOGR(dsn = "Datasets/nynta_16c", layer = "nynta")

# summary() of neighborhoods
summary(neighborhoods)

# Plot neighborhoods
plot(neighborhoods)

# or using tmap
tm_shape(neighborhoods) + 
  tm_polygons()

# Reading in a raster file
library(raster) 

# Call dir()
dir("Datasets")

# Call dir() on the directory
dir("Datasets/nyc_grid_data")

# Use raster() with file path: income_grid
income_grid <- raster(x = "Datasets/nyc_grid_data/m5602ahhi00.tif")

# Call summary() on income_grid
summary(income_grid)

# Call plot() on income_grid
plot(income_grid)

# Or using tmap
tm_shape(income_grid) + 
  tm_raster(col = "m5602ahhi00.tif")

# Getting data using a package
library(sp)
library(tigris)

# Call tracts(): nyc_tracts
nyc_tracts <- tracts(state = "NY", county = "New York", cb = TRUE)

# Call summary() on nyc_tracts
summary(nyc_tracts)

# Plot nyc_tracts
plot(nyc_tracts$geometry)

# Or using tmap
tm_shape(nyc_tracts$geometry) +
  tm_polygons()
