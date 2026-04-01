###### SEASONAL ###### 

# Using Seas_RF_func.R, run RF for Directly Upstream to River comparisons

# Import RF function
source("F:/Insert_File_Path/RF_Model_Runs/Seas_RF_Func.R") ## Update file path here


# Create array of season strings for saving to file
seas_list <- c('winter','spring','summer','fall')


##### Directly Upstream Comparisons #####

# Create dataframe to store mean and sd of model errors
errordf <-  data.frame(test_R2 = rep(0,4), train_R2 = rep(0,4), oob_R2 = rep(0,4),
                       test_mean_bias = rep(0,4), train_mean_bias = rep(0,4), oob_mean_bias = rep(0,4),
                       test_rmse = rep(0,4), train_rmse = rep(0,4), oob_rmse = rep(0,4),
                       test_nrmse = rep(0,4), train_nrmse = rep(0,4), oob_nrmse = rep(0,4),
                       test_R2_sd = rep(0,4), train_R2_sd = rep(0,4), oob_R2_sd = rep(0,4),
                       test_mean_bias_sd = rep(0,4), train_mean_bias_sd = rep(0,4), oob_mean_bias_sd = rep(0,4),
                       test_rmse_sd = rep(0,4), train_rmse_sd = rep(0,4), oob_rmse_sd = rep(0,4),
                       test_nrmse_sd = rep(0,4), train_nrmse_sd = rep(0,4), oob_nrmse_sd = rep(0,4))


# Create dataframe to store model errors from cv1 (variable importance model)
cv1_error <- data.frame(test_R2 = rep(0,4), train_R2 = rep(0,4), oob_R2 = rep(0,4),
                        test_mean_bias = rep(0,4), train_mean_bias = rep(0,4), oob_mean_bias = rep(0,4),
                        test_rmse = rep(0,4), train_rmse = rep(0,4), oob_rmse = rep(0,4),
                        test_nrmse = rep(0,4), train_nrmse = rep(0,4), oob_nrmse = rep(0,4))

# Loop through seasons
for (i in seas_list){
  print(paste("Start", i,sep = " "))
  
  # Run RF function
  rf_temp <- rf_func('Change',i)
  
  # Store crf object
  rf_crf <- rf_temp$crf
  
  # Store importance csv
  rf_imp <- rf_temp$imp
  
  # Create file path for crf obj
  crf_filepath <- paste("F:/Insert_File_Path/RF_Model_Results/crf_",i,".rds",sep="") ## Update file path here
  
  # Generate file path for rf_imp
  imp_filepath <- paste("F:/Insert_File_Path/RF_Model_Results/",i,"_importance_results.csv",sep="") ## Update file path here
  
  # Save crf obj
  saveRDS(rf_crf,crf_filepath)
  
  # Write imp to csv
  write.csv(rf_imp, imp_filepath)
  
  print("Finished Running Seasonal Model")
  print("Start Running Seasonal Error Metrics")
  
  row_no <- match(i,seas_list)
  
  ###############################################
  # Aggregate R2 into dataframe
  errordf$test_R2[row_no] <- mean(rf_temp$test_err$test_R2)
  errordf$train_R2[row_no] <- mean(rf_temp$train_err$train_R2)
  errordf$oob_R2[row_no] <- mean(rf_temp$oob_err$oob_R2)
  
  # Aggregate mean bias into dataframe
  errordf$test_mean_bias[row_no] <- mean(rf_temp$test_err$test_mean_bias)
  errordf$train_mean_bias[row_no] <- mean(rf_temp$train_err$train_mean_bias)
  errordf$oob_mean_bias[row_no] <- mean(rf_temp$oob_err$oob_mean_bias)
  
  # Aggregate rmse into dataframe
  errordf$test_rmse[row_no] <- mean(rf_temp$test_err$test_rmse)
  errordf$train_rmse[row_no] <- mean(rf_temp$train_err$train_rmse)
  errordf$oob_rmse[row_no] <- mean(rf_temp$oob_err$oob_rmse)
  
  # Aggregate nrmse into dataframe
  errordf$test_nrmse[row_no] <- mean(rf_temp$test_err$test_nrmse)
  errordf$train_nrmse[row_no] <- mean(rf_temp$train_err$train_nrmse)
  errordf$oob_nrmse[row_no] <- mean(rf_temp$oob_err$oob_nrmse)
  
  ###############################################
  # Aggregate R2 sd into dataframe
  errordf$test_R2_sd[row_no] <- sd(rf_temp$test_err$test_R2)
  errordf$train_R2_sd[row_no] <- sd(rf_temp$train_err$train_R2)
  errordf$oob_R2_sd[row_no] <- sd(rf_temp$oob_err$oob_R2)
  
  # Aggregate mean bias sd into dataframe
  errordf$test_mean_bias_sd[row_no] <- sd(rf_temp$test_err$test_mean_bias)
  errordf$train_mean_bias_sd[row_no] <- sd(rf_temp$train_err$train_mean_bias)
  errordf$oob_mean_bias_sd[row_no] <- sd(rf_temp$oob_err$oob_mean_bias)
  
  # Aggregate rmse sd into dataframe
  errordf$test_rmse_sd[row_no] <- sd(rf_temp$test_err$test_rmse)
  errordf$train_rmse_sd[row_no] <- sd(rf_temp$train_err$train_rmse)
  errordf$oob_rmse_sd[row_no] <- sd(rf_temp$oob_err$oob_rmse)
  
  # Aggregate nrmse sd into dataframe
  errordf$test_nrmse_sd[row_no] <- sd(rf_temp$test_err$test_nrmse)
  errordf$train_nrmse_sd[row_no] <- sd(rf_temp$train_err$train_nrmse)
  errordf$oob_nrmse_sd[row_no] <- sd(rf_temp$oob_err$oob_nrmse)
  
  ###############################################
  # Aggregate cv1 R2 into dataframe
  cv1_error$test_R2[row_no] <- rf_temp$test_err$test_R2[1]
  cv1_error$train_R2[row_no] <- rf_temp$train_err$train_R2[1]
  cv1_error$oob_R2[row_no] <- rf_temp$oob_err$oob_R2[1]
  
  # Aggregate cv1 mean bias into dataframe
  cv1_error$test_mean_bias[row_no] <- rf_temp$test_err$test_mean_bias[1]
  cv1_error$train_mean_bias[row_no] <- rf_temp$train_err$train_mean_bias[1]
  cv1_error$oob_mean_bias[row_no] <- rf_temp$oob_err$oob_mean_bias[1]
  
  # Aggregate cv1 rmse into dataframe
  cv1_error$test_rmse[row_no] <- rf_temp$test_err$test_rmse[1]
  cv1_error$train_rmse[row_no] <- rf_temp$train_err$train_rmse[1]
  cv1_error$oob_rmse[row_no] <- rf_temp$oob_err$oob_rmse[1]
  
  # Aggregate cv1 nrmse into dataframe
  cv1_error$test_nrmse[row_no] <- rf_temp$test_err$test_nrmse[1]
  cv1_error$train_nrmse[row_no] <- rf_temp$train_err$train_nrmse[1]
  cv1_error$oob_nrmse[row_no] <- rf_temp$oob_err$oob_nrmse[1]
  
  ###############################################
  print(paste("Finshed", i,sep = " "))
}

# Write error metrics to csv
write.csv(errordf,"F:Insert_File_Path/RF_Model_Results/all_season_error.csv") ## Update file path here
write.csv(cv1_error,"Insert_File_Path/RF_Model_Results/cv1_season_error.csv") ## Update file path here

####
print("Finished Seasonal Models")