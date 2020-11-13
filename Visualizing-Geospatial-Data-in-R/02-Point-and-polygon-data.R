# --------------------------------------------------- 
# Visualizing Geospatial Data in R - Point and polygon data 
# 13 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Introducing sp objects  -------------------------------------------
# Let's take a look at a spatial object
# Load data
countries_sp <- readRDS('Datasets/02_countries_sp.rds')

# Load packages
library(sp)

# Print countries_sp
print(countries_sp)

# Call summary() on countries_sp
summary(countries_sp)

# Call plot() on countries_sp
plot(countries_sp)

# What's inside a spatial object?
# Call str() on countries_sp
str(countries_sp)

# Call str() on countries_sp with max.level = 2
str(countries_sp, max.level = 2)

# A more complicated spatial object
# Load data
countries_spdf <- readRDS('Datasets/02_countries_spdf.rds')

# Call summary() on countries_spdf and countries_sp
summary(countries_sp)
summary(countries_spdf)

# Call str() with max.level = 2 on countries_spdf
str(countries_spdf, max.level = 2)

# Plot countries_spdf
plot(countries_spdf)

# Walking the hierarchy
# 169th element of countries_spdf@polygons: one
one <- countries_spdf@polygons[[169]]

# Print one
print(one)

# Call summary() on one
summary(one)

# Call str() on one with max.level = 2
str(one, max.level = 2)

# Further down the rabbit hole
# str() with max.level = 2, on the Polygons slot of one
str(one@Polygons, max.level = 2)

# str() with max.level = 2, on the 6th element of the one@Polygons
str(one@Polygons[[6]], max.level = 2)

# Call plot on the coords slot of 6th element of one@Polygons
plot(one@Polygons[[6]]@coords)

# More sp classes and methods  -------------------------------------------
# Subset the 169th object of countries_spdf: usa
usa <- countries_spdf[169, ]

# Look at summary() of usa
summary(usa)

# Look at str() of usa
str(usa, max.level = 2)

# Call plot() on usa
plot(usa)

# Accessing data in sp objects
# Call head() and str() on the data slot of countries_spdf
head(countries_spdf@data)
str(countries_spdf@data)

# Pull out the name column using $
countries_spdf$name == 'Brazil'

# Pull out the subregion column using [[
countries_spdf[['subregion']]

# Subsetting based on data attributes
# Create logical vector: is_nz
is_nz <- countries_spdf$name == 'New Zealand'

# Subset countries_spdf using is_nz: nz
nz <- countries_spdf[is_nz, ]

# Plot nz
plot(nz)

# tmap, a package that works with sp objects
library(sp)
library(tmap)

# Use qtm() to create a choropleth map of gdp
qtm(shp = countries_spdf, fill = 'gdp')

# Introduction to tmap  -------------------------------------------
# Building a plot in layers
tm_shape(countries_spdf) + 
  tm_fill(col = 'population') + 
  tm_borders()

# Add style argument to the tm_fill() call
tm_shape(countries_spdf) +
  tm_fill(col = "population", style = 'quantile') +
  # Add a tm_borders() layer 
  tm_borders(col = 'burlywood4')
  
  # New plot, with tm_bubbles() instead of tm_fill()
tm_shape(countries_spdf) +
  tm_bubbles(size = "population") +
  # Add a tm_bubbles() layer 
  tm_borders(col = 'burlywood4')

# Why is Greenland so big?
# Switch to a Hobo–Dyer projection
tm_shape(countries_spdf, projection = 54009) +
  tm_grid(n.x = 11, n.y = 11) +
  tm_fill(col = "population", style = "quantile")  +
  tm_borders(col = "burlywood4") 

# Switch to a Robinson projection
tm_shape(countries_spdf, projection = "+proj=robin") +
  tm_grid(n.x = 11, n.y = 11) +
  tm_fill(col = "population", style = "quantile")  +
  tm_borders(col = "burlywood4") 

# Add tm_style("classic") to your plot
tm_shape(countries_spdf, projection = "+proj=robin") +
  tm_grid(n.x = 11, n.y = 11) +
  tm_fill(col = "population", style = "quantile")  +
  tm_borders(col = "burlywood4") +
  tm_style('classic')

# Saving a tmap plot
# Plot from last exercise
population <- tm_shape(countries_spdf) +
  tm_grid(n.x = 11, n.y = 11) +
  tm_fill(col = "population", style = "quantile")  +
  tm_borders(col = "burlywood4")

# Save a static version "population.png"
tmap_save(tm = population, filename = "Datasets/population.png")

# Save an interactive version "population.html"
tmap_save(tm = population, filename = "Datasets/population.html")
