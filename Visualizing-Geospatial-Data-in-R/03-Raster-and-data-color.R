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
# Load packages
library(RColorBrewer)
library(viridisLite)

# View all palettes where they are grouped into sequential, qualitative and diverging
# palettes
display.brewer.all() 

# Get the hexadecimal code of colors in a palette
brewer.pal(n = 9, 'Blues')

# viridisLite offers alternative sequential palettes
viridis(n = 9)

# Adding a custom continuous color palette to ggplot2 plots
# Load data
pred <- readRDS("Datasets/01_corv_predicted_grid.rds")

# Load packages
library(RColorBrewer)

# 9 steps on the RColorBrewer "BuPu" palette: blups
blups <- brewer.pal(9, 'BuPu')

# Add scale_fill_gradientn() with the blups palette
ggplot(preds) +
  geom_tile(aes(lon, lat, fill = predicted_price), alpha = 0.8) +
  scale_fill_gradientn(colours = blups)

# Load packages
library(viridisLite)

# viridisLite viridis palette with 9 steps: vir
vir <- viridis(9)

# Add scale_fill_gradientn() with the vir palette
ggplot(preds) +
  geom_tile(aes(lon, lat, fill = predicted_price), alpha = 0.8)  +
  scale_fill_gradientn(colors = vir)

# mag: a viridisLite magma palette with 9 steps
mag <- magma(9)

# Add scale_fill_gradientn() with the mag palette
ggplot(preds) +
  geom_tile(aes(lon, lat, fill = predicted_price), alpha = 0.8)  +
  scale_fill_gradientn(colors = mag)
?scale_fill_distiller

# Custom palette in tmap
# Generate palettes from last time
# Load data
prop_by_age <- readRDS('Datasets/03-proportion-by-age.rds')

library(RColorBrewer)
blups <- brewer.pal(9, "BuPu")

library(viridisLite)
vir <- viridis(9)
mag <- magma(9)

# Use the blups palette
tm_shape(prop_by_age) +
  tm_raster("age_18_24", palette = blups) +
  tm_legend(position = c("right", "bottom"))

# Use the vir palette
tm_shape(prop_by_age) +
  tm_raster("age_18_24", palette = vir) +
  tm_legend(position = c("right", "bottom"))

# Use the mag palette but reverse the order
tm_shape(prop_by_age) +
  tm_raster("age_18_24", palette = rev(mag)) +
  tm_legend(position = c("right", "bottom"))

# More about color and scales  -------------------------------------------
# An interval scale example
mag <- viridisLite::magma(7)

library(classInt)

# Create 5 "pretty" breaks with classIntervals()
classIntervals(values(prop_by_age[['age_18_24']]), n = 5, style = 'pretty')

# Create 5 "quantile" breaks with classIntervals()
classIntervals(values(prop_by_age[['age_18_24']]), n = 5, style = 'quantile')

# Use 5 "quantile" breaks in tm_raster()
tm_shape(prop_by_age) +
  tm_raster(col = "age_18_24", palette = mag, n = 5, style = 'quantile') +
  tm_legend(position = c("right", "bottom")) +
  tm_facets(NULL)

# Create histogram of proportions
hist(values(prop_by_age[['age_18_24']]))

# Use fixed breaks in tm_raster()
tm_shape(prop_by_age) +
  tm_raster("age_18_24", palette = mag,
            style = "fixed", breaks = c(0.025, 0.05, 0.1, 0.2, 0.25, 0.3, 1)) +
  tm_facets(as.layers = TRUE)

# Save your plot to "prop_18-24.html"
tmap_save(tm_shape(prop_by_age) +
            tm_raster("age_18_24", palette = mag,
                      style = "fixed", breaks = c(0.025, 0.05, 0.1, 0.2, 0.25, 0.3, 1)) +
            tm_facets(as.layers = TRUE), 
          filename = "Datasets/prop_18_24.html")

# A diverging scale example
# Load data
migration <- readRDS('Datasets/03_migration.rds')
# The net number of people who have moved into each cell of the raster between the
# years 1990 and 2000
tm_shape(migration) +
  tm_raster() +
  tm_legend(outside = TRUE, 
            outside.position = c("bottom"))

# Print migration
print(migration)

# Diverging "RdGy" palette
red_gray <- brewer.pal(n = 7, name = "RdGy")

# Use red_gray as the palette 
tm_shape(migration) +
  tm_raster(palette = red_gray) +
  tm_legend(outside = TRUE, outside.position = c("bottom"))

# Add fixed breaks 
tm_shape(migration) +
  tm_raster(palette = red_gray, 
            style = 'fixed',
            breaks = c(-5e6, -5e3, -5e2, -5e1, 5e1, 5e2, 5e3, 5e6)) +
  tm_legend(outside = TRUE, outside.position = c("bottom"))

# A qualitative example
# Load data
data(land)

library(raster)

# Plot land_cover
tm_shape(land) + 
  tm_raster() +
  tm_facets(as.layers = TRUE)

# Palette like the ggplot2 default
hcl_cols <- hcl(h = seq(15, 375, length = 9), 
                c = 100, l = 65)[-9]

# Use hcl_cols as the palette
tm_shape(land) + 
  tm_raster(palette = hcl_cols) +
  tm_facets(as.layers = TRUE)

# Examine levels of land_cover
levels(land_cover)

# A set of intuitive colors
intuitive_cols <- c(
  "darkgreen",
  "darkolivegreen4",
  "goldenrod2",
  "seagreen",
  "wheat",
  "slategrey",
  "white",
  "lightskyblue1"
)

# Use intuitive_cols as palette
tm_shape(land) + 
  tm_raster(palette = intuitive_cols) + 
  tm_legend(position = c("left", "bottom"))

