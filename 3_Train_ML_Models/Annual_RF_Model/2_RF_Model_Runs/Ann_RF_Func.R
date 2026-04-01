###### ANNUAL ###### 

# Create function to run random forest 
# 80/20 Training Set using geographic stratified sampling by basin groups

library(party)
library(caret)
library(dplyr)

# Create function for RF runs
# metric = string = 'Annual' 

rf_func <- function(metric){
  
  ######### Read in the Data needed for RF models ######### 
  ### Directly Upstream to DS Comparisons -- Short Hand = DIR or DIRUP ###
  
  # Read in Downstream Changes
  DirUp <- read.csv("F:/Insert_File_Path/Temp_Change_Attributes_All.csv") ## Update file path here
  
  
  ###########################################################################  

  # If metric is for Annual
  if (metric == "Annual"){
    
    # Assemble data frame of rf Dir Up/DS input data, based on input season value
    rf_base_data <- data.frame(DirUp[,c(3:38)])
    
    ## Clean up columns
    rf_base_data$Month <- as.factor(rf_base_data$Month)
    rf_base_data$Sig_05 <- as.factor(rf_base_data$Sig_05)
    rf_base_data$Dam.purpose <- as.factor(rf_base_data$Dam.purpose)
    rf_base_data$Resv <- as.factor(rf_base_data$Resv)
    rf_base_data$Physiographic.Region <- as.factor(rf_base_data$Physiographic.Region)
    
    # Drop the na values
    rf_data_f2 <- rf_base_data %>% drop_na()
    
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
    avail_dams <- rf_data_f3 %>% drop_na()
    dams_list <- unique(avail_dams$Assgn_dam)
    strat_basin_ann <- strat_basin %>% filter(DamID %in% dams_list)
    
    # Save a file of which dams can be used each season
    ann_dams_filepath <- paste('F:/Insert_File_Path/RF_Model_Results/Dams_Used_','Annual','.csv',sep="") ## Update file path here
    write.csv(strat_basin_ann,ann_dams_filepath)
    
    
    # If another string is entered  
  } else {
    
    # Return error message if incorrect input is supplied
    stop("Metric string not valid. Please use 'Annual' ")
    
  }
  
  
  #### Perform random 5-fold sampling on HydroBasin (04) Subsets ####
  ## Generate training and test set (80/20) stratified sampling,
  # Stratified sampling based on HydroBasin 4 Groupings, each training set and test set will have the same percentage of geographic regions
  set.seed(1)
  folds <- createFolds(factor(strat_basin_ann$Strat_Group), k = 5, list = FALSE, returnTrain = FALSE)
  
  # Primary Training set will be folds != 1, Test set will be folds = 1
  # Aggregate folds into 5 cv training sets
  cvtrain1 <- rf_data[which(folds != 1),] # Primary Training set (Variable Importance)
  cvtrain2 <- rf_data[which(folds != 2),]
  cvtrain3 <- rf_data[which(folds != 3),]
  cvtrain4 <- rf_data[which(folds != 4),]
  cvtrain5 <- rf_data[which(folds != 5),]
  
  # Aggregate folds into 5 cv test sets
  cvtest1 <- rf_data[which(folds == 1),] # Primary Test set (Variable Importance)
  cvtest2 <- rf_data[which(folds == 2),]
  cvtest3 <- rf_data[which(folds == 3),]
  cvtest4 <- rf_data[which(folds == 4),]
  cvtest5 <- rf_data[which(folds == 5),]
  
  # Aggregate train and test cv sets into lists
  cvtrain_list <- list(cvtrain1,cvtrain2, cvtrain3, cvtrain4, cvtrain5)
  cvtest_list <- list(cvtest1, cvtest2, cvtest3, cvtest4, cvtest5)
  
  
  # Create dataframes to store error metrics
  test_err <- data.frame(test_R2 = rep(0,5),test_mean_bias = rep(0,5),test_rmse = rep(0,5), test_nrmse = rep(0,5))
  train_err <- data.frame(train_R2 = rep(0,5),train_mean_bias = rep(0,5),train_rmse = rep(0,5), train_nrmse = rep(0,5))
  oob_err <- data.frame(oob_R2 = rep(0,5), oob_mean_bias = rep(0,5),oob_rmse = rep(0,5), oob_nrmse = rep(0,5))
  
  # Create list to store crf_objs
  crf_list <- list()
  
  
  # Loop through each cv set (only calculate and store importance for cv1)
  for (i in seq(1,5)){
    
    # Assure same results are generated each time for each model
    set.seed(1)
    
    # Create random forest model 
    crf_obj <- cforest(val ~ ., 
                       data=cvtrain_list[[i]],
                       controls = cforest_unbiased(ntree=1000,mtry=10)) ## you can change mtry here
    
    # Add crf_obj to list (only export crf_obj corresponding to cv1)
    crf_list[[i]] <- crf_obj
    
    if(i == 1){ # Calculate variable importance for first training/test set (cv1)
      
      # Calculate variable conditional permutation importance (Mean Decrease in Accuracy)
      rf_import <- varimp(crf_obj, conditional=TRUE)
      rf_import <- as.data.frame(rf_import)
      names(rf_import) = c("MDA")
      
      # Set negative importance to 0
      rf_import$MDA[which(rf_import$MDA < 0)] <- 0
      
    }
    
    # Predict rf test data
    crf_pred_test <-  predict(crf_obj,newdata=cvtest_list[[i]])
    crf_pred_test <- as.numeric(crf_pred_test)
    
    # Predict rf OOB
    crf_pred_oob <- predict(crf_obj,OOB = TRUE)
    crf_pred_oob <- as.numeric(crf_pred_oob)
    
    # Predict rf training set directly
    crf_pred_train <- predict(crf_obj, newdata=cvtrain_list[[i]])
    crf_pred_train <- as.numeric(crf_pred_train)
    
    # Access observed values of metric
    crf_obs_test <- cvtest_list[[i]]$val
    crf_obs_train <- cvtrain_list[[i]]$val
    
    
    # Calculate R2
    test_err$test_R2[i] <- as.numeric((cor(crf_pred_test,crf_obs_test, method="pearson"))^2)
    train_err$train_R2[i] <- as.numeric((cor(crf_pred_train,crf_obs_train, method="pearson"))^2)
    oob_err$oob_R2[i] <- as.numeric((cor(crf_pred_oob,crf_obs_train, method="pearson"))^2)
    
    # Calculate Bias
    test_err$test_mean_bias[i] <- as.numeric(mean(crf_pred_test - crf_obs_test))
    train_err$train_mean_bias[i] <- as.numeric(mean(crf_pred_train - crf_obs_train))
    oob_err$oob_mean_bias[i] <- as.numeric(mean(crf_pred_oob - crf_obs_train))
    
    # Calculate RMSE
    test_err$test_rmse[i] <- as.numeric(sqrt(mean((crf_pred_test-crf_obs_test)^2)))
    train_err$train_rmse[i] <- as.numeric(sqrt(mean((crf_pred_train-crf_obs_train)^2)))
    oob_err$oob_rmse[i] <- as.numeric(sqrt(mean((crf_pred_oob-crf_obs_train)^2)))
    
    # Calculate nRMSE (Range Version)
    test_err$test_nrmse[i] <- as.numeric((sqrt(mean((crf_pred_test-crf_obs_test)^2)))/(max(crf_obs_test)- min(crf_obs_test)))
    train_err$train_nrmse[i] <- as.numeric((sqrt(mean((crf_pred_train-crf_obs_train)^2)))/(max(crf_obs_train)- min(crf_obs_train)))
    oob_err$oob_nrmse[i] <- as.numeric((sqrt(mean((crf_pred_oob-crf_obs_train)^2)))/(max(crf_obs_train)- min(crf_obs_train)))
    
  }
  
  # Only export first crf_object 
  # Create list to return rf_obj and importance
  list_out <- list('crf' = crf_list[[1]], 'imp' = rf_import,'test_err' = test_err, 'train_err' = train_err, 'oob_err' = oob_err)
  
  # Return function outputs
  return(list_out)
  
}
