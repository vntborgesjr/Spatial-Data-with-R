# --------------------------------------------------- 
# Visualizing Spatial Data in R - Raster data and color
# 13 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# The raster package  -------------------------------------------
# Load data
pop <- readRDS('Datasets/03-population.rds')

# Load packages
library(raster)

# Print pop
print(pop)

# Call str() on pop, with max.level = 2
str(pop, max.level = 2)

# Call summary on pop
summary(pop)

# Some useful methods
# Call plot() on pop
plot(pop)

# Call str() on values(pop)
str(values(pop))

# Call head() on values(pop)
head(values(pop))

# A more complicated object
# Load data
pop_by_age <- readRDS("Datasets/03-population-by-age.rds")

# Print pop_by_age
print(pop_by_age)

# Subset out the under_1 layer using [[
pop_by_age[["under_1"]]

# Plot the under_1 layer
plot(pop_by_age$under_1)

# A package that uses Raster objects
# Load packages
library(tmap)

# Specify pop as the shp and add a tm_raster() layer
tm_shape(shp = pop) +
  tm_raster()

# Plot the under_1 layer in pop_by_age
tm_shape(shp = pop_by_age) +
  tm_raster(col = 'under_1')

library(rasterVis)
# Call levelplot() on pop
levelplot(pop)

# Color scales  -------------------------------------------
