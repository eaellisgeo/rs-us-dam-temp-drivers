Intro: 
This set of notebooks is used to prepare and format the data to be used in the Random Forest ML models. It is composed of two steps. Step 1 compiles and formats the data. 
Step 2 sets up the breaks for stratified sampling by HydroBasins (1). This prevents spatial biases in the sampling/training stages of the ML. 
________________________________________________________________________________________________________________________________________________

Step 1: This code is used to pull in temperature profile mean differences, join with the predictor variables, export the tables for RF

File: 1_Prepare_ML_Data_Tables__for_RF.ipynb

Inputs: "Clean_Dams_Site_Info.csv" (from Prepare_ML_Data_Organize_Temps.ipynb); Dam_Reservoir_Check.csv; 
"Avg_Profile_Changes_Final.csv" (from _Prepare_ML_Data_Organize_Temps.ipynb); Obstructed_Nodes_Base_Clean.shp;  Basins_of_Interest_Hydro7.shp; 
"attributes_caravan_Dams_HA_Hydro7.csv" (Caravan); attributes_hydroatlas_Dams_HA_Hydro7.csv (Caravan); "attributes_other_Dams_HA_Hydro7.csv" (Caravan); Caravan Timeseries File Location; 
"Avg_Profile_Changes_Final.csv"(from Prepare_ML_Data_Organize_Temps.ipynb); "Combined_Temps_Nodes.csv" (from Combine_All_Temp_Profile_Data);
"RTMA_Data_P#.csv" (All outputs from pull); "Daymet_P#.csv" (All outputs from pull); "Avg_Q_by_Dam.csv"; Physiographic_Regions.shp; Study_Dams.shp

Intermediate Outputs: There are several intermediate outputs saved between steps for reference. 

Final Outputs: "Temp_Change_Attributes_All.csv"; "Final_Dam_List.csv"

________________________________________________________________________________________________________________________________________________

Step 2: This code is used to create the stratified sample groups (by location) to prevent bias. 

File: 2_Prepare_ML_Data_StratifiedBasins.ipynb

Inputs: "Final_Dam_List.csv" (previous step); Study_Dams.shp; Basins_for_Stratified_Sampling.shp; 

Outputs: "Dam_Basin_Stratified_Sampling_Percentages.csv"; "Dam_Basin_Stratified_Sampling.csv"
________________________________________________________________________________________________________________________________________________

Citations & Details:  
(1) Lehner, B., Grill G. (2013). Global river hydrography and network routing: baseline data and new approaches to study the world’s large river systems. Hydrological Processes, 27(15): 2171–2186. https://doi.org/10.1002/hyp.9740
Data: North America, Level 3 (https://www.hydrosheds.org/products/hydrobasins) -- intersecting dam locations. 
