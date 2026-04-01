######  SEASONAL ###### 

# This script creates a function to tune random forest for the seasonal models, optimizing RF hyperparameters on 80% training set using stratified sampling by groups of basins

library(party)
library(caret)
library(dplyr)

# Create function for RF runs
# metric = string = 'Change'
# seas = string =  'winter', 'spring', 'summer', 'fall'  ---- [W: 12,,1,2, Sp: 3,4,5, Su: 6,7,8, F: 9, 10, 11]

rf_func_hyperparameter_tuning <- function(metric, season){
  
  ######### Read in the Data needed for RF models ######### 
  ### Directly Upstream to DS Comparisons -- Short Hand = DIR or DIRUP ###
  
  # Read in Downstream Changes
  DirUp <- read.csv("F:/Insert_File_Path/Temp_Change_Attributes_All.csv") ## Update file path here
  
  
  ###########################################################################  
  
  if (metric == "Change"){
    
    # Assemble data frame of rf Dir Up/DS input data, based on input month value
    rf_base_data <- data.frame(DirUp[,c(3:38)])
    rf_base_data$Month <- as.factor(rf_base_data$Month)
    rf_base_data$Sig_05 <- as.factor(rf_base_data$Sig_05)
    rf_base_data$Dam.purpose <- as.factor(rf_base_data$Dam.purpose)
    rf_base_data$Resv <- as.factor(rf_base_data$Resv)
    rf_base_data$Physiographic.Region <- as.factor(rf_base_data$Physiographic.Region)
    
    if (season == 'winter'){
      rf_data_f1 <- subset(rf_base_data, Month %in% c(12,1,2))
    } else if (season == 'spring'){
      rf_data_f1 <- subset(rf_base_data, Month %in% c(3,4,5))
    } else if (season == 'summer') {
      rf_data_f1 <- subset(rf_base_data, Month %in% c(6,7,8))
    } else if (season == 'fall'){
      rf_data_f1 <- subset(rf_base_data, Month %in% c(9,10,11))
    } else{
      print("Invalid Season Input")
    }
    
    # Drop the na values
    rf_data_f2 <- rf_data_f1 %>% drop_na()
    
    # Drop non-significant profiles
    rf_data_f3 <- rf_data_f2[rf_data_f2$Sig_05 == 'Significant',]
    
    ## Get the number of dams used
    print(paste("Number of dams:", n_distinct(rf_data_f3$Assgn_dam), sep = " "))
    
    # remove unneeded columns
    rf_data <- subset(rf_data_f3, select = -c(Assgn_dam,Sig_05))
    
    ## Get the number of profiles used
    print(paste("Number of profiles:", nrow(rf_data), sep = " "))
    
    # rename change column to match code
    names(rf_data)[names(rf_data) == 'Temp_Diff'] <- 'val'
    
    
    # Read in stratified groupings by HydroBasin -- want to use the correct number of dams
    strat_basin <- read.csv("F:/Insert_File_Path/Dam_Basin_Stratified_Sampling.csv") ## Update file path here
    
    # Want to filter the strat column based on available dams
    avail_seas_dams <- rf_data_f3 %>% drop_na()
    dams_list <- unique(avail_seas_dams$Assgn_dam)
    strat_basin_seas <- strat_basin %>% filter(DamID %in% dams_list)
    
    
  } else {
    
    # Return error message if incorrect input is supplied
    stop("Metric string not valid. Please use 'Change' ")
    
  }
  
  
  # Get length of data
  n_data <- dim(rf_data)[1]
  
  ## Generate random training and test set (80/20) stratified sampling,
  # Stratified sampling based on HydroBasin 4 Groupings, each training set and test set will have the same percentage of geographic regions
  set.seed(1)
  folds <- createFolds(factor(strat_basin_seas$Strat_Group), k = 5, list = FALSE, returnTrain = FALSE)
  
  # Training set will be folds != 1, Test set will be folds = 1
  traindf <- rf_data[which(folds != 1),]
  testdf <- rf_data[which(folds == 1),]
  
  # Subset HydroBasin by training set
  strat_basin_train = strat_basin_seas[which(folds != 1),]
  
  # Generate 5-fold stratified cross validation 
  set.seed(2)
  folds_train <- createFolds(factor(strat_basin_train$Strat_Group), k = 5, list = FALSE, returnTrain = FALSE)
  
  # Aggregate folds into 5 cv training sets
  cvtrain1 <- rf_data[which(folds != 1),]
  cvtrain2 <- rf_data[which(folds != 2),]
  cvtrain3 <- rf_data[which(folds != 3),]
  cvtrain4 <- rf_data[which(folds != 4),]
  cvtrain5 <- rf_data[which(folds != 5),]
  
  # Aggregate folds into 5 cv test sets
  cvtest1 <- rf_data[which(folds == 1),]
  cvtest2 <- rf_data[which(folds == 2),]
  cvtest3 <- rf_data[which(folds == 3),]
  cvtest4 <- rf_data[which(folds == 4),]
  cvtest5 <- rf_data[which(folds == 5),]
  
  # Aggregate train and test cv sets into lists
  cvtrain_list <- list(cvtrain1,cvtrain2, cvtrain3, cvtrain4, cvtrain5)
  cvtest_list <- list(cvtest1, cvtest2, cvtest3, cvtest4, cvtest5)
  
  
  # Create dataframe to store mse values for different mtry values (test and oob) 
  mtry_val <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)
  
  mtry_test <- data.frame(mtry_val = mtry_val, cv1 = rep(0,20), cv2 = rep(0,20), cv3 = rep(0,20), cv4 = rep(0,20), cv5 = rep(0,20))
  mtry_train  <- data.frame(mtry_val = mtry_val, cv1 = rep(0,20), cv2 = rep(0,20), cv3 = rep(0,20), cv4 = rep(0,20), cv5 = rep(0,20))
  mtry_oob <- data.frame(mtry_val = mtry_val, cv1 = rep(0,20), cv2 = rep(0,20), cv3 = rep(0,20), cv4 = rep(0,20), cv5 = rep(0,20))
  
  
  # Loop through mtry values, calculating rmse for 20 mtry scenarios on test set
  for (i in seq(1,20)){
    
    # Loop through cross-validation sets 
    for (j in seq(1,5)){
      
      # Assure same results are generated each time for each model
      set.seed(1)
      
      # Create random forest model, varying i in loop 
      crf_obj <- cforest(val ~ ., 
                         data=cvtrain_list[[j]],
                         controls = cforest_unbiased(ntree=1000,mtry=mtry_val[i]))
      
      # Predict rf test data
      crf_pred <-  predict(crf_obj,newdata=cvtest_list[[j]])
      crf_pred <- as.numeric(crf_pred)
      
      # Predict rf OOB
      crf_oob <- predict(crf_obj,OOB = TRUE)
      crf_oob <- as.numeric(crf_oob)
      
      # Predict rf training set directly
      crf_train <- predict(crf_obj, newdata=cvtrain_list[[j]])
      crf_train <- as.numeric(crf_train)
      
      # Access observed values of metric
      crf_obs <- cvtest_list[[j]]$val
      crf_obs_train <- cvtrain_list[[j]]$val
      
      # Calculate RMSE between sim and obs
      mtry_test[i,(j+1)] <- as.numeric(sqrt(mean((crf_pred-crf_obs)^2)))
      
      # Calculate RMSE OOB
      # Calculate RMSE between sim and obs
      mtry_oob[i,(j+1)] <- as.numeric(sqrt(mean((crf_oob-crf_obs_train)^2)))
      
      
      # Calculate RMSE of training set directly
      mtry_train[i,(j+1)] <- as.numeric(sqrt(mean((crf_train-crf_obs_train)^2)))
      
    }
  }
  
  # Calculate mean RMSE at each mtry val
  mtry_RMSE <- data.frame(mtry_val = mtry_val, RMSE_test = rowMeans(mtry_test[,-1]), RMSE_oob = rowMeans(mtry_oob[,-1]),RMSE_train = rowMeans(mtry_train[,-1]) )
  
  # Return function outputs
  return(mtry_RMSE)
  # 
  
}
