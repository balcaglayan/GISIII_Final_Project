#GIS III Final Project

#Understanding Changes in Settlement Patterns in the Konya Plain from 
#the Early Bronze Age to the Iron Age: A Visual Perspective

#by Caglayan Bal

#June 5, 2022



#libraries
library(tmap)
library(sf)
library(dplyr)
library(rgdal)
library(raster)
library(tidyverse)
library(ggmap)
library(ggplot2)
library(stringr)
library(RColorBrewer)


##############################
#Reading the site distribution data:
settlement_raw <- readOGR("~/Desktop/Final Project/Data/Ca_sites_271021.shp") %>%
  st_as_sf()

plot(settlement_raw)

#Data wrangling and cleaning:
#Get rid of unnecessary columns:
settlement_all <- select(settlement_raw, -Core_study, -EBA, -EBI_II, -EBIII, 
                         -MBA, -LBA, -Iron, -EIA_MIA, -LIA, -References)

#Choosing the maximum extent of each site, if a site is occupied in mutliple
#subphases such as EBA I, II, III and adding a column showing the maximum size.
#EBA:
settlement_all$EBA_ha <- pmax(settlement_all$EBA_ha, settlement_all$EBI_II_ha,
                              settlement_all$EBIII_ha)

View(settlement_all)

#IA:
settlement_all$IA_ha <- pmax(settlement_all$Iron_ha, settlement_all$EIA_MIA_ha,
                             settlement_all$LIA_ha)

View(settlement_all)

#Getting rid of unnecessary columns:
settlement_all <- select(settlement_all, -EBI_II_ha, -EBIII_ha, -Iron_ha, 
                         -EIA_MIA_ha, -LIA_ha)
View(settlement_all)

#Changing the names of the columns:
names(settlement_all)[names(settlement_all) == "EBA_ha"] <- "EBA"
names(settlement_all)[names(settlement_all) == "MBA_ha"] <- "MBA"
names(settlement_all)[names(settlement_all) == "LBA_ha"] <- "LBA"
names(settlement_all)[names(settlement_all) == "IA_ha"] <- "IA"

View(settlement_all)

#Tidying the data regarding the period and size:
settlement_all <- settlement_all %>%
  gather(Period, Size_ha, EBA, MBA, LBA, IA)

View(settlement_all)

#Excluding the sites with no size information through all the periods:
settlement_all = settlement_all[settlement_all$Size != "0", ]

View(settlement_all)


##############################
#Reading the DEM:
DEM = raster("~/Desktop/Final Project/Data/DEM.tif")

plot(DEM)


##############################
#Reading the city and town boundaries:

city_boundaries <- readOGR("~/Desktop/Final Project/KonyaAksarayKaraman/KonAkKara.shp") %>%
  st_as_sf()

plot(city_boundaries)


town_boundaries <- readOGR("~/Desktop/Final Project/Ilceler/KonAkKa_Ilce.shp") %>%
  st_as_sf()

plot(town_boundaries)


#Standardizing the crs:
#Getting the crs of the site distirbution data:
newCRS = crs(settlement_all)

city_boundaries <- st_transform(city_boundaries, newCRS)

town_boundaries <- st_transform(town_boundaries, newCRS)



##############################
#Objective 1: Statistical Analyses
#############################

#Intersecting the settlements with city boundaries:
sites_by_city = st_intersection(settlement_all, city_boundaries)

count_by_city = sites_by_city %>%
  group_by(adm1_en) %>%
  count()

View(count_by_city)


#Intersecting the settlements with town boundaries:
sites_by_town = st_intersection(settlement_all, town_boundaries)

count_by_town = sites_by_town %>%
  group_by(adm2_en) %>%
  count()

View(count_by_town)


##############################
#Objective 2: A Faceted Map showing the sites against the elevation
#############################
tmap_mode("plot")       #For static maps

