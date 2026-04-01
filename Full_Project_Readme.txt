This code was developed for "Drivers of dam-induced thermal changes in rivers" (Ellis et al.). 

The goal of this study is to examine the primary drivers of dam-induced river temperature changes and describe how the primary drivers vary seasonally. 
This is completed using conditional inference random forest models and variable importance assessments. Each folder listed below contains either Jupyter notebooks or R scripts used for this project.
 These folders are labeled in the order of processing and contain corresponding Readme files with key information. 

_______________________________________________________________________________________________________________________________________________

The repository is divided into the following folders: 

0_Organize_Temp_Differences: 
This python code compiles the changes in river surface temperature downstream of large dams in the U.S. from 2013-2024. 
Temperatures were extracted from the Landsat 8 and 9 surface temperature product using methods outlined in (1). This folder's scripts are used to combine the data that has been snapped to obstructed SWORD centerline nodes, 
identifies the longitudinal river profiles meeting our criteria (observed points wider than 100m in width and profiles contain at least 1km of observations up and downstream observations within 10km of the dam), 
and calculates the mean downstream temperature difference. This is combined into a single dataframe to be used in a future step. 

1_Pull_Predictor_Var_Data: 
These python codes extract predictor variables for the models from Caravan(2), RTMA(3), Daymet(4), and GeoGlows(5). 

2_Prepare_Tables_for_ML: 
These python codes are used to combine the temperature difference observations at the dams with the collected predictor variables from the first two steps. 
This cleans up the data and makes it easier to read into R for training the machine learning models. Additionally, this defines the boundaries used to perform stratified sampling by basins 
and prevents the training and testing from becoming spatially biased. 

3_Train_ML_Models: 
This R code (directly adapted from (6)) is used to train an annual and seasonal ML models to predict downstream river temperature changes, assess model accuracy, and compute the variable importance values. 
The importance value outputs are used for the final analysis piece and creation of graphics. 

4_Analysis_and_Graphics: 
This python code is used to perform any analysis on the model outputs (importance values) and to create the base images for the graphics. 
Manuscript Graphics are combined and edited for aesthetics in Adobe Illustrator. 

CSVs_Data: 
This folder contains data inputs and examples for the scripts.  


________________________________________________________________________________________________________________________________________________

Citations & Data Locations: 
(1) Ellis et al. (In Revision). Satellite observations reveal widespread alteration of river thermal regimes by U.S. dams. Science Advances. GitHub for Code: https://github.com/eaellisgeo/rs-us-dam-temperatures

(2) Kratzert et al.(2023) Caravan - A global community dataset for large-sample hydrology. Sci Data 10, 61. https://doi.org/10.1038/s41597-023-01975-w

(3) RTMA: https://www.nco.ncep.noaa.gov/pmb/products/rtma/; https://developers.google.com/earth-engine/datasets/catalog/NOAA_NWS_RTMA

(4) Daymet: Daily Surface Weather Data on a 1-km Grid for North America, Version 4 R1 https://doi.org/10.3334/ORNLDAAC/2129

(5) GeoGlows: https://www.geoglows.org/

(6) Wade et al.(2023). Machine learning unravels controls on river water temperature regime dynamics. Journal of Hydrology 623, 129821. https://doi.org/10.1016/j.jhydrol.2023.129821
