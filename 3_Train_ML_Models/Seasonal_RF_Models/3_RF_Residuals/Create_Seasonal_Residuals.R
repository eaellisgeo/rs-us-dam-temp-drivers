## Get Predictions and Residuals for the Seasonal Models ## 

library(caret)
library(dplyr)
library(tidyverse)

#### Pull in and format the data to match the model training ####

# Read in Downstream Changes
DirUp <- read.csv("F:/Insert_File_Path/Temp_Change_Attributes_All.csv") ## Update file path here

# Assemble data frame of rf Dir Up/Ds input data, based on input month value
rf_base_data <- data.frame(DirUp[,c(3:38)])

## Clean up columns
rf_base_data$Month <- as.factor(rf_base_data$Month)
rf_base_data$Sig_05 <- as.factor(rf_base_data$Sig_05)
rf_base_data$Dam.purpose <- as.factor(rf_base_data$Dam.purpose)
rf_base_data$Resv <- as.factor(rf_base_data$Resv)
rf_base_data$Physiographic.Region <- as.factor(rf_base_data$Physiographic.Region)

####### Winter####### 
rf_data_f1 <- subset(rf_base_data, Month %in% c(12,1,2))

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


#### Perform random 5-fold sampling on HydroBasin (04) Subsets ####
## Generate training and test set (80/20) stratified sampling

set.seed(1)
folds <- createFolds(factor(strat_basin_seas$Strat_Group), k = 5, list = FALSE, returnTrain = FALSE)

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


## Subset out_df by cvtrain1 indices to match with training set
out_df <- subset(cvtrain1, select = (val))

# rename change column 
names(out_df)[names(out_df) == 'val'] <- 'Temp_Diff'

# Add columns to out_df to store predicted values
out_df = cbind(out_df,matrix(0,nrow = dim(out_df[1]),ncol=1))
names(out_df)[2] = "Temp_Diff_Pred"


#### Pull in the Model Results ####
# Create file path for crf obj
crf_filepath <- "F:/Insert_File_Path/Model_Training_Results_Winter.rds" ## Update file path here

# Load rds file
crf_obj <- readRDS(crf_filepath)

# Predict values from RF object
rf_pred <- predict(crf_obj)

# Store predicted values in out_df
out_df[,(2)] <- rf_pred

## Get Residuals/Standardized Residuals ## 
out_df$Residuals <- out_df$Temp_Diff - out_df$Temp_Diff_Pred

STDV_Res <- sd(out_df$Residuals)

out_df$STDVResiduals <- out_df$Residuals/STDV_Res


## Plot the Standardized Residuals ##
plot(out_df$Temp_Diff_Pred, out_df$STDVResiduals, 
     xlim = c(-2, 6),ylim = c(-6,6),
     abline(h = c(2,0,-2), col = "black", lty = 2, lwd = 1),
     main = "Winter", 
     xlab = "Predicted Temperature Difference (°C)", 
     ylab = "Standardized Residuals", 
     pch = 21,
     bg = "#365f93",
     col = "black")

####################################################################################

####### Spring ####### 
rf_data_f1 <- subset(rf_base_data, Month %in% c(3,4,5))

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


#### Perform random 5-fold sampling on HydroBasin (04) Subsets ####
## Generate training and test set (80/20) stratified sampling

set.seed(1)
folds <- createFolds(factor(strat_basin_seas$Strat_Group), k = 5, list = FALSE, returnTrain = FALSE)

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


## Subset out_df by cvtrain1 indices to match with training set
out_df <- subset(cvtrain1, select = (val))

# rename change column 
names(out_df)[names(out_df) == 'val'] <- 'Temp_Diff'

# Add columns to out_df to store predicted values
out_df = cbind(out_df,matrix(0,nrow = dim(out_df[1]),ncol=1))
names(out_df)[2] = "Temp_Diff_Pred"

#### Pull in the Model Results ####
# Create file path for crf obj
crf_filepath <- "F:/Insert_File_Path/Model_Training_Results_Spring.rds" ## Update file path here

# Load rds file
crf_obj <- readRDS(crf_filepath)

# Predict values from RF object
rf_pred <- predict(crf_obj)

# Store predicted values in out_df
out_df[,(2)] <- rf_pred

## Get Residuals/Standardized Residuals ## 
out_df$Residuals <- out_df$Temp_Diff - out_df$Temp_Diff_Pred

STDV_Res <- sd(out_df$Residuals)

