# --------------------------------------------------- 
# Interactive maps with leaflet in R - Plotting Polygons 
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
nc_income$zipcode <- factor(nc_income$zipcode)
shp_nc_income <- shp@data %>% 
  left_join(nc_income, by = c("GEOID10" = "zipcode"))

shp@data <- shp@data %>% 
  left_join(nc_income, by = c("GEOID10" = "zipcode"))

# Print the number of missing values of each variable in shp_nc_income
shp_nc_income  %>%
  summarize_all(funs(sum(is.na(.))))

# Mapping Polygons  ------------------ -------------------------
# addPolygons(weight = , color = , label = , highlightOptions = )
# weight - control the thickness of the boundary lines in pixels
# color - the color of the polygon
# label - the information to appear on hover
# highlight - option to highlight a polygon on hover
              
# Coloring numeric data
# colorNumeric(palette, domain = ) - maps continuous data to an 
# interpoleted palette
# colorBin(palette = , bins = , domain = ) - color the numeric data
# based on a specified number of groups using the cut function
# colorQuantile(palette = , n = , domain = ) - color the numeric data
# based on a specified number of groups using the quatile function

# Using previewColors in a colorNumeric() object allow you to look at
# how our palette will represent sample values from within the domain

# addPolygons() Function
# map the polygons in shp
shp %>% 
  leaflet() %>% 
  addTiles() %>% 
  addPolygons()

# which zips were not in the income data?
shp_na <- shp@data[is.na(shp@data$mean_income),]

# Creating a new SpatialPolygonDatFram object: shp_na
shp_na <- shp[is.na(shp$mean_income), ]

# map the polygons in shp_na
shp_na %>% 
  leaflet() %>% 
  addTiles() %>% 
  addPolygons()

# NC High Income Zips
# summarize the mean income variable
summary(shp$mean_income)

# subset shp to include only zip codes in the top quartile of mean income
high_inc <- shp[!is.na(shp$mean_income) & shp$mean_income > summary(shp$mean_income)[5],]

# map the boundaries of the zip codes in the top quartile of mean income
high_inc %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons()

# addPolygon() Options
# create color palette with colorNumeric()
nc_pal <- colorNumeric("YlGn", domain = high_inc@data$mean_income)

high_inc %>%
  leaflet() %>%
  addTiles() %>%
  # set boundary thickness to 1 and color polygons
  addPolygons(weight = 1, color = ~ nc_pal(mean_income),
                 # add labels that display mean income
                 label = ~ paste0("Mean Income: ", dollar(mean_income)),
                 # highlight polygons on hover
                 highlight = highlightOptions(weight = 5, color = "white",
                                        bringToFront = TRUE))

# Use the log function to create a new version of nc_pal
nc_pal <- colorNumeric("YlGn", domain = log(high_inc@data$mean_income))

# comment out the map tile
high_inc %>%
  leaflet() %>%
  #addProviderTiles("CartoDB") %>%
  # apply the new nc_pal to the map
  addPolygons(weight = 1, color = ~ nc_pal(log(mean_income)), fillOpacity = 1,
              label = ~ paste0("Mean Income: ", dollar(mean_income)),
              highlightOptions = highlightOptions(weight = 5, color = "white", bringToFront = TRUE))

# Putting it All Together  -------------------------------------------
# Load wealthy_zip.Rda
# Print the slot names of `wealthy_zips`
slotNames(wealthy_zips)

# Print a summary of the `mean_income` variable
summary(wealthy_zips@data$mean_income)

# plot zip codes with mean incomes >= $200k
wealthy_zips %>% 
  leaflet() %>% 
  addProviderTiles("CartoDB") %>% 
  # set color to green and create Wealth Zipcodes group
  addPolygons(weight = 1, fillOpacity = .7, color = "green",  group = "Wealthy Zipcodes", 
              label = ~paste0("Mean Income: ", dollar(mean_income)),
              highlightOptions = highlightOptions(weight = 5, color = "white", bringToFront = TRUE))

# Final Map
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
  setView(lat = 39.8282, lng = -98.5795, zoom = 4) %>% 
  addSearchFeatures(
    targetGroups = c("Public", "Private", "For-Profit"), 
    # Set the search zoom level to 18
    options = searchFeaturesOptions(zoom = 18)) %>% 
  # create a reset icon
  addResetMapButton()

# Add polygons to m4 using wealthy_zips
final_map <- m4 %>% 
  addPolygons(data = wealthy_zips, weight = 1, fillOpacity = .5, color = "Grey",  group = "Wealthy Zip Codes", 
              label = ~paste0("Mean Income: ", dollar(mean_income)),
              highlight = highlightOptions(weight = 5, color = "white", bringToFront = TRUE)) %>% 
  # Update layer controls including "Wealthy Zip Codes"
  addLayersControl(baseGroups = c("OSM", "Carto", "Esri"), 
                   overlayGroups = c("Public", "Private", "For-Profit", "Wealthy Zip Codes"))

final_map

htmlwidgets::saveWidget(final_map, file = "final_map.html")

# Learning more about 'leaflet'

# RStudio's leaflet website: https://rstudio.github.io/leaflet/
# Leaflet extras: https://github.com/bhaskarv/leaflet.extras
# JavaScript library: http://leafletjs.com