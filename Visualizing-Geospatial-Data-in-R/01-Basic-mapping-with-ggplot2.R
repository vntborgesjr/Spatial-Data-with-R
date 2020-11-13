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

# Useful get_map() and ggmap() options  -------------------------------------------
# Different maps
corvallis <- c(lon = -123.2620, lat = 44.5646)

# Add a maptype argument to get a satellite map
corvallis_map_sat <- get_map(corvallis, zoom = 13, maptype = 'satellite')


# Edit to display satellite map
ggmap(corvallis_map_sat) +
  geom_point(aes(lon, lat, color = year_built), data = sales)

# Add source and maptype to get toner map from Stamen Maps
corvallis_map_bw <- get_map(corvallis, zoom = 13, 
                            maptype = 'toner', source = 'stamen')

# Edit to display toner map
ggmap(corvallis_map_bw) +
  geom_point(aes(lon, lat, color = year_built), data = sales)

# Leveraging ggplot2's strengths
# Use base_layer argument to ggmap() to specify data and x, y mappings
ggmap(corvallis_map_bw, 
      base_layer = ggplot(data = sales, aes(x = lon, y = lat))) +
  geom_point(aes(color = year_built))

# Use base_layer argument to ggmap() and add facet_wrap()
ggmap(corvallis_map_bw, 
      base_layer = ggplot(data = sales, aes(x = lon, y = lat, color = class))) +
  geom_point(aes( color = class)) +
  facet_wrap(~ class)

# A quick alternative
# Plot house sales using qmplot()
qmplot(lon, lat, data = sales,
       geom = 'point', color = bedrooms) + facet_wrap(~ month)

# Common types of spatial data  -------------------------------------------
# Drawing polygons
ward_sales <- readRDS('Datasets/01_corv_wards.rds')

# Add a point layer with color mapped to ward
ggplot(ward_sales, aes(lon, lat)) +
  geom_point(aes(color = ward))

# Add a point layer with color mapped to group
ggplot(ward_sales, aes(lon, lat)) +
  geom_point(aes(color = group))

# Add a path layer with group mapped to group
ggplot(ward_sales, aes(lon, lat)) +
  geom_path(aes(group = group))

# Add a polygon layer with fill mapped to ward, and group to group
ggplot(ward_sales, aes(lon, lat)) +
  geom_polygon(aes(fill = ward, group = group))

# Choropleth map
# Fix the polygon cropping
ggmap(corvallis_map_bw, 
      base_layer = ggplot(ward_sales, aes(lon, lat)),
      extent = 'normal', maprange = FALSE) +
  geom_polygon(aes(group = group, fill = ward))

# Repeat, but map fill to num_sales
ggmap(corvallis_map_bw, 
      base_layer = ggplot(ward_sales, aes(lon, lat)),
      extent = "normal", maprange = FALSE) +
  geom_polygon(aes(group = group, fill = num_sales))

# Repeat again, but map fill to avg_price
ggmap(corvallis_map_bw, 
      base_layer = ggplot(ward_sales, aes(lon, lat)),
      extent = "normal", maprange = FALSE) +
  geom_polygon(aes(group = group, fill = avg_price), alpha = 0.8)

# An alternative to solve the cropping problem
qmplot(lon, lat, data = ward_sales, 
       geom = "polygon", group = group, fill = avg_price)

# Raster data as a heatmap
preds <- readRDS('Datasets/01_corv_predicted_grid.rds')
head(preds)

# Add a geom_point() layer
ggplot(preds, aes(lon, lat)) + 
  geom_point()

# Add a tile layer with fill mapped to predicted_price
ggplot(preds, aes(lon, lat)) +
  geom_tile(aes(fill = predicted_price))

# Use ggmap() instead of ggplot()
ggmap(corvallis_map_bw) +
  geom_tile(data = preds, aes(x = lon, y = lat, fill = predicted_price), alpha = 0.8)
  