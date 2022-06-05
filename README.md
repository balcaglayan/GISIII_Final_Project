# GISIII_Final_Project

# Understanding Changes in Settlement Patterns in the Konya Plain from the Early Bronze Age to the Iron Age: A Visual Perspective
## Author: Caglayan Bal
## Date: June 5, 2022
## Introduction
Since its first introduction in early 1980, the use of GIScience in archaeological studies has become more and more common (Verhagen 2017, 11). It has become an integrated part of archaeological surveys, in which new and already known archaeological sites are visited and recorded based on the analysis of materials collected on the surface. Various GIScience applications help archaeologists to map new and already known archaeological sites and to locate new ones (cf. Nsanziyera et al. 2018) as well as let them do site-level analysis (cf. Wilkinson, Ur, and Casana, 2004, Fig. 14). \
\
Over the past decade, archeological survey teams working in Turkey have shifted their methodologies in the favor of GIScience applications (cf. Summers and Summers 2010; KRASPb 2018). In particular, it provides valuable insights into past human behaviors through changes in settlement patterns that point to major social, economic, and political changes due to multiple reasons such as climatic change and environmental degradation (cf. Massa and Şahoğlu 2015), shifts in economic interests (cf. Wilkinson et al. 2014) and appearance of large territorial polities (Massa et al. 2020). \
\
This project aims at providing an understanding of changes in settlement patterns in the Konya Plain, central Anatolia (Figure 1), covering a period from the Early Bronze Age (EBA, ca. 3200-1950 BCE), Middle Bronze Age (MBA, ca. 1950-1650 BCE), Late Bronze Age (LBA, ca. 1650-1200 BCE) to the Iron Age (IA, 1200-300 BCE) through a comparison of multiple static and interactive maps coupled with some statistical analysis. I use an integrated dataset including the archaeological survey data, city and town boundaries covering the Konya Plain, and the Digital Elevation Model (DEM) of the region.\
\
![Test Image 1](https://github.com/balcaglayan/GISIII_Final_Project/blob/main/Other%20Visuals/Konya_Plain_Sites.png)
 
Figure 1. Map showing the EBA-IA sites in the Konya Plain in central Anatolia. 
## Background and Motivation
The Konya Plain, central Anatolia, has been investigated by numerous archaeological surveys and excavation projects since the 1950s. The information on the spatial and temporal distribution of sites in the region has been revealed by the survey projects of Mellaart (1954), French (2014), Güneri (1989), Bahar (2014), Baird (2001), and recently, Bachhuber and Massa (Bachhuber and Massa 2017; 2018; Massa et al. 2020; Konya Regional Archaeological Survey Project [KRASP] of which I am a team member). Therefore, it provides a perfect area to explore long-term changes in settlement patterns and associated social, economic, and political transformations in past societies.\
\
Several analyses of changes in settlement patterns in the Konya Plain have been performed and the results have been conveyed through several maps (cf. Massa et al. 2020, Fig. 4, Fig. 7; KRASPa 2018, Figure 1). However, they are all static maps that do not allow the user to interact with maps and explore them from different perspectives. Besides, they are all sorts of simplified maps to overcome the challenges of static maps in the representation of the data.\
\
The Anatolian Atlas by the Center for Ancient Middle Eastern Landscapes (CAMEL) of the Oriental Institute at the University of Chicago represents a unique example with its attempt to collect the available survey data in Anatolia and presents them on an interactive map (CAMEL, n.d.).  However, it only provides an overview of the available survey data in Anatolia and seems to serve as a database. \
\
Being inspired by the work of KRASP and CAMEL, I want to expand their efforts with several maps in this project. 
## Goals and Objectives
The main goal of this project is to provide a better understanding of changes in settlements patterns in the Konya Plain from the EBA to the end of the IA by creating several maps both static and interactive and performing some statistical analyses in R. The main objectives are:
1.	Performing statistical analyses to show the distribution of archaeological sites in the Konya Plain extending three different cities and multiple towns;
2.	Creating a faceted map to show changes in site distribution in relation to the elevation from the EBA to the IA;
3.	Creating heatmaps to show changes in site distribution from the EBA to the IA separately for a better understanding of shifts in the patterns;
4.	Creating an interactive map to show changes in site distribution accompanied by changes in settlement size from the EBA to the IA.
## Data Sources, Spatial and Temporal Scale
This project uses multiple datasets:
1.	The archaeological survey data was acquired from the KRASP Archive through personal communication with Dr. Massa. The data includes site name, occupation period, site size, and geographical coordinates in WGS84.
2.	The DEM map, ASTER Global DEM Data, of the study area was downloaded from USGS EarthExplorer, https://earthexplorer.usgs.gov. 
3.	The city and town boundaries of Turkey were collected from the Humanitarian Data Exchange, https://data.humdata.org/dataset/cod-ab-tur.
The spatial extent of the project is limited to the Konya Plain in central Anatolia, Turkey (Figure 1). The temporal extent covers a ca. 3000-year period, from the EBA (ca. 3200-1950 BCE) to the end of the IA (ca. 1200-300 BCE).
## Methods
I began with data wrangling and cleaning. The settlement data is originally a shapefile with an associated attribute table and was not useful for my analysis (Figure 2). What I needed for my analysis is a table with columns of “Name (name of the sites)”, “Morphology (settlement type)” “Period (EBA, MBA, LBA, IA)”, “Size_ha (extent of sites in hectare)”, and “geometry.” I read the shapefile with the readOGR() function and converted it to an sf object by the st_as_sf() function. Then, I got rid of unnecessary columns with the select() function. For two periods, namely EBA and IA, the size of the sites was recorded in each subphase such as EBA II and III and Late IA. Since my aim in this project is to compare changes in settlement patterns during the EBA, MBA, LBA, and IA, I did not need the subphase-specific information. Therefore, I decided to assign the maximum extent of a site in all the subphases. For example, I specified the maximum value of site sizes \during the EBA I, II, and III, as its size for the entire EBA. To do that, I created two columns namely EBA_ha and IA_ha, and assigned the maximum values by using the pmax() function. After that, I excluded the columns with subphase-specific information with the select() function. I changed the names of the columns by using the names() function from EBA_ha to EBA, from MBA_ha to MBA, from LBA_ha to LBA, and from IA_ha to IA. Finally, I tidied the period and size data by using the gather() under two new columns called Period and Size and excluded all the sites with a size of 0 ha by subsetting the data. Figure 3 shows the final data table that I use in my project.\
\
![Test Image 2](https://github.com/balcaglayan/GISIII_Final_Project/blob/main/Other%20Visuals/Table_raw.png)
 
Figure 2. A screenshot of the raw data table showing the columns and corresponding values.

![Test Image 3](https://github.com/balcaglayan/GISIII_Final_Project/blob/main/Other%20Visuals/Table_final.png)

Figure 3. A screenshot of the final data table showing the columns and corresponding values.

As for the DEM data, the Konya Plain was covered by four DEM files that I downloaded from USGS EarthExplorer. I merged them into one DEM file in QGIS through Processing > Toolbox > GDAL > Raster miscellaneous > Merge. After that, to reduce the data size, I clipped the final DEM regarding the extent of the Konya Plain by Raster > Extraction > Clip Raster by Extent. Then I read the file with the raster() function in R. \
I downloaded the city and town boundaries of Turkey as a shapefile. The original data covers entire Turkey and I reduced the data to the Konya Plain, i.e., the cities of Konya, Aksaray, and Karaman and the towns within them. I performed it in QGIS by selecting polygons that I am interested in and I extracted and saved them as shapefiles. I read both data with the readOGR() function and converted them into sf objects by the st_as_sf() function in R. \
\
For analyses, I needed to standardize the CRS of the site distribution data and the city and town boundaries data. I created an object called newCRS by using the crs() function and by choosing the site distribution data as a reference. Then, I standardized the CRS of the city and town boundaries data by using the st_transform() function.
#### Objective 1
My first objective is to find the number of settlements in each city covering the Konya Plain, namely Konya, Karaman, and Aksaray, as well as in each town within these cities. I used the st_intersection() function to intersect the site distribution data and city boundaries and I grouped the data by city with the group_by() function and then, calculated the total number of sites in each city by the count() function. I did a similar computation with the town boundaries and this time, I grouped the data by town. 
#### Objective 2
My second objective is to show the relationship between the site distribution and the elevation in each period. To provide an easy comparison, I created a faceted map. I used the tm_shape() and tm_raster() functions for the DEM data and used the tm_shape() and tm_dots() for the site distribution data. I added a scale bar and a compass with the tm_scale_bar() and tm_compass() functions. Finally, I used the tm_facets() functions and created a faceted map by period. 
#### Objective 3
My third objective is to create heatmaps representing the shifts in settlement patterns through time. I began with creating separate columns for X and Y values by using the mutate() and unlist() functions. After that, to see the distribution of points, I used ggplot() and geom_point() functions to create a scatterplot. In these maps, I wanted to use the map of the Konya Plain as a base map and acquired it by using the get_stamenmap() function. Then, I created heatmaps by using the stat_density2d() function for each period separately and overlayed them with the map of the Konya Plain. 
#### Objective 4
My fourth objective is to show the changes in settlement sizes through time. I created a faceted interactive map that allows for easy comparison between periods. To create an interactive base map, I used the tm_basemap() function and the leaflet for acquiring the map. Then, I used the tm_shape() and tm_dots() functions to map the site distribution data. In the tm_dots() function I specified the size of the dost as “Size_ha”, the column of the data table showing the site sizes. 
## Results
#### Objective 1
Figure 4 shows the result of my statistical analysis. According to the results, Konya has the highest number of sites with 389 sites. Similarly, Çumra, Karaman, and Karatay, towns within Konya, have the highest number of sites. \
\
![Test Image 4]
 
Figure 4. Tables show the number of sites in each city (left) and each town (right).

These numbers are majorly a result of the geographic extent of the Konya Plain, the biggest part of it is located in Konya. On the other hand, this might be a result of deliberate choices of research teams for certain towns and areas. Each research teams get permission to do a survey mostly in one or two towns. The region has been investigated since the 1950s and the same towns have been investigated by multiple teams. For future studies, other towns can be preferred to improve our knowledge of the human past of the Konya Plain.
#### Objective 2
Figure 5 shows the faceted map representing changes in site distribution through time in relation to the elevation. The Konya Plain has a fairly flat surface. The prevailing elevation is between 1000 m and 1500 m and is accompanied by depressions and heights. The elevation preference seems to be consistence between 1000 m and 1500 m in every period, although a couple of settlements are situated in areas with an elevation of 1500-2000 m in the EBA and IA.
 
Figure 5. Map showing the distribution of sites in each period overlaid with the DEM map.
#### Objective 3
Figure 6 shows the heatmaps representing changes in settlement patterns from the EBA to the IA. Heatmaps provide a better understanding of the aggregation and dispersal of sites. During the EBA, there seem to be two distinct clustering points represented by red. The point in the north seems to be bigger which means more settlements are clustered there. In the MBA, the clustering point in the north becomes the only one and remains at the same location. The settlements seem to have expanded further to the north. In the LBA, the major cluster area seems to have shifted a little towards the northwest and looks denser than that of the MBA. The overall expansion of the sites seems to have remained the same. In the IA, the distribution of the sites seems to be more uniform around a center represented by red. New settlements seem to have been more pronounced in the northeastern part of the region.
 
Figure 6. Heatmaps show the changes in aggregation and dispersal of sites in each period.
#### Objective 4
Figure 7 shows a screenshot of the faceted interactive map that shows the changes in settlement patterns and changes in site sizes over time. This map allows the user to inspect each settlement during all the periods at once very easily. For example, Figure 7 specifically shows the changes in the size of Konya-Karahöyük from the EBA to the IA. In the EBA, it looks like one of the major centers in the region and seems to have become the only one in the MBA. When we look at the LBA map, however, the site seems to have been abandoned. In the IA, it reappears as a small settlement. A similar analysis can be done for all the settlements very quickly by moving the cursor over the sites on the map. 
 
Figure 7. Interactive faceted map showing the changes in site sizes through time. In this screenshot, the cursor is on Konya-Karahöyük on the MBA map and the settlement is marked by red circles on other maps.
## Discussion
The statistical analysis and different visualizations of the EBA-IA sites in the Konya Plain provide a new perspective on the understanding of long-term changes in settlement patterns. The statistical analysis is easy and simple in R. It helps us to see the number of sites in each city and town covering the Konya Plain. I briefly mentioned some of the possible reasons behind it above. These results can be considered for future studies.\
The maps created based on the site distribution data provide multiple perspectives regarding different variables such as elevation, habitation density, and site size. They seem to be all complementary to each other. The first faceted map shows the changes in elevation preference from the EBA to the IA. Since the study area is a plain, a comparison of the site distribution with the elevation is not very helpful to have new insights into the human past of the plain. However, it helps us to see the foundation of new settlements at higher elevations at certain times, namely EBA and IA.\
The heatmaps provide a better understanding of the aggregation and dispersal of sites in terms of occupation density in the plain. Clustering around a central area begins in the MBA when Anatolia maintained long-distance trade with the Assyrians (Michel 2011). It becomes denser in the LBA when central Anatolia was ruled by the Hittites who founded the first territorial empire in Anatolia (Seeher 2011).  We see a similar aggregation in the IA, representing the reemergence of centralized polities after the collapse of the Hittite Empire at the end of the LBA (for an overview see Kealhofer and Grave 2011; analysis for the Konya Plain see Massa et al. 2020), although it is less dense than in the LBA. These changes must have been closely related to changes in the broader social, economic, and political realms of the period.\
The faceted interactive map seems to agree with the results of the heatmaps. It shows us changes in site distribution and changes in site size over time at a regional and site scale. We can see the shifts in aggregation areas from the EBA to the MBA and later from the MBA to the LBA and IA. Based on the information on the faceted interactive map, the aggregations have occurred around a single settlement that must have been the regional center.  
## Conclusion
The aim of this project is to provide a better understanding of the long-term changes in settlement patterns in the Konya Plain from the EBA to the IA by using GIScience techniques, in particular, R. I performed a simple statistical analysis that shows the distribution of archaeological sites in each city and town covering the Konya Plain. Then, I produced several maps that give information on the subject from a different perspective and improve our knowledge.\
This project presents my first attempt to tackle the data in R and my preliminary findings. There are some limitations and challenges that should be considered in future studies. The elevation is only one variable that was significant for humans to decide where to settle. Other important variables include but are not limited to water sources, vegetation, and other valuable resources such as clay and metal. In this study, I only compared the site distribution with the elevation and since the region is plain, elevation does not contribute much to our understanding. Currently, there is no publicly available data on the water bodies and vegetation of the region. Therefore, I could not use them in this project, but in future studies, they can provide a much better understanding of changes in settlement patterns. \
Another limitation is related to the site distribution data, i.e., survey data. The data I use in this project is a result of the cumulative efforts of multiple teams from various decades. Each research project has its methodology and recording system and it sometimes leads to missing data and problems with the standardization of the data. For example, I had to exclude several sites from the dataset because they had no information regarding their size. In the future, the development and implementation of a common methodology and recording systems can improve the data and eventually, our understanding a lot. \
For this project, I aimed at understanding the changes between the EBA, MBA, LBA, and IA. Therefore, as I discussed above, I kind of simplified and reduced the size information for some periods and sites. Although it is small compared to other problems, it creates a bias in our understanding. In future studies, a more detailed analysis that includes subperiods can be done. \
In addition to the limitations and suggestions for future studies, this project has other aspects that can improve our understanding of the subject. Because of the time limit and for the purpose of the project, I did not compare my findings with the archaeological data, including pottery and architectural traditions and their distribution, that is material manifestations of changes in social, economic, and political structures of societies. In the future, such a comparison can greatly contribute to a better and multi-perspective understanding of the long-term human occupation in the Konya Plain. \
GIScience and in particular, R have great potential in the field of archaeology. Besides the opportunity for various geospatial analyses, R can help us to create data packages for archaeological survey and excavation data. With the permission of the research teams, the dataset that I use in this project can be turned into a R data package and can be shared with other researchers to be analyzed. Such data packages can be very helpful for the Ministry of Culture and Tourism which supervises all the archaeological research in Turkey. These data packages can be used and distributed by the ministry for various analyses. Moreover, an R package(s) that include significant and necessary functions for spatial analysis and map-making can be developed based on the need of researchers. \
In conclusion, GIScience has become a more significant and integrated part of archaeological research. Based on my experience in archaeology and my interest in GIScience applications, in this project, I attempt to provide a different understanding of long-term changes in settlement patterns from the EBA to the IA in the Konya Plain from a visual perspective. I suggest that interactive maps and geocomputations in R as I present in my project can provide a better understanding than static and simple interactive maps do. My project represents an attempt that tries to synthesize R applications and archaeological data. Although it currently provides some preliminary results, it shows how GIScience and R can improve our understanding of archaeological data. I believe that the use of R will become more common in archaeological studies in the future and will significantly contribute to our understanding of past human behaviors. \


# REFERENCES
Bachhuber, Christoph, and Michele Massa. “Emerging patterns on the Konya plain: the second season of KRASP.” Heritage Turkey 8 (2018): 37-38.\
\
Bachhuber, Christoph, and Michele Massa. “The first field season of the Konya Regional Archaeological Survey Project.” Heritage Turkey 7 (2017): 30-31. Accessed November 20, 2020, http://www.krasp.net/files/file/publlication/Bachhuber_and_Massa2017_KRASP_first_season_report_def.pdf. \
\
Bahar, Hasan. “Konya-Karaman İlleri ve İlçeleri Arkeolojik Yüzey Araştırmaları 2012.” In 31. Araştırma Sonuçları Toplantısı, edited by A. Özeme, 256-271. Muğla: Muğla Sıtkı Koçman Üniversitesi Basımevi, 2014. \
\
Baird, Douglas. “Settlement and Landscape in the Konya Plain, South Central Turkey, from the Epipalaeolithic to the Medieval Period.” In I. Uluslararası “Çatalhöyük’ten Günümüze Çumra” Kongresi, edited by Hakan Karpuz, Ali Baş, and Remzi Duran, 269–276. Konya: Çumra Belediyesi, 2001. \
\
CAMEL. “Anatolian Atlas.” https://oi.uchicago.edu/research/camel/anatolian-atlas. No date.
French, D. Roman Roads and Milestones of Asia Minor Vol. 3: Milestones, Fasc. 3,7: Cilicia, Isauria et Lycaonia (and South-West Galatia). London: British Institute at Ankara, 2014. \
\
Güneri, Semih. “Orta Anadolu Höyükleri, Karaman-Ereğli Araştırmaları.” Türk Arkeoloji Dergisi 28 (1989): 97–144.
Kealhofer, Lisa and Peter Grave. “The Iron Age on the Central Anatolian Plateau.” In The Oxford Handbook of Ancient Anatolia (10,000–323 BCE), edited by Gregory McMahon and Sharon Steadman, 415–42. Oxford: Oxford University Press, 2011. \
\
KRASPa. “Konya Regional Archaeological Survey Project.” 2018. http://www.krasp.net/en/ \
\
KRASPb. “Survey Methodology.” 2018. http://www.krasp.net/en/research-methodology/survey-methodology/ \
\
Massa, Michele, and Şahoğlu, Vasıf. “The 4.2 ka BP Climatic Event in West and Central Anatolia: Combining Palaeo-climatic Proxies and Archaeological Data.” In 2200 BC – A Climatic Breakdown as A Cause for the Collapse of the Old World?, edited by Herald Meller, Helge Wolfgang Arz, Reinhard Jung, and Roberto Risch, 61-78. Halle: Landesmuseum für Vorgeschichte, 2015. \
\
Massa, Michele, Christoph Bachhuber, Fatma Şahin, Hüseyin Erpehlivan, James Osborne, and Anthony J. Lauricella. “A Landscape-Oriented Approach to Urbanization and Early State Formation on the Konya and Karaman Plains, Turkey.” Anatolian Studies 70 (2020): 45-75. \
\
Mellaart, J. “Preliminary Report on a Survey of Pre-Classical Remains in Southern Turkey.” Anatolian Studies 4 (1954): 175–240. \
\
Michel, Cécile. “The Karum Period on the Plateau.” In The Oxford Handbook of Ancient Anatolia (10,000–323 BCE), edited by Gregory McMahon and Sharon Steadman, 313–36. Oxford: Oxford University Press, 2011. 
Nsanziyera, Ange Felix, Hassan Rhinane, Aicha Oujaa and Kenneth Mubea. 2018. “GIS and Remote-Sensing Application in Archaeological Site Mapping in the Awsard Area (Morocco).” Geosciences 8: 207. https://www.mdpi.com/2076-3263/8/6/207 \
\
Seeher, Jürgen. “The Plateau: The Hittites.” In The Oxford Handbook of Ancient Anatolia (10,000–323 BCE), edited by Gregory McMahon and Sharon Steadman, 376–92. Oxford: Oxford University Press, 2011. \
\
Summers, Geoffrey D., and Françoise Summers. “From Picks to Pixels: Eighty Years of Development in the Tools of Archaeological Exploration and Interpretation, 1927-2007, at Kerkenes Dağ in Central Turkey.” In Proceedings of the 6th International Congress on the Archaeology of the Ancient Near East, May 5th-10th 2008, “Sapienza” – Universita di Roma, edited by Paolo Matthiae, Frances Pinnock, Lorenzo Nigro, and Nicolo Marchetti, 669-683. Wiesbaden: Harrasowitz Verlag, 2010. \
\
USGS Earth Explorer. https://earthexplorer.usgs.gov \
\
Verhagen, Philips. 2017. “Spatial Analysis in Archaeology: Moving into New Territories”. In Digital Geoarchaeology: New Techniques for Interdisciplinary Human-Environmental Research, 11-25. Edited by Christoph Siart, Markus Forbriger and Olaf Bubenzer. Cham: Springer. \
\
Wilkinson, Tony James, Graham Philip, Jennie Bradbury, Rob Dunford, Danny Donoghue, Nikolaos Galiatsatos, Dan Lawrence, Andrea Ricci, and Stefan L. Smith. Contextualizing Early Urbanization: Settlement Cores, Early States and Agro-pastoral Strategies in the Fertile Crescent during the Fourth and Third Millennia BC. Journal of World Prehistory 27 (2014): 43-109. \
\
Wilkinson, Tony James, Jason Ur, and Jesse Casana. “From Nucleation to Dispersal: Trends in Settlement Pattern in the Northern Fertile Crescent.” In Side-by-Side Survey: Comparative Regional Studies in the Mediterranean World, edited by John Cherry and Susan Alcock, 198-205. Oxford: Oxbow Books, 2004. \
