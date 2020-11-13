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

# Putting it all together
sales <- readRDS('Datasets/01_corv_sales.rds')
# Look at head() of sales
head(sales)

# Swap out call to ggplot() with call to ggmap()
ggmap(corvallis_map) +
  geom_point(aes(lon, lat), data = sales)

# Insight through aesthetics
# Map color to year_built
ggmap(corvallis_map) +
  geom_point(aes(lon, lat, color = year_built), data = sales)

# Map size to bedrooms
ggmap(corvallis_map) +
  geom_point(aes(lon, lat, size = bedrooms), data = sales)

# Map color to price / finished_squarefeet
ggmap(corvallis_map) +
  geom_point(aes(lon, lat, color = price / finished_squarefeet), data = sales)
