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
