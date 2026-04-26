# Install required packages if not present
required_packages <- c("caret", "randomForest", "e1071", "dplyr", "ggplot2")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) {
  cat("Installing missing packages:", paste(new_packages, collapse=", "), "\n")
  install.packages(new_packages, repos="http://cran.us.r-project.org")
}

suppressPackageStartupMessages({
  library(caret)
  library(randomForest)
  library(dplyr)
  library(ggplot2)
})

# 1. Load Data
data_path <- "data/customer_churn.csv"
if(!file.exists(data_path)) {
  stop("Data file not found. Please run '01_generate_data.R' first.")
}
cat("Loading data...\n")
df <- read.csv(data_path, stringsAsFactors = TRUE)

# Remove CustomerID as it's not a predictor feature
df$CustomerID <- NULL

# 2. Split Data into Training and Testing Sets
set.seed(123)
cat("Splitting data into 80% train and 20% test...\n")
trainIndex <- createDataPartition(df$Churn, p = .8, list = FALSE, times = 1)
dfTrain <- df[ trainIndex,]
dfTest  <- df[-trainIndex,]

# 3. Train Random Forest Model
cat("Training Random Forest model (this may take a moment)...\n")
rf_model <- randomForest(Churn ~ ., data = dfTrain, ntree = 100, importance = TRUE)

# 4. Evaluate Model
cat("Evaluating model on test data...\n")
predictions <- predict(rf_model, dfTest)

# Confusion Matrix
cm <- confusionMatrix(predictions, dfTest$Churn)
cat("\n--- Model Evaluation (Confusion Matrix) ---\n")
print(cm)

# 5. Extract and Plot Feature Importance
cat("\nExtracting feature importance...\n")
importance_df <- as.data.frame(importance(rf_model))
importance_df$Feature <- rownames(importance_df)

# Plot Feature Importance
dir.create("plots", showWarnings = FALSE)
p <- ggplot(importance_df, aes(x = reorder(Feature, MeanDecreaseGini), y = MeanDecreaseGini)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Feature Importance for Customer Churn", 
       x = "Features", 
       y = "Mean Decrease in Gini Index")

ggsave("plots/feature_importance.png", plot = p, width = 8, height = 6)
cat("Feature importance plot saved to 'plots/feature_importance.png'\n")

# Save model for future predictions
dir.create("models", showWarnings = FALSE)
saveRDS(rf_model, "models/rf_churn_model.rds")
cat("Trained model saved to 'models/rf_churn_model.rds'\n")
cat("\nPipeline completed successfully!\n")
