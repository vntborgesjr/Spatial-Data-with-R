# --------------------------------------------------- 
# Interactive Maps with leaflet in R - Setting Up Interactive Web Maps 
# 15 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Introduction to leaflet  -------------------------------------------
# Creating a interactive web map
# Load the leaflet library
library(leaflet)

# Create a leaflet map with default map tile using addTiles()
leaflet() %>% 
  addTiles() 

# Provider Tiles  -------------------------------------------
# Access the list of tiles (base maps)
names(providers[1:10])
library(stringr)
names(providers)[str_detect(names(providers), "OpenStreetMap")] 

# Plot a map with non-default tile
leaflet() %>% 
  # addTiles()
  addProviderTiles("OpenStreetMap.BlackAndWhite")

# Provider Tiles
library(tidyverse)

# Print the providers list included in the leaflet library
providers

# Print only the names of the map tiles in the providers list 
names(providers)

# Use str_detect() to determine if the name of each provider tile contains the string "CartoDB"
str_detect(names(providers), "CartoDB")

# Use str_detect() to print only the provider tile names that include the string "CartoDB"
names(providers)[str_detect(names(providers), "CartoDB")]

# Adding a Custom Map Tile
# Change addTiles() to addProviderTiles() and set the provider argument to "CartoDB"
leaflet() %>% 
  addProviderTiles(provider = "CartoDB")

# Create a leaflet map that uses the Esri provider tile 
leaflet() %>% 
  addProviderTiles(provider = "Esri")

# Create a leaflet map that uses the CartoDB.PositronNoLabels provider tile
leaflet() %>% 
  addProviderTiles(provider = "CartoDB.PositronNoLabels")

# Setting the Default Map View  -------------------------------------------
# Turn the ability to pan the map off and to limit the allowed zoom levels.
# leaflet(dragging = FALSE, minZoom = , maxZoom = )
# Alternative use the setMaxBounds() function

# A Map with a View I
leaflet()  %>% 
  addProviderTiles("CartoDB")  %>% 
  setView(lat = 40.7, lng = -74.0, zoom = 10)

# Map with CartoDB tile centered on DataCamp's NYC office with zoom of 6
leaflet()  %>% 
  addProviderTiles("CartoDB")  %>% 
  setView(lng = -73.98575, lat = 40.74856, zoom = 6)

# Map with CartoDB.PositronNoLabels tile centered on DataCamp's Belgium office with zoom of 4
leaflet() %>% 
  addProviderTiles("CartoDB.PositronNoLabels") %>% 
  setView(lng = 4.717863, lat = 50.881363, zoom = 4)

# A Map with a Narrower View
leaflet(options = 
          leafletOptions(minZoom = 14, dragging = FALSE))  %>% 
  addProviderTiles("CartoDB")  %>% 
  setView(lng = -73.98575, lat = 40.74856, zoom = 14) 

# Load data
dc_hq <- read.csv("Datasets/dc_hq.csv")

leaflet(options = leafletOptions(
  # Set minZoom and dragging 
  minZoom = 12, dragging = TRUE))  %>% 
  addProviderTiles("CartoDB")  %>% 
  
  # Set default zoom level 
  setView(lng = dc_hq$lon[2], lat = dc_hq$lat[2], zoom = 14) %>% 
  
  # Set max bounds of map 
  setMaxBounds(lng1 = dc_hq$lon[2] + .05, 
               lat1 = dc_hq$lat[2] + .05, 
               lng2 = dc_hq$lon[2] - .05, 
               lat2 = dc_hq$lat[2] - .05) 

# Plotting DataCamp HQ  -------------------------------------------
# Mark it
leaflet()  %>% 
  addProviderTiles("CartoDB")  %>% 
  addMarkers(lng = -73.98575, lat = 40.74856)

# Plot DataCamp's NYC HQ
leaflet() %>% 
  addProviderTiles("CartoDB") %>% 
  addMarkers(lng = dc_hq$lon[1], lat = dc_hq$lat[1])

# Plot DataCamp's NYC HQ with zoom of 12    
leaflet() %>% 
  addProviderTiles("CartoDB") %>% 
  addMarkers(lng = -73.98575, lat = 40.74856)  %>% 
  setView(lng = -73.98575, lat = 40.74856, zoom = 12)    

# Plot both DataCamp's NYC and Belgium locations
leaflet() %>% 
  addProviderTiles("CartoDB") %>% 
  addMarkers(lng = dc_hq$lon, lat = dc_hq$lat)

# Adding Popups and Storing your Map
dc_nyc <- 
  leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = -73.98575, lat = 40.74856, 
             popup = "DataCamp - NYC") 

dc_nyc %>% 
  setView(lng = -73.98575, lat = 40.74856, 
          zoom = 2)

# Store leaflet hq map in an object called map
map <- leaflet() %>%
  addProviderTiles("CartoDB") %>%
  # Use dc_hq to add the hq column as popups
  addMarkers(lng = dc_hq$lon, lat = dc_hq$lat,
             popup = dc_hq$hq)

# Center the view of map on the Belgium HQ with a zoom of 5 
map_zoom <- map %>%
  setView(lat = 50.881363, lng = 4.717863,
          zoom = 5)

# Print map_zoom
print(map_zoom)

