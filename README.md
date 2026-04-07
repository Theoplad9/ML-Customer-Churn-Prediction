# ML-Customer-Churn-Prediction

An R-based machine learning project for predicting customer churn using various classification algorithms.

## Overview

This repository provides an R-based solution for predicting customer churn. It includes data preprocessing, exploratory data analysis, implementation of several machine learning models (e.g., Logistic Regression, Random Forest, Gradient Boosting), and evaluation metrics.

## Features

- **Data Preprocessing:** Scripts for cleaning and preparing customer data.
- **Exploratory Data Analysis (EDA):** Visualizations and statistical summaries to understand churn drivers.
- **Machine Learning Models:** Implementation of popular classification algorithms.
- **Model Evaluation:** Metrics such as accuracy, precision, recall, F1-score, and ROC curves.
- **R-based:** All code is written in R, leveraging powerful R packages for data science.

## Installation

```R
# Clone the repository
git clone https://github.com/Theoplad9/ML-Customer-Churn-Prediction.git
setwd("ML-Customer-Churn-Prediction")

# Install required R packages
install.packages(c("tidyverse", "caret", "randomForest", "xgboost", "pROC"))
```

## Usage

```R
# Load necessary libraries
library(tidyverse)
library(caret)

# Source the main prediction script
source("src/churn_prediction.R")

# Example usage (assuming you have a 'data/customer_data.csv' file)
# results <- run_churn_prediction("data/customer_data.csv")
# print(results)
```

## Project Structure

```
ML-Customer-Churn-Prediction/
├── data/
│   └── customer_data.csv
├── src/
│   ├── data_preprocessing.R
│   ├── eda.R
│   └── churn_prediction.R
├── models/
│   └── final_model.RData
├── reports/
│   └── churn_analysis.Rmd
├── README.md
├── requirements.R
└── LICENSE
```

## Contributing

Contributions are welcome! Please see `CONTRIBUTING.md` for details.

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.
