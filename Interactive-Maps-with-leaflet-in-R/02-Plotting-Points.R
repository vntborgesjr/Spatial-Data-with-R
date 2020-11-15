# --------------------------------------------------- 
# Interactive mpas with leaflet in R - Plotting Points 
# 15 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Introduction to IPEDS Data  -------------------------------------------
# Cleaning up the Base Map
m <- map  %>% 
  addMarkers(lng = dc_hq$lon, lat = dc_hq$lat) %>% 
  setView(lat = 50.9, lng = 4.7, zoom = 5)

m  %>% 
  clearMarkers() %>% 
  clearBounds()

# Remove markers, reset bounds, and store the updated map in the m object
map_clear <- map  %>%
  clearMarkers()  %>% 
  clearBounds()

# Print the cleared map
map_clear

# Exploring the IPEDS Data
ipeds <- read.csv("Datasets/IPEDS-All-4-year-Colleges.csv")
str(ipeds)

ipeds %>% 
  group_by(sector_label) %>% 
  count()

# Exploring the IPEDS Data II
miss_ex <- tibble(
  animal = c("dog", "cat", "rat", NA),
  name   = c("Woodruf", "Stryker", NA, "Morris"),
  age    = c(1:4))
miss_ex

miss_ex %>% 
  drop_na() %>% 
  arrange(desc(age))

# Remove colleges with missing sector information
ipeds <- 
  ipeds %>% 
  drop_na()

# Count the number of four-year colleges in each state
ipeds %>% 
  group_by(state)  %>% 
  count()

# Create a list of US States in descending order by the number of colleges in each state
ipeds  %>% 
  group_by(state)  %>% 
  count()  %>% 
  arrange(desc(n))

# Mapping California Colleges  -------------------------------------------
# California Colleges
# There is no data available to reproduce the examples
# Create a dataframe called `ca` with data on only colleges in California
ca <- ipeds %>%
  filter(state == "CA")

# Use `addMarkers` to plot all of the colleges in `ca` on the `m` leaflet map
map %>%
  addMarkers(lng = ca$lng, lat = ca$lat)

# The city of College
# Coordinates for the center of LA
la_coords <- data.frame(lat = 34.05223, lon = -118.2437)

# Center the map on LA 
map %>% 
  addMarkers(data = ca) %>% 
  setView(lat = la_coords$lat, lng = la_coords$lon, zoom = 12)

# Set the zoom level to 8 and store in the m object
map_zoom <- 
map %>%
  addMarkers(data = ca) %>%
  setView(lat = la_coords$lat, lng = la_coords$lon, zoom = 8)

map_zoom

# Circle Markers
# Clear the markers from the map 
map2 <- map %>% 
  clearMarkers()

# Use addCircleMarkers() to plot each college as a circle
map2 %>%
  addCircleMarkers(lng = ca$lng, lat = ca$lat)

# Change the radius of each circle to be 2 pixels and the color to red
map2 %>% 
  addCircleMarkers(lng = ca$lng, lat = ca$lat,
                   radius = 2, color = "red")

# Labels and Pop-up  -------------------------------------------
# Making our Map Pop
# Add circle markers with popups for college names
map %>% 
  addCircleMarkers(data = ca, radius = 2, popup = ~name)

# Change circle markers' color to #2cb42c and store map in map_color object
map_color <- map %>% 
  addCircleMarkers(data = ca, radius = 2, color = "#2cb42c", popup = ~name)

# Print map_color
map_color

# Clear the bounds and markers on the map object and store in map2
map2 <- map %>% 
  clearBounds() %>% 
  clearMarkers()

# Add circle markers with popups that display both the institution name and sector
map2 %>% 
  addCircleMarkers(data = ca, radius = 2, 
                   popup = ~paste0(name, "<br/>", sector_label))

# Make the institution name in each popup bold
map2 %>% 
  addCircleMarkers(data = ca, radius = 2, 
                   popup = ~paste0("<b>", name, "</b>", "<br/>", sector_label))

# Swapping Popups for Labels
# Add circle markers with labels identifying the name of each college
map %>% 
  addCircleMarkers(data = ca, radius = 2, label = ~name)

# Use paste0 to add sector information to the label inside parentheses 
map %>% 
  addCircleMarkers(data = ca, radius = 2, 
                   label = ~paste0(name, " (", sector_label, ")"))

