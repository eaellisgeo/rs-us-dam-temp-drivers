###### ANNUAL ###### 
# Use Ann_RF_Hyperparameter_Tuning_Func.R to find the optimal mtry value of RF models

library(tidyverse)
library(ggplot2)

# Import RF function
source("F:/Insert_File_Path/RF_Model_Tuning/Ann_RF_Hyperparameter_Tuning_Func.R") ## Update file path here


# Initialize dataframes to store error values (test set, training set, out-of-bag)

mtry_test <- data.frame(mtry = seq(1,20), rmse = rep(0,20))

mtry_oob <- data.frame(mtry = seq(1,20), rmse = rep(0,20))

mtry_train <- data.frame(mtry = seq(1,20),rmse = rep(0,20))

print('Begin Tuning Annual Model')

# Run RF function to calculate errors for different mtry values
rf_temp <- rf_func_hyperparameter_tuning('Annual')

# Assign values of MSE_test and MSE_oob for each month
mtry_test[,'rmse'] <- rf_temp$RMSE_test
mtry_oob[,'rmse'] <- rf_temp$RMSE_oob
mtry_train[,'rmse'] <- rf_temp$RMSE_train

print('Finished Tuning Annual DIR UP')

# Write error metrics to csv
write.csv(mtry_test,'F:/Insert_File_Path/RF_Model_Tuning/hyperparameter_tuning/mtry_test_annual.csv') ## Update file path here
write.csv(mtry_oob,'F:/Insert_File_Path/RF_Model_Tuning/hyperparameter_tuning/mtry_oob_annual.csv') ## Update file path here
write.csv(mtry_train,'F:/Insert_File_Path/RF_Model_Tuning/hyperparameter_tuning/mtry_train_annual.csv') ## Update file path here

# RMSE_df for plotting
RMSE_df <- data.frame(mtry = mtry_test$mtry,test_RMSE = mtry_test$rmse, train_RMSE = mtry_train$rmse)

ggplot(RMSE_df, aes(x = mtry)) +
  geom_line(aes(y=test_RMSE)) +
  geom_line(aes(y=train_RMSE), col='red') +
  ylab('RMSE') +
  ggtitle('Annual Directly Upstream to Downstream Comparisons')


####