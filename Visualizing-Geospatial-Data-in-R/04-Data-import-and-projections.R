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
neighborhoods <- readOGR(dsn = "Datasets/nynta_16c", layer = "nynta", 
                         p4s = "+proj=lcc +lat_1=40.66666666666666 +lat_2=41.03333333333333 +lat_0=40.16666666666666 +lon_0=-74 +x_0=300000 +y_0=0 +datum=NAD83 +units=us-ft +no_defs +ellps=GRS80 +towgs84=0,0,0")

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
nyc_tracts <- tracts(state = "NY", county = "New York", cb = TRUE, class = "sp")

# Call summary() on nyc_tracts
summary(nyc_tracts)

# Plot nyc_tracts
plot(nyc_tracts)

# Or using tmap
tm_shape(nyc_tracts$geometry) +
  tm_polygons()

# Coordinate reference systems  -------------------------------------------
# Merging data from different CRS/projections
library(sp)

# proj4string() on nyc_tracts and neighborhoods
proj4string(nyc_tracts)
proj4string(neighborhoods)

# coordinates() on nyc_tracts and neighborhoods
head(coordinates(neighborhoods))
head(coordinates(nyc_tracts))

# plot() neighborhoods and nyc_tracts
plot(neighborhoods)
plot(nyc_tracts, col = "red", add = TRUE)

# Converting from one CRS/projection to another
water <- readRDS("Datasets/04_water_big.rds")
library(sp)
library(raster)

# Use spTransform on neighborhoods: neighborhoods
neighborhoods <- spTransform(x = neighborhoods, CRSobj = proj4string(nyc_tracts))

# head() on coordinates() of neighborhoods
head(coordinates(neighborhoods))

# Plot neighborhoods, nyc_tracts and water
plot(neighborhoods)
plot(nyc_tracts, add = TRUE, col = "red")
plot(water, add = TRUE, col = "blue")

# Adding data to spatial objects  -------------------------------------------
# The wrong way
nyc_income <- readRDS("Datasets/04_nyc_income.rds")

library(sp)

# Use str() on nyc_income 
str(nyc_income)

# ...and on nyc_tracts@data
str(nyc_tracts@data)

# Highlight tract 002201 in nyc_tracts
plot(nyc_tracts)
plot(nyc_tracts[nyc_tracts$TRACTCE == "002201", ], 
     col = "red", add = TRUE)

# Set nyc_tracts@data to nyc_income
nyc_tracts@data <- nyc_income

# Highlight tract 002201 again
plot(nyc_tracts)
plot(nyc_tracts[nyc_tracts$tract == "002201", ], 
     col = "red", add = TRUE)

# Checking data will match
# Check for duplicates in nyc_income
any(duplicated(nyc_income$tract))

# Check for duplicates in nyc_tracts
any(duplicated(nyc_tracts$TRACTCE))

# Check nyc_tracts in nyc_income
all(nyc_tracts$TRACTCE %in% nyc_income$tract)

# Check nyc_income in nyc_tracts
all(nyc_income$tract %in% nyc_tracts$TRACTCE)

# Merging data attributes
library(sp)
library(tmap)

# Merge nyc_tracts and nyc_income: nyc_tracts_merge
nyc_tracts_merge <- merge(x = nyc_tracts, y = nyc_income,
                          by.x = "TRACTCE", by.y = "tract")

# Call summary() on nyc_tracts_merge
summary(nyc_tracts_merge)

# Choropleth with col mapped to estimate
tm_shape(nyc_tracts_merge) + 
  tm_fill(col = "estimate") +
  tm_view(view.legend.position = c("right", "bottom"))

# A first plot
library(tmap)

tmap_mode(mode = "plot")
tm_shape(nyc_tracts_merge) +
  tm_fill(col = "estimate") +
  # Add a water layer, tm_fill() with col = "grey90"
  tm_shape(water) +
  tm_fill(col = "grey90") +
  # Add a neighborhood layer, tm_borders()
  tm_shape(neighborhoods) +
  tm_borders() 
  
# Polishing a map
# Subsetting the neighborhoods
head(neighborhoods@data)

library(tmap)

# Find unique() nyc_tracts_merge$COUNTYFP
unique(nyc_tracts_merge$COUNTYFP)

# Add logical expression to pull out New York County
manhat_hoods <- neighborhoods[neighborhoods$CountyFIPS == "061", ]

tm_shape(nyc_tracts_merge) +
  tm_fill(col = "estimate") +
  tm_shape(water) +
  tm_fill(col = "grey90") +
  # Edit to use manhat_hoods instead
  tm_shape(manhat_hoods) +
  tm_borders() +
  # Add a tm_text() layer
  tm_text(text = "NTAName")

# Adding neighborhood labels
manhat_hoods$NTAName

library(tmap)

# gsub() to replace " " with "\n"
manhat_hoods$name <- gsub(" ", "\n", manhat_hoods$NTAName)

# gsub() to replace "-" with "/\n"
manhat_hoods$name <- gsub("-", "/\n", manhat_hoods$name)

# Edit to map text to name, set size to 0.5
tm_shape(nyc_tracts_merge) +
  tm_fill(col = "estimate") +
  tm_shape(water) +
  tm_fill(col = "grey90") +
  tm_shape(manhat_hoods) +
  tm_borders() +
  tm_text(text = "name", size = 0.5)

# Tidying up the legend and some final tweaks
library(tmap)

tm_shape(nyc_tracts_merge) +
  # Add title and change palette
  tm_fill(col = "estimate", 
          title = "Median Income",
          palette = "Greens") +
  # Add tm_borders()
  tm_borders(col = "grey60", lwd = 0.5) +
  tm_shape(water) +
  tm_fill(col = "grey90") +
  tm_shape(manhat_hoods) +
  # Change col and lwd of neighborhood boundaries
  tm_borders(col = "grey40", lwd = 2) +
  tm_text(text = "name", size = 0.5) +
  # Add tm_credits()
  tm_credits("Source: ACS 2014 5-year Estimates, \n accessed via acs package",
             position = c("right", "bottom"))
  
# Save map as "nyc_income_map.png"
tmap_save(tm_shape(nyc_tracts_merge) +
            # Add title and change palette
            tm_fill(col = "estimate", 
                    title = "Median Income",
                    palette = "Greens") +
            # Add tm_borders()
            tm_borders(col = "grey60", lwd = 0.5) +
            tm_shape(water) +
            tm_fill(col = "grey90") +
            tm_shape(manhat_hoods) +
            # Change col and lwd of neighborhood boundaries
            tm_borders(col = "grey40", lwd = 2) +
            tm_text(text = "name", size = 0.5) +
            # Add tm_credits()
            tm_credits("Source: ACS 2014 5-year Estimates, \n accessed via acs package",
                       position = c("right", "bottom")), 
          "Datasets/nyc_income_map.png", width = 4, height = 7)

tmap_save(tm_shape(nyc_tracts_merge) +
            # Add title and change palette
            tm_fill(col = "estimate", 
                    title = "Median Income",
                    palette = "Greens") +
            # Add tm_borders()
            tm_borders(col = "grey60", lwd = 0.5) +
            tm_shape(water) +
            tm_fill(col = "grey90") +
            tm_shape(manhat_hoods) +
            # Change col and lwd of neighborhood boundaries
            tm_borders(col = "grey40", lwd = 2) +
            tm_text(text = "name", size = 0.5) +
            # Add tm_credits()
            tm_credits("Source: ACS 2014 5-year Estimates, \n acessed via acs package",
                       position = c("right", "bottom")), 
          "Datasets/nyc_income_map.html", width = 4, height = 7)