tm_shape(DEM) +
  tm_raster(pal = "YlGn", n= 4, alpha = 0.8) +
  tm_shape(settlement_all, unit = "m") +
  tm_dots(size = 0.05, col = "red") +
  tm_compass(position = c("left", "top"), size = 0.1) +
  tm_scale_bar(position = c("left", "top"), width = 0.2) +
  tm_symbols(col = "black", border.col = "white", size = 0.1) +
  tm_facets(by = "Period", nrow = 2, free.coords = FALSE)



##############################
#Objective 3: Heatmaps representing the shifts in settlement period through time
#############################

#Creating separate columns for X and Y from the geometry column
settlement_heatmap <- settlement_all %>% 
  mutate(x = unlist(map(settlement_all$geometry,1)),
         y = unlist(map(settlement_all$geometry,2)))

View(settlement_heatmap)


#Plot Scatterplot
ggplot() +
  geom_point(data = settlement_heatmap[settlement_heatmap$Period == "EBA", ], 
             aes(x = x, y = y), alpha = .05, colour = "red") +
  geom_point(data = settlement_heatmap[settlement_heatmap$Period == "MBA", ], 
             aes(x = x, y = y), alpha = .05, colour = "yellow") +
  geom_point(data = settlement_heatmap[settlement_heatmap$Period == "LBA", ], 
             aes(x = x, y = y), alpha = .05, colour = "green") +
  geom_point(data = settlement_heatmap[settlement_heatmap$Period == "IA", ], 
             aes(x = x, y = y), alpha = .05, colour = "blue")


#The Konya Plain as a base map:
basemap_kp <- get_stamenmap(bbox = c(left = 31.497803, bottom = 36.756490, 
                                     right = 34.233398, top = 38.397644), 
                            zoom = 9, maptype = "terrain-background")
ggmap(basemap_kp)


#Heatmap for the EBA:
ggmap(basemap_kp) +
  stat_density2d(data = settlement_heatmap[settlement_heatmap$Period == "EBA", ]
                 , aes(x = x, y = y, fill = ..density..), geom = 'tile', 
                 contour = F, alpha = .5) + 
  scale_fill_gradientn(colours = rev(brewer.pal(7,"Spectral"))) +
  labs(title = str_c('Distribution of the EBA Sites'), 
       fill = str_c('Density of Sites')) 


#Heatmap for the MBA:
ggmap(basemap_kp) + 
  stat_density2d(data = settlement_heatmap[settlement_heatmap$Period == "MBA", ]
                 , aes(x = x, y = y, fill = ..density..), geom = 'tile', 
                 contour = F, alpha = .5) + 
  scale_fill_gradientn(colours = rev(brewer.pal(7,"Spectral"))) +
  labs(title = str_c('Distribution of the MBA Sites'), 
       fill = str_c('Density of Sites')) 


#Heatmap for the LBA:
ggmap(basemap_kp) + 
  stat_density2d(data = settlement_heatmap[settlement_heatmap$Period == "LBA", ]
                 , aes(x = x, y = y, fill = ..density..), geom = 'tile', 
                 contour = F, alpha = .5) + 
  scale_fill_gradientn(colours = rev(brewer.pal(7,"Spectral"))) +
  labs(title = str_c('Distribution of the LBA Sites'), 
       fill = str_c('Density of Sites')) 


#Heatmap for the IA:
ggmap(basemap_kp) + 
  stat_density2d(data = settlement_heatmap[settlement_heatmap$Period == "IA", ]
                 , aes(x = x, y = y, fill = ..density..), geom = 'tile', 
                 contour = F, alpha = .5) + 
  scale_fill_gradientn(colours = rev(brewer.pal(7,"Spectral"))) +
  labs(title = str_c('Distribution of the IA Sites'), 
       fill = str_c('Density of Sites')) 



##############################
#Objective 4: An interactive faceted map showing changes in site sizes through 
#time
#############################
tmap_mode("view")

tm_basemap(leaflet::providers$Stamen.TerrainBackground) + 
  tm_shape(settlement_all, unit = "m") +
  tm_dots(size = "Size_ha", col = "red") +
  tm_facets(by = "Period", nrow = 2, free.coords = FALSE)

