Intro: 
This section of python notebooks is used to compile all of the temperature data extracted from Google Earth Engine (GEE) with scripts from Ellis et al. (1). 
This was completed for the same inital set of dams used in this work. However, additional runs were completed to extend the time period for Landsat 8 and to include Landsat 9. 
My data was stored in several locations and needed to be combined into a single dataframe (Step 1). If the GEE outputs are all located in the same folder this script could be simplified.
In the CSVs_Data folder, I have included the output CSV file generated for all of my temperature changes used to train the ML models -- "Avg_Profile_Changes_Final.csv"
________________________________________________________________________________________________________________________________________________

Step 1: Code used to pull in  extracted river profiles, filter, clean, and combine them into a single dataframe

File: 1_Combine_All_Temp_Profile_Data.ipynb

Inputs: Study_Dams.shp; The file paths for GEE temperature exports snapped to SWORD nodes

Final Output: "Combined_Temps_Nodes.csv" --  A file of all the river temperatures snapped to all possible nodes. 

________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________

Step 2: Code used to pull in data, do intermediate processing, and organize the temperature profiles

File: 2_Prepare_ML_Data_Organize_Temps.ipynb

Inputs: Study_Dams.shp; NID_National_Data.csv;  "Combined_Temps_Nodes.csv" (From previous step output)

Intermediate Outputs: "Selected_Dams_Site_Info.csv"; "Avg_Profile_Change_Signif.csv"

Final Outputs: "Clean_Dams_Site_Info.csv"; "Usable_Profiles_List.csv"; "Avg_Profile_Changes_Final.csv"; "Study_Dams_Site_Info.csv"

________________________________________________________________________________________________________________________________________________

Note: The output of this script, "Usable_Profiles_List.csv" is used to identify the date of the profiles for Daymet and RTMA  data. 
This step must be completed before moving on to "2_Prepare_Tables_for_ML"

Citations: 
(1) Ellis et al.(In Revision). Satellite observations reveal widespread alteration of river thermal regimes by U.S. dams. Science Advances. 
GitHub for Code: https://github.com/eaellisgeo/rs-us-dam-temperatures