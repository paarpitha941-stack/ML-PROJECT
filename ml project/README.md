# Customer Churn Prediction (R)

This project contains an end-to-end Machine Learning pipeline for predicting Customer Churn using R and Random Forest.

## Project Structure

- `01_generate_data.R`: Simulates a dataset of 1000 customers with features like Age, Tenure, Monthly Charges, Contract Type, etc. and a `Churn` label based on reasonable probabilities.
- `02_train_model.R`: Loads the generated data, splits it into training/testing sets, trains a Random Forest model, and evaluates its accuracy with a confusion matrix. It also extracts and plots feature importance.
- `run_pipeline.R`: A master script that runs the entire pipeline from end to end.

## How to Run the Project

### Option 1: Run via Command Line

Open your terminal or command prompt, navigate to this directory, and run the pipeline using `Rscript`:

```bash
Rscript run_pipeline.R
```

This will automatically:
1. Generate `data/customer_churn.csv`
2. Train the Random Forest model
3. Output the Confusion Matrix metrics in your terminal
4. Save the trained model to `models/rf_churn_model.rds`
5. Save the Feature Importance plot to `plots/feature_importance.png`

### Option 2: Run in an IDE (RStudio, VSCode, etc.)

1. Open `01_generate_data.R` and run the script to generate the synthetic dataset.
2. Open `02_train_model.R` and run the script to train the model and view the evaluation metrics.
3. Or, simply run the `run_pipeline.R` file directly within your IDE.

## Requirements

The scripts will automatically attempt to install these packages if they are not present:
- `caret` (for data splitting and evaluation metrics)
- `randomForest` (for the modeling algorithm)
- `e1071` (required by caret)
- `dplyr` (for data manipulation)
- `ggplot2` (for plotting feature importance)
