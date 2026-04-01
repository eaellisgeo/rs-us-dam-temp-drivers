___________________________________________________________________________________________________________________________________________________________________

This code was developed for "Drivers of dam-induced thermal changes in rivers" (Ellis et al.). 

The goal of this study is to examine the primary drivers of dam-induced river temperature changes and describe how the primary drivers vary seasonally. 
This is completed using conditional inference random forest models and variable importance assessments. 
Each folder listed below contains either Jupyter notebooks or R scripts used for this project.

___________________________________________________________________________________________________________________________________________________________________

**The repository is divided into the following folders:**

**0_Organize_Temp_Differences:**
This python code compiles the changes in river surface temperature downstream of large dams in the U.S. from 2013-2024. 

**1_Pull_Predictor_Var_Data:**
These python codes extract predictor variables for the models from Caravan, RTMA, Daymet, and GeoGlows. 

**2_Prepare_Tables_for_ML:**
These python codes are used to combine the temperature difference observations and collected predictor variables for training the machine learning models in R.

**3_Train_ML_Models:**
This R code (directly adapted from Wade et al. 2023) is used to train an annual and seasonal ML models, assess accuracy, and compute the variable importance values. 

**4_Analysis_and_Graphics:**
This python code is used to assess model outputs and to create the base images for the graphics. 
Manuscript Graphics are combined and edited for aesthetics in Adobe Illustrator. 

**CSVs_Data:**
This folder contains data inputs and examples for the scripts.  

___________________________________________________________________________________________________________________________________________________________________
For full details: Please refer to the Full_Project_Readme.txt