out_df$STDVResiduals <- out_df$Residuals/STDV_Res

## Plot the Standardized Residuals ##
plot(out_df$Temp_Diff_Pred, out_df$STDVResiduals, 
     xlim = c(-2, 6),ylim = c(-6, 6),
     abline(h = c(2,0,-2), col = "black", lty = 2, lwd = 1),
     main = "Spring", 
     xlab = "Predicted Temperature Difference (°C)", 
     ylab = "Standardized Residuals", 
     pch = 21,
     bg = "#df9eba",
     col = "black")

####################################################################################

####### Summer ####### 
rf_data_f1 <- subset(rf_base_data, Month %in% c(6,7,8))

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


#### Perform random 5-fold sampling on HydroBasin (04) Subsets ####
## Generate training and test set (80/20) stratified sampling

set.seed(1)
folds <- createFolds(factor(strat_basin_seas$Strat_Group), k = 5, list = FALSE, returnTrain = FALSE)

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


## Subset out_df by cvtrain1 indices to match with training set
out_df <- subset(cvtrain1, select = (val))

# rename change column 
names(out_df)[names(out_df) == 'val'] <- 'Temp_Diff'

# Add columns to out_df to store predicted values
out_df = cbind(out_df,matrix(0,nrow = dim(out_df[1]),ncol=1))
names(out_df)[2] = "Temp_Diff_Pred"

#### Pull in the Model Results ####
# Create file path for crf obj
crf_filepath <- "F:/Insert_File_Path/Model_Training_Results_Summer.rds" ## Update file path here

# Load rds file
crf_obj <- readRDS(crf_filepath)

# Predict values from RF object
rf_pred <- predict(crf_obj)

# Store predicted values in out_df
out_df[,(2)] <- rf_pred

## Get Residuals/Standardized Residuals ## 
out_df$Residuals <- out_df$Temp_Diff - out_df$Temp_Diff_Pred

STDV_Res <- sd(out_df$Residuals)

out_df$STDVResiduals <- out_df$Residuals/STDV_Res

## Plot the Standardized Residuals ##
plot(out_df$Temp_Diff_Pred, out_df$STDVResiduals, 
     xlim = c(-2, 6),ylim = c(-6, 6),
     abline(h = c(2,0,-2), col = "black", lty = 2, lwd = 1),
     main = "Summer", 
     xlab = "Predicted Temperature Difference (°C)", 
     ylab = "Standardized Residuals", 
     pch = 21,
     bg = "#2d9284",
     col = "black")

####################################################################################

####### Fall ####### 
rf_data_f1 <- subset(rf_base_data, Month %in% c(9,10,11))

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


#### Perform random 5-fold sampling on HydroBasin (04) Subsets ####
## Generate training and test set (80/20) stratified sampling

set.seed(1)
folds <- createFolds(factor(strat_basin_seas$Strat_Group), k = 5, list = FALSE, returnTrain = FALSE)

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


## Subset out_df by cvtrain1 indices to match with training set
out_df <- subset(cvtrain1, select = (val))

# rename change column 
names(out_df)[names(out_df) == 'val'] <- 'Temp_Diff'

# Add columns to out_df to store predicted values
out_df = cbind(out_df,matrix(0,nrow = dim(out_df[1]),ncol=1))
names(out_df)[2] = "Temp_Diff_Pred"

#### Pull in the Model Results ####
# Create file path for crf obj
crf_filepath <- "F:/Insert_File_Path/Model_Training_Results.rds" ## Update file path here

# Load rds file
crf_obj <- readRDS(crf_filepath)

# Predict values from RF object
rf_pred <- predict(crf_obj)

# Store predicted values in out_df
out_df[,(2)] <- rf_pred

## Get Residuals/Standardized Residuals ## 
out_df$Residuals <- out_df$Temp_Diff - out_df$Temp_Diff_Pred

STDV_Res <- sd(out_df$Residuals)

out_df$STDVResiduals <- out_df$Residuals/STDV_Res

## Plot the Standardized Residuals ##
plot(out_df$Temp_Diff_Pred, out_df$STDVResiduals, 
     xlim = c(-2, 6),ylim = c(-6, 6),
     abline(h = c(2,0,-2), col = "black", lty = 2, lwd = 1),
     main = "Fall", 
     xlab = "Predicted Temperature Difference (°C)", 
     ylab = "Standardized Residuals", 
     pch = 21,
     bg = "#cdac77",
     col = "black")