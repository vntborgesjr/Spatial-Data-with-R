# --------------------------------------------------- 
# Interactive mpas with leaflet in R - Groups, Layers, and Extras
# 17 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# The leaflet.extras Package  -------------------------------------------
library("leaflet.extras")
leaflet() %>% 
  addTiles() %>% 
  # add a search icon to the map
  addSearchOSM() %>% 
  # make possible to use OpendStreetMap to geocode byclicking on map
  addReverseSearchOSM() %>% 
  # create a reset icon
  addResetMapButton()

# Middle America
library(leaflet.extras)

leaflet() %>%
  addTiles() %>% 
  addSearchOSM() %>% 
  addReverseSearchOSM() 

# Building a Base
m2  <-  
ipeds %>% 
  leaflet() %>% 
  # use the CartoDB provider tile
  addProviderTiles("CartoDB") %>% 
  # center on the middle of the US with zoom of 3
  setView(lat = 39.8282, lng = -98.5795, zoom = 3)

# Map all American colleges 
m2 %>% 
  addCircleMarkers() 

pal <- colorFactor(palette = c("red", "blue", "#9b4a11"), 
                   levels = c("Public", "Private", "For-Profit"))

m2 %>% 
  addCircleMarkers(radius = 2, label = ~name, 
                   color = ~pal(sector_label))

# Overlay Groups  -------------------------------------------
library(htmltools)

# Group colleges by sector using the "group" argument
m <- ca %>% 
  leaflet() %>% 
  addProviderTiles("CartoDB")

# filter sector
ca_public <- ca %>% 
  filter(sector_label == "Public")
ca_private <- ca %>% 
  filter(sector_label == "Private")
ca_profit <- ca %>% 
  filter(sector_label == "For-Profit")

m %>% 
  addCircleMarkers(data = ca_public, color = ~ pal(sector_label),
                   label = ~htmlEscape(name), group = "Public") %>% 
  addCircleMarkers(data = ca_private, color = ~ pal(sector_label),
                   label = ~htmlEscape(name), group = "Private") %>% 
  addCircleMarkers(data = ca_profit, color = ~ pal(sector_label),
                   label = ~htmlEscape(name), group = "Profit") %>% 
  addLayersControl(overlayGroups = levels(factor(ca$sector_label))[1:3])

# Mapping Public Colleges
pal <- colorFactor(palette = c("red", "blue", "#9b4a11"), 
                   levels = c("Public", "Private", "For-Profit"))

# Load the htmltools package
library(htmltools)

# Create data frame called public with only public colleges
public <- filter(ipeds, sector_label == "Public")  

# Create a leaflet map of public colleges called m3 
m3 <- leaflet() %>% 
  addProviderTiles("CartoDB") %>% 
  addCircleMarkers(data = public, radius = 2, label = ~htmlEscape(name),
                   color = ~pal(sector_label), group = "Public")

m3

# Mapping Public and Private Colleges
# Create data frame called private with only private colleges
private <- filter(ipeds, sector_label == "Private")  

# Add private colleges to `m3` as a new layer
m3 <- m3 %>% 
  addCircleMarkers(data = private, radius = 2, label = ~htmlEscape(name),
      color = ~pal(sector_label), group = "Private") %>% 
  addLayersControl(overlayGroups = c("Public", "Private"))

m3

# Mapping All Colleges
# Create data frame called profit with only For-Profit colleges
profit <- filter(ipeds, sector_label == "For-Profit")  

# Add For-Profit colleges to `m3` as a new layer
m3 <- m3 %>% 
  addCircleMarkers(data = profit, radius = 2, label = ~htmlEscape(name),
                   color = ~pal(sector_label),   group = "For-Profit")  %>% 
  addLayersControl(overlayGroups = c("Public", "Private", "For-Profit"))  

# Center the map on the middle of the US with a zoom of 4
m4 <- m3 %>%
  setView(lat = 39.8282, lng = -98.5795, zoom = 4) 

m4

