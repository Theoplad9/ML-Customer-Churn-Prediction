library(tidyverse)
library(caret)
library(randomForest)
library(xgboost)
library(pROC)

# Function to load and preprocess data
preprocess_data <- function(file_path) {
  data <- read.csv(file_path)
  
  # Basic cleaning and type conversion
  data$TotalCharges <- as.numeric(as.character(data$TotalCharges))
  data <- na.omit(data) # Remove rows with NA values
  
  # Convert categorical variables to factors
  data <- data %>%
    mutate_if(is.character, as.factor)
  
  # Convert Churn to a factor with levels 'No' and 'Yes'
  data$Churn <- factor(data$Churn, levels = c("No", "Yes"))
  
  return(data)
}

# Function to train and evaluate a model
train_and_evaluate_model <- function(data) {
  # Split data into training and testing sets
  set.seed(123)
  training_index <- createDataPartition(data$Churn, p = 0.8, list = FALSE)
  train_data <- data[training_index, ]
  test_data <- data[-training_index, ]
  
  # Train a Random Forest model
  model_rf <- train(Churn ~ ., data = train_data, method = "rf",
                    trControl = trainControl(method = "cv", number = 5))
  
  # Make predictions
  predictions_rf <- predict(model_rf, newdata = test_data)
  
  # Evaluate the model
  confusion_matrix_rf <- confusionMatrix(predictions_rf, test_data$Churn)
  
  return(list(model = model_rf, confusion_matrix = confusion_matrix_rf))
}

# Main function to run the churn prediction analysis
run_churn_prediction <- function(file_path) {
  cat("\n--- Starting Customer Churn Prediction Analysis ---\n")
  
  # 1. Preprocess Data
  cat("1. Preprocessing data...\n")
  customer_data <- preprocess_data(file_path)
  cat("   Data preprocessed. Dimensions: ", dim(customer_data)[1], " rows, ", dim(customer_data)[2], " columns.\n")
  
  # 2. Train and Evaluate Model
  cat("2. Training and evaluating Random Forest model...\n")
  results <- train_and_evaluate_model(customer_data)
  cat("   Model training complete.\n")
  
  cat("\n--- Model Evaluation Results (Random Forest) ---\n")
  print(results$confusion_matrix)
  
  cat("\n--- Analysis Complete ---\n")
  return(results)
}

# Example usage (uncomment to run directly)
# if (interactive()) {
#   # Create a dummy CSV for demonstration if it doesn't exist
#   if (!file.exists("data/customer_data.csv")) {
#     dir.create("data", showWarnings = FALSE)
#     write.csv(data.frame(
#       CustomerID = 1:5,
#       Gender = c("Female", "Male", "Male", "Male", "Female"),
#       SeniorCitizen = c("No", "No", "No", "No", "No"),
#       Partner = c("Yes", "No", "No", "No", "No"),
#       Dependents = c("No", "No", "No", "No", "No"),
#       Tenure = c(1, 34, 2, 45, 2),
#       PhoneService = c("No", "Yes", "Yes", "No", "Yes"),
#       MultipleLines = c("No", "No", "No", "No", "No"),
#       InternetService = c("DSL", "DSL", "DSL", "DSL", "Fiber optic"),
#       OnlineSecurity = c("No", "Yes", "Yes", "Yes", "No"),
#       OnlineBackup = c("Yes", "No", "Yes", "No", "No"),
#       DeviceProtection = c("No", "Yes", "No", "Yes", "No"),
#       TechSupport = c("No", "No", "No", "Yes", "No"),
#       StreamingTV = c("No", "No", "No", "No", "No"),
#       StreamingMovies = c("No", "No", "No", "No", "No"),
#       Contract = c("Month-to-month", "One year", "Month-to-month", "One year", "Month-to-month"),
#       PaperlessBilling = c("Yes", "No", "Yes", "No", "Yes"),
#       PaymentMethod = c("Electronic check", "Mailed check", "Mailed check", "Bank transfer (automatic)", "Electronic check"),
#       MonthlyCharges = c(29.85, 56.95, 53.85, 42.3, 70.7),
#       TotalCharges = c(29.85, 1889.5, 108.15, 1840.75, 151.65),
#       Churn = c("No", "No", "Yes", "No", "Yes")
#     ), "data/customer_data.csv", row.names = FALSE)
#   }
#   
#   results <- run_churn_prediction("data/customer_data.csv")
# }
