This folder contains reference data files (zipped for GitHub size limits) used in the R and Python codes. All of these files can also be created, updated, or replaced in the notebooks as needed.


Files Included:

1. Study_Dams.shp -- Shapefile of all dams used as a starting point of analysis. Derived from GROD (1), has information from HILARRI (2), and Time Zone information.

2. NID_National_Data.csv -- CSV file with information about each dam in the United States (3)

3. Obstructed_Nodes_Base_Clean.shp -- Shapefile of the SWORD nodes identified and manually cleaned for a previous study (4). --- Will also need to be uploaded as a GEE asset

4. Basins_of_Interest_Hydro7.shp -- Shapefile of HydroBasin (Level 7) (5) that intersect with our dams and river profiles. 

5. Basin_Centroids_Hydro7.shp -- Shapefile of centroids for each HydroBasin (Caravan requires a "gauge" point for each basin. I created a centroid in ArcGIS for each basin of interest).

6. Basins_for_Stratified_Sampling.shp -- Shapefile of HydroBasin (Level 4) (5) that intersect with our usable dams and river profiles.

7. Dam_Reservoir_Check.csv -- Excel file of the dams with significant downstream differences that needed to be manually assessed for the presence of a reservoir. Completed in ArcGIS using imagery, NID, and SWORD nodes 

8. Physiographic_Regions.shp -- Shapefile of basic physiographic regions in the United States from the USGS(6)

9. NA_SWORD_reach_v16_gt100.shp -- Shapefile created from SWORD NA files. Filtered by width and to CONUS. Only used for visualization purposes

10. CONUS_Boundaries.shp -- Shapefile of CONUS boundaries used for visualization. 


________________________________________________________________________________________________________________________________________________
Generated Data Samples:

Usable_Profiles_List.csv --  An example of the output list of potential profiles meeting our width requirements (>100m) and number of nodes (>1km up- and downstream)

Avg_Profile_Changes_Final.csv -- An example of the output of observed downstream river temperature changes at large dams (Output of Section 0, Step 2)

RF_Model_Results -- A folder with results generated from the Annual and Seasonal RF models

________________________________________________________________________________________________________________________________________________
Citations & Information:

(1) Yang, X., Pavelsky, T. M., Ross, M. R. V., Januchowski-Hartley, S. R., Dolan, W., Altenau, E. H., et al. (2022). Mapping Flow-Obstructing Structures on Global Rivers. Water Resources Research, 58(1), e2021WR030386. https://doi.org/10.1029/2021WR030386
(2) Hansen, C., & Matson, P. (2023). Hydropower Infrastructure - LAkes, Reservoirs, and RIvers (HILARRI), V2 [Data set]. Oak Ridge National Laboratory (ORNL), Oak Ridge, TN (United States). https://doi.org/10.21951/HILARRI/1960141
(3) U.S Army Corps of Engineers (USACE). (2025). National Inventory of Dams [Data set]. Retrieved from https://nid.sec.usace.army.mil/nid/#/
(4) Ellis et al.(In Revision). Satellite observations reveal widespread alteration of river thermal regimes by U.S. dams. Science Advances. GitHub for Code: https://github.com/eaellisgeo/rs-us-dam-temperatures
(5) Lehner, B., Grill G. (2013). Global river hydrography and network routing: baseline data and new approaches to study the world’s large river systems. Hydrological Processes, 27(15): 2171–2186. https://doi.org/10.1002/hyp.9740
Data: North America, Level 7 (https://www.hydrosheds.org/products/hydrobasins) -- intersecting dam locations. 
(6) N. M. Fenneman, D. W. Johnson, Physiographic divisions of the conterminous U.S.: U.S. Geological Survey data release, (1946); https://doi.org/10.5066/P9B1S3K8.