# Base Groups  -------------------------------------------
# Base Groups and Multiple Map Tiles
leaflet() %>% 
  addTiles(group = "OMS") %>% 
  addProviderTiles("CartoDB",  group = "Carto") %>% 
  addProviderTiles("Esri", group = "Esri") %>% 
  # Toggle between different base maps
  addLayersControl(baseGroups = c("OSM", "Carto", "Esri"),
                   position = "topleft")

# Overlay and base groups in 4 steps
# initialize leaflet map
leaflet() %>% 
  # add basemaps with groups
  addTiles(group = "OSM") %>% 
  addProviderTiles("CartoDB", group = "Carto") %>% 
  addProviderTiles("Esri", group = "Esri") %>% 
  # add marker layer for each sector with corresponding group name
  addCircleMarkers(data = public, radius = 2,
                   label = ~ htmlEscape(name),
                   color = ~ pal(sector_label), group = "Public") %>% 
  addCircleMarkers(data = private, radius = 2,
                   label = ~ htmlEscape(name),
                   color = ~ pal(sector_label), group = "Private") %>%
  addCircleMarkers(data = profit, radius = 2,
                   label = ~ htmlEscape(name),
                   color = ~ pal(sector_label), group = "For-Profit") %>%
  # add layer controls for base and overlay groups
  addLayersControl(baseGroups = c("OSM", "Carto", "Esri"),
                   overlayGroups = c("Public", "Private", "For-Profit"))

# Change up the Base
leaflet() %>% 
  # Add the OSM, CartoDB and Esri tiles
  addTiles(group = "OSM") %>% 
  addProviderTiles("CartoDB", group = "CartoDB") %>% 
  addProviderTiles("Esri", group = "Esri") %>% 
  # Use addLayersControl to allow users to toggle between basemaps
  addLayersControl(baseGroups = c("OSM", "CartoDB", "Esri"))

# Putting it all Together
m4 <- leaflet() %>% 
  addTiles(group = "OSM") %>% 
  addProviderTiles("CartoDB", group = "Carto") %>% 
  addProviderTiles("Esri", group = "Esri") %>% 
  addCircleMarkers(data = public, radius = 2, label = ~htmlEscape(name),
      color = ~pal(sector_label),  group = "Public") %>% 
  addCircleMarkers(data = private, radius = 2, label = ~htmlEscape(name),
      color = ~pal(sector_label), group = "Private")  %>% 
  addCircleMarkers(data = profit, radius = 2, label = ~htmlEscape(name),
      color = ~pal(sector_label), group = "For-Profit")  %>% 
  addLayersControl(baseGroups = c("OSM", "Carto", "Esri"), 
      overlayGroups = c("Public", "Private", "For-Profit")) %>% 
  setView(lat = 39.8282, lng = -98.5795, zoom = 4) 

m4

# Pieces of Flair  -------------------------------------------
# The College Search
ca_public %>% 
  leaflet() %>% 
  addProviderTiles("Esri") %>% 
  addCircleMarkers(radius = 2, 
                   label = ~ htmlEscape(name),
                   color = ~ pal(sector_label),
                   group = "Public",
                   clusterOptions = markerClusterOptions()) %>% 
  addSearchFeatures(targetGroups = "Public",
                    options = searchFeaturesOptions(zoom = 10))

# Adding a Piece of Flair
# Make each sector of colleges searchable 
m4_search <- m4  %>% 
  addSearchFeatures(
    targetGroups = c("Public", "Private", "For-Profit"), 
    # Set the search zoom level to 18
    options = searchFeaturesOptions(zoom = 18)) 

# Try searching the map for a college
m4_search

# A Cluster Approach
ipeds %>% 
  leaflet() %>% 
  addTiles() %>% 
  # Sanitize any html in our labels
  addCircleMarkers(radius = 2, label = ~ htmlEscape(name),
                   # Color code colleges by sector using the `pal` color palette
                   color = ~ pal(sector_label),
                   # Cluster all colleges using `clusterOptions`
                   clusterOptions =  markerClusterOptions()) 
