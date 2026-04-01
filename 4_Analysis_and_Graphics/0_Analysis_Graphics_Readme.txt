Intro: 
This code is used to analyze the importance values created by the ML models and create the base graphics.
________________________________________________________________________________________________________________________________________________

File: 1_Analysis_and_Create_Graphics.ipynb

Inputs: "Final_Dam_List.csv" (from Prepare_ML_Data_Tables__for_RF); Study_Dams.shp;  NA_SWORD_reach_v16_gt100.shp; Obstructed_Nodes_Base_Clean.shp;
CONUS_Boundaries.shp; "Annual_Importance_Results.csv" (from ML outputs); "winter_importance_results.csv" (from ML outputs); 
"spring_importance_results.csv" (from ML outputs); "summer_importance_results.csv" (from ML outputs); "fall_importance_results.csv" (from ML outputs);
"Temp_Change_Attributes_All.csv" (from Prepare_ML_Data_Tables__for_RF); 

Outputs: "StudyArea.png"; "Annual_Ranks.csv"; "Seasonal_Ranks.csv"; "Annual_Rel_Importance_Category.pdf"; "Seasonal_Rel_Importance_Category.pdf"; 
"Annual_Dam_Ops_Rel_Imp.pdf"; "Seasonal_Dam_Ops_Rel_Imp.pdf"; "Seasonal_Temp_Diffs.pdf"

________________________________________________________________________________________________________________________________________________

Notes:
This code creates the elements for each graphic  in the manuscript. The graphics  found in the manuscript have been combine and edited to visuals in Adobe Illustrator.  