Intro: 
This section of python notebooks is used to pull the predictor variables used for the machine learning models. 
Some notebooks (e.g., Daymet, RTMA) may take a while to run, and it can be faster to split the processes across several copies of the notebooks. 
________________________________________________________________________________________________________________________________________________

Step 1: RTMA (Wind) -- This code is used to pull the wind predictor variable data for all profiles

File: 1_Pull_RTMA.ipynb

Inputs:  Obstructed_Nodes_Base_Clean.shp (as a GEE asset);  Study_Dams.shp ; Usable_Profiles_List.csv (Output of Section 0, Step 2)

Outputs: "RTMA_Data_P1.csv" (If run in parts, files will end in _P#)

________________________________________________________________________________________________________________________________________________

Step 2: Daymet (Daily Max Temp, Shortwave Radiation, Vapor Pressure) -- This code is used to pull meteorological predictor variable data for all profiles

File: 1_Pull_Daymet.ipynb

Inputs:  Obstructed_Nodes_Base_Clean.shp (as a GEE asset); Study_Dams.shp ; Usable_Profiles_List.csv (Output of Section 0, Step 2)

Outputs: "Daymet_P1.csv" (If run in parts, files will end in _P#)
________________________________________________________________________________________________________________________________________________

Step 3: GeoGlows (River Discharge) -- This code is used to pull river discharge data from Geoglows for the reaches surrounding study area dams

File: 1_Pull_GeoGlows.ipynb

Inputs: A file path for the downloaded geopackages of GeoGlows data (1);  Study_Dams.shp; Usable_Profiles_List.csv (Output of Section 0, Step 2)

Outputs: "QbyReach_All.csv"; "Avg_Q_by_Dam.csv"

________________________________________________________________________________________________________________________________________________
Step 4: Caravan (meteorological and climatological data) --- This step is run with very little to no modification from Kratzert et al. (2). 

For Part 1 (File: Caravan_part1_Earth_Engine.ipynb), no edits were made beyond inserting filepaths. This section was run in GEE via Google Colab. This file is not included in this GitHub repository.
Part 1 Inputs: Basins_of_Interest_Hydro7.shp (uploaded to GEE as an Asset); File outputs and prefixes; Study times

For Part2 (File: Caravan_part2_local_postprocessing.ipynb), few edits were made beyond inserting filepaths. This section was run locally. 
A copy of this file is included for reference, noted by "_Ellis_etal". Comments inserted throughout  to note where I have inserted Updates.

Part 2 Inputs: Basin_Centroids_Hydro7.shp (Caravan requires a "gauge" point for each basin. I created a centroid in ArcGIS for each HydroBasin)

Outputs: "attributes_caravan_Dams_HA_Hydro7.csv"; "attributes_hydroatlas_Dams_HA_Hydro7.csv"; "attributes_other_Dams_HA_Hydro7.csv"

________________________________________________________________________________________________________________________________________________

Note:
Outputs from each step in this section will be combined into one dataset for ML training in the following section. 

________________________________________________________________________________________________________________________________________________

Citations & Data locations:  

(1) To locate the IDs of the stream lines I needed from GeoGlows, I downloaded data (from: https://www.geoglows.org/pages/data) via the AWS link. 
I downloaded the stream gpkgs from here: http://geoglows-v2.s3-website-us-west-2.amazonaws.com/ (hydrography > vpu > streams_)

(2)  Kratzert, F., Nearing, G., Addor, N., Erickson, T., Gauch, M., Gilon, O., et al. (2023). Caravan - A global community dataset for large-sample hydrology. Scientific Data, 10(1), 61. https://doi.org/10.1038/s41597-023-01975-w
GitHub: https://github.com/kratzert/Caravan/tree/main/code
