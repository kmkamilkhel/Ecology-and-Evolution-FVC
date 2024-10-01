# Clean environment
rm(list = ls(all=TRUE))
graphics.off()
gc()

# Load required libraries
library(raster)
library(caret)
library(xgboost)
library(ggplot2)

# Set working directory
setwd("E:/Path/to/ML-Reults/")

# Load raster stack and samples
sen_ms <- stack("KKGStackedAllPredictors.tif")
samples <- read.csv('KKG_ML.csv')

# Split data into training and evaluation sets
set.seed(123)
train_indices <- sample(seq_len(nrow(samples)), size = floor(0.70 * nrow(samples)))
trainx <- samples[train_indices, ]
evalx <- samples[-train_indices, ]

# Set up train control
tc <- trainControl(method = "repeatedcv", number = 10, repeats = 5, allowParallel = TRUE, verboseIter = TRUE)

# Hyperparameter grid for XGBoost
xgb.grid <- expand.grid(nrounds = 50, max_depth = c(3, 5, 7), eta = c(0.01, 0.1, 0.3), 
                        gamma = 0.1, colsample_bytree = 0.8, min_child_weight = 1, subsample = 0.8)

# Train the XGBoost regression model
xgb_model <- caret::train(x = trainx[, 2:6], y = trainx$fvc, method = "xgbTree", trControl = tc, 
                          tuneGrid = xgb.grid, metric = "RMSE", verbose = 1, lambda = 1, alpha = 0.1)

# Variable importance
plot(varImp(xgb_model))

# Predictions on evaluation data
predictions <- predict(xgb_model, evalx)
rf_prediction <- raster::predict(sen_ms, model = xgb_model)
writeRaster(rf_prediction, filename = 'KKG_XGboost_Prediction.tif', format = "GTiff", overwrite = TRUE)

# Performance metrics
mse <- mean((predictions - evalx$fvc)^2)
rmse <- sqrt(mse)
rsquared <- cor(predictions, evalx$fvc)^2
mae <- mean(abs(predictions - evalx$fvc))

# Print metrics
cat("MSE:", mse, "\nRMSE:", rmse, "\nR-squared:", rsquared, "\nMAE:", mae, "\n")

# Plot observed vs predicted
plot_data <- data.frame(Predicted = predictions, Observed = evalx$fvc)
write.csv(plot_data, "xgboostTestObsVSPred.csv", row.names = FALSE)

ggplot(plot_data, aes(x = Observed, y = Predicted)) +
  geom_point(color = "blue", size = 2, alpha = 0.7) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  labs(x = "Observed FVC", y = "Predicted FVC", title = "Predicted vs. Observed FVC", caption = "y = x") +
  theme_minimal()

# Train performance metrics
train_predictions <- predict(xgb_model, newdata = trainx)
mse_train <- mean((train_predictions - trainx$fvc)^2)
rmse_train <- sqrt(mse_train)
rsquared_train <- cor(train_predictions, trainx$fvc)^2
mae_train <- mean(abs(train_predictions - trainx$fvc))

cat("Training MSE:", mse_train, "\nTraining RMSE:", rmse_train, "\nTraining R-squared:", rsquared_train, "\nTraining MAE:", mae_train, "\n")




#### SVM
# Clean environment
rm(list = ls(all = TRUE))
graphics.off()
gc()

# Load required libraries
library(raster)
library(caret)
library(e1071)

# Set working directory
setwd("E:/Path/to/ML-Reults/")

# Load raster stack and samples
sen_ms <- stack("KKGStackedAllPredictors.tif")
samples <- read.csv('KKG_ML.csv')

# Split data into training and evaluation sets
set.seed(123)
train_indices <- sample(seq_len(nrow(samples)), size = floor(0.70 * nrow(samples)))
trainx <- samples[train_indices, ]
evalx <- samples[-train_indices, ]

# Set up train control
tc <- trainControl(method = "repeatedcv", number = 10, repeats = 5, allowParallel = TRUE, verboseIter = TRUE)

# Train SVM model
svm_model <- caret::train(x = trainx[, 2:6], y = trainx$fvc, method = "svmRadial", 
                          trControl = tc, metric = "RMSE", verbose = TRUE)

# Predictions and performance metrics
predictions <- predict(svm_model, evalx)
mse <- mean((predictions - evalx$fvc)^2)
rmse <- sqrt(mse)
rsquared <- cor(predictions, evalx$fvc)^2
mae <- mean(abs(predictions - evalx$fvc))

# Print metrics
cat("SVM MSE:", mse, "\nSVM RMSE:", rmse, "\nSVM R-squared:", rsquared, "\nSVM MAE:", mae, "\n")




#### KNN
# Clean environment
rm(list = ls(all = TRUE))
graphics.off()
gc()

# Load required libraries
library(raster)
library(caret)

# Set working directory
setwd("E:/Path/to/ML-Reults/")

# Load raster stack and samples
sen_ms <- stack("KKGStackedAllPredictors.tif")
samples <- read.csv('KKG_ML.csv')

# Split data into training and evaluation sets
set.seed(123)
train_indices <- sample(seq_len(nrow(samples)), size = floor(0.70 * nrow(samples)))
trainx <- samples[train_indices, ]
evalx <- samples[-train_indices, ]

# Set up train control
tc <- trainControl(method = "repeatedcv", number = 10, repeats = 5, allowParallel = TRUE, verboseIter = TRUE)

# Train KNN model
knn_model <- caret::train(x = trainx[, 2:6], y = trainx$fvc, method = "knn", 
                          trControl = tc, tuneLength = 10, metric = "RMSE", verbose = TRUE)

# Predictions and performance metrics
predictions <- predict(knn_model, evalx)
mse <- mean((predictions - evalx$fvc)^2)
rmse <- sqrt(mse)
rsquared <- cor(predictions, evalx$fvc)^2
mae <- mean(abs(predictions - evalx$fvc))

# Print metrics
cat("KNN MSE:", mse, "\nKNN RMSE:", rmse, "\nKNN R-squared:", rsquared, "\nKNN MAE:", mae, "\n")


##### RF
# Clean environment
rm(list = ls(all = TRUE))
graphics.off()
gc()

# Load required libraries
library(raster)
library(caret)
library(randomForest)

# Set working directory
setwd("E:/Path/to/ML-Reults/")

# Load raster stack and samples
sen_ms <- stack("KKGStackedAllPredictors.tif")
samples <- read.csv('KKG_ML.csv')

# Split data into training and evaluation sets
set.seed(123)
train_indices <- sample(seq_len(nrow(samples)), size = floor(0.70 * nrow(samples)))
trainx <- samples[train_indices, ]
evalx <- samples[-train_indices, ]

# Set up train control
tc <- trainControl(method = "repeatedcv", number = 10, repeats = 5, allowParallel = TRUE, verboseIter = TRUE)

# Train Random Forest model
rf_model <- caret::train(x = trainx[, 2:6], y = trainx$fvc, method = "rf", 
                         trControl = tc, metric = "RMSE", tuneLength = 5, verbose = TRUE)

# Predictions and performance metrics
predictions <- predict(rf_model, evalx)
mse <- mean((predictions - evalx$fvc)^2)
rmse <- sqrt(mse)
rsquared <- cor(predictions, evalx$fvc)^2
mae <- mean(abs(predictions - evalx$fvc))

# Print metrics
cat("RF MSE:", mse, "\nRF RMSE:", rmse, "\nRF R-squared:", rsquared, "\nRF MAE:", mae, "\n")

