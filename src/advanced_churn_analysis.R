# ML-Customer-Churn-Prediction - Advanced Analytics Module

library(tidyverse)
library(caret)
library(randomForest)
library(xgboost)
library(pROC)
library(data.table)

log_info <- function(message) {
  cat(paste0(Sys.time(), " - INFO - ", message, "
"))
}

log_error <- function(message) {
  cat(paste0(Sys.time(), " - ERROR - ", message, "
"))
}

preprocess_data_advanced <- function(file_path) {
  log_info(paste0("Loading data from ", file_path, "..."))
  data <- tryCatch(
    fread(file_path),
    error = function(e) {
      log_error(paste0("Failed to load data: ", e$message))
      return(NULL)
    }
  )
  
  if (is.null(data)) return(NULL)
  log_info(paste0("Data loaded. Dimensions: ", nrow(data), " rows, ", ncol(data), " columns."))
  
  if ("TotalCharges" %in% colnames(data)) {
    data$TotalCharges <- as.numeric(as.character(data$TotalCharges))
  }
  data <- na.omit(data)
  
  data <- data %>%
    mutate_if(is.character, as.factor)
  
  log_info("Data preprocessed: NA values handled, character columns converted to factors.")
  return(data)
}

train_and_evaluate_multiple_models <- function(data, target_column) {
  if (is.null(data)) return(NULL)
  
  log_info("Starting training and evaluation of multiple models...")
  
  data[[target_column]] <- as.factor(data[[target_column]])
  
  set.seed(123)
  training_index <- createDataPartition(data[[target_column]], p = 0.8, list = FALSE)
  train_data <- data[training_index, ]
  test_data <- data[-training_index, ]
  
  fitControl <- trainControl(method = "cv", number = 5, classProbs = TRUE, summaryFunction = twoClassSummary)
  
  models <- list()
  results <- list()
  
  log_info("Training Random Forest model...")
  model_rf <- train(as.formula(paste(target_column, "~ .")), data = train_data, method = "rf", trControl = fitControl, metric = "ROC")
  models[["RandomForest"]] <- model_rf
  predictions_rf <- predict(model_rf, newdata = test_data)
  results[["RandomForest"]] <- confusionMatrix(predictions_rf, test_data[[target_column]])
  log_info("Random Forest model trained and evaluated.")
  
  log_info("Training XGBoost model...")
  model_xgb <- train(as.formula(paste(target_column, "~ .")), data = train_data, method = "xgbTree", trControl = fitControl, metric = "ROC")
  models[["XGBoost"]] <- model_xgb
  predictions_xgb <- predict(model_xgb, newdata = test_data)
  results[["XGBoost"]] <- confusionMatrix(predictions_xgb, test_data[[target_column]])
  log_info("XGBoost model trained and evaluated.")
  
  log_info("Model training and evaluation complete.")
  return(list(models = models, evaluation_results = results))
}

run_advanced_analytics <- function(file_path, target_column) {
  log_info("--- Starting Advanced Analytics Pipeline ---")
  
  processed_data <- preprocess_data_advanced(file_path)
  if (is.null(processed_data)) {
    log_error("Data preprocessing failed. Exiting pipeline.")
    return(NULL)
  }
  
  model_results <- train_and_evaluate_multiple_models(processed_data, target_column)
  if (is.null(model_results)) {
    log_error("Model training and evaluation failed. Exiting pipeline.")
    return(NULL)
  }
  
  log_info("
--- Model Comparison ---")
  for (model_name in names(model_results$evaluation_results)) {
    log_info(paste0("Evaluation for ", model_name, ":"))
    print(model_results$evaluation_results[[model_name]])
  }
  
  log_info("--- Advanced Analytics Complete ---")
  return(model_results)
}
