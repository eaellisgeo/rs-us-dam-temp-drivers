######  SEASONAL ###### 
# Use Seas_RF_Hyperparameter_Tuning_Func.R to find the optimal mtry value of RF models


library(tidyverse)
library(ggplot2)


# Import RF function
source("F:/Insert_File_Path/RF_Model_Tuning/Seas_RF_Hyperparameter_Tuning_Func.R") ## Update file path here


# Create array of season strings for saving to file
seas_list <- c('winter','spring','summer','fall')


# Initialize dataframes to store error values (test set, training set, out-of-bag)

mtry_test <- data.frame(mtry = seq(1,20), winter_rmse = rep(0,20), spring_rmse = rep(0,20), summer_rmse = rep(0,20),
                        fall_rmse = rep(0,20))

mtry_oob <- data.frame(mtry = seq(1,20), winter_rmse = rep(0,20), spring_rmse = rep(0,20), summer_rmse = rep(0,20),
                       fall_rmse = rep(0,20))

mtry_train <- data.frame(mtry = seq(1,20), winter_rmse = rep(0,20), spring_rmse = rep(0,20), summer_rmse = rep(0,20),
                         fall_rmse = rep(0,20))


# Loop through seasons
for (i in seas_list){
  print(paste("Start", i,sep = " "))
  
  # Run RF function to calculate errors for different mtry values for each season i
  rf_temp <- rf_func_hyperparameter_tuning('Change', i)
  
  # Assign values of MSE_test and MSE_oob for each month
  mtry_test[,paste(i,'_rmse',sep = "")] <- rf_temp$RMSE_test
  mtry_oob[,paste(i,'_rmse',sep = "")] <- rf_temp$RMSE_oob
  mtry_train[,paste(i,'_rmse',sep = "")] <- rf_temp$RMSE_train
  
  print(paste("Finished", i, sep = " "))
  
}

# Calculate column means of mtry dfs
mtry_test$test_rmse <- rowMeans(mtry_test[,-1])
mtry_oob$oob_rmse <- rowMeans(mtry_oob[,-1])
mtry_train$train_rmse <- rowMeans(mtry_train[,-1])


# Write error metrics to csv
write.csv(mtry_test,'F:/Insert_File_Path/RF_Model_Tuning/hyperparameter_tuning/mtry_test_seas.csv') ## Update file path here
write.csv(mtry_oob,'F:/Insert_File_Path/RF_Model_Tuning/hyperparameter_tuning/mtry_oob_seas.csv') ## Update file path here
write.csv(mtry_train,'F:/Insert_File_Path/RF_Model_Tuning/hyperparameter_tuning/mtry_train_seas.csv') ## Update file path here

# RMSE_df for plotting
RMSE_df <- data.frame(mtry = mtry_test$mtry,test_RMSE = mtry_test$test_rmse, train_RMSE = mtry_train$train_rmse)

ggplot(RMSE_df, aes(x = mtry)) +
  geom_line(aes(y=test_RMSE)) +
  geom_line(aes(y=train_RMSE), col='red') +
  ylab('RMSE') +
  ggtitle('Seasonal Directly Upstream to Downstream Comparisons')


####