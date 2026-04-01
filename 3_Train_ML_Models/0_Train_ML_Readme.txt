Intro: 
This code is used to train conditional inference random forest models to predict dam-induced downstream river temperature changes. 
These scripts are set up to tune and run annual and seasonal (winter, spring, summer, and fall) models on Landsat-derived temperature changes in R. 
This code is adapted from Wade et al. (1). The steps should be run in chronological order. 
________________________________________________________________________________________________________________________________________________
Step 1.1: Annual --- Model Tuning

File(s): Ann_RF_Hyperparameter_Tuning_Func.R; Ann_RF_Hyperparameter_Tuning_Runs.R

Function Inputs: "Temp_Change_Attributes_All.csv" (from Prepare_ML_Data_Tables__for_RF); "Dam_Basin_Stratified_Sampling.csv" (from Prepare_ML_Data_StratifiedBasins)

Run Inputs: "RF_Hyperparameter_Tuning_Func.R" (Function Source Path); Specify output filepaths (error metrics)

Outputs: "mtry_oob_annual.csv"; "mtry_test_annual.csv"; "mtry_train_annual.csv" -- Error Metrics for Tuning
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Step 1.2: Annual --- Model Run

File(s): Ann_RF_Func.R; Ann_RF_Runs.R

Function Inputs: "Temp_Change_Attributes_All.csv" (from Prepare_ML_Data_Tables__for_RF); "Dam_Basin_Stratified_Sampling.csv" (from Prepare_ML_Data_StratifiedBasins); 
Output file path for list of dams used; mtry value from hyperparameter tuning

Run Inputs: "Ann_RF_Func.R" (Function Source Path); Specify output filepaths (crf, importance values, error metrics)

Outputs: "Dams_Used_Annual.csv"; "crf_annual.rds"; "all_annual_error.csv";  "cv1_annual_error.csv"; "Annual_Importance_Results.csv"
________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________
Step 2.1: Seasonal --- Model Tuning

File(s): Seas_RF_Hyperparameter_Tuning_Func.R; Seas_RF_Hyperparameter_Tuning_Runs.R

Function Inputs: "Temp_Change_Attributes_All.csv" (from Prepare_ML_Data_Tables__for_RF); "Dam_Basin_Stratified_Sampling.csv" (from Prepare_ML_Data_StratifiedBasins)

Run Inputs: "Seas_RF_Hyperparameter_Tuning_Func.R" (Function Source Path); Specify output filepaths (error metrics)

Outputs: "mtry_oob_seas.csv"; "mtry_test_seas.csv"; "mtry_train_seas.csv" -- Error Metrics for Tuning
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Step 2.2: Seasonal --- Model Run

File(s): Seas_RF_Func.R; Seas_RF_Runs.R

Function Inputs: "Temp_Change_Attributes_All.csv" (from Prepare_ML_Data_Tables__for_RF); "Dam_Basin_Stratified_Sampling.csv" (from Prepare_ML_Data_StratifiedBasins); 
Output file path for list of dams used; mtry value from hyperparameter tuning

Run Inputs: "Seas_RF_Func.R" (Function Source Path); Specify output filepaths (crf, importance values, error metrics)

Outputs: "Dams_winter.csv"; "Dams_spring.csv"; "Dams_summer.csv"; "Dams_fall.csv" -- CSVs of dams used in models
"crf_winter.rds"; "crf_spring.rds"; "crf_summer.rds"; "crs_fall.rds"; "all_season_error.csv"; "cv1_season_error.csv"; 
"winter_importance_results.csv"; "spring_importance_results.csv"; summer_importance_results.csv"; "fall_importance_results.csv"

________________________________________________________________________________________________________________________________________________
Notes:
For tuning, the "X_RF_func_hyperparameter_tuning.R" scripts are the base functions used to tune the mtry hyperparameter. 
These functions are run using the "X_RF_Hyperparameter_Tuning_Runs.R" scripts. They will output error metrics to the hyperparameter_tuning folders. 

For running the models, the "X_RF_Func.R" scripts are a base function to spatially stratify the sampling, define a training/test split, fit the random forest models, and 
export the conditional permutation importance results. (Samples of these results can be found within the CSVs_Data folder). The models are exceuted  and ouputs are exported 
by running the "X_RF_func.R" scripts.

Outputs contain information 
"all_annual_error.csv" and "all_season_error.csv" provide the mean and standard deviation of error of all five cross-validation sets.
"cv1_X_error.csv" files are the error metrics for the first cross-validation set, which is used to calculate variable importance.
For this project, we are primarily focused on the importance values. So, we draw on the CV1 errors for our discussions. 

________________________________________________________________________________________________________________________________________________

Citations:  
(1)  J. Wade, C. Kelleher, D. M. Hannah, Machine learning unravels controls on river water temperature regime dynamics. Journal of Hydrology 623, 129821 (2023).
GitHub Repository: https://github.com/jswade/stream-temperature-rf