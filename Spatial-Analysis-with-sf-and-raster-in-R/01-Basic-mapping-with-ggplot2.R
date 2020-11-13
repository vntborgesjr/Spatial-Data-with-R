# --------------------------------------------------- 
# Visualizing Geospatial Data in R - Basic mapping with ggplot2 
# 12 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Introduction to spatial data  -------------------------------------------
library(ggmap)
corvallis <- c(lon = -123.2620, lat = 44.5646)

# Get map at zoom level 5: map_5
map_5 <- get_map(corvallis, zoom = 5, scale = 1)

# Plot map at zoom level 5
ggmap(map_5)

# Get map at zoom level 13: corvallis_map
corvallis_map <- get_map(corvallis, zoom = 13, scale = 1)

# Plot map at zoom level 13
ggmap(corvallis_map)

?ggmap
