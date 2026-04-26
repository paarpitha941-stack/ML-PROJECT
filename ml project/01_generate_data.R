set.seed(42)

# Number of customers
n <- 1000

# Generate customer features
customer_id <- 1:n
age <- round(runif(n, 18, 70))
tenure_months <- round(runif(n, 1, 72))
monthly_charges <- runif(n, 20, 120)
total_charges <- tenure_months * monthly_charges
contract_type <- sample(c("Month-to-month", "One year", "Two year"), n, replace = TRUE, prob = c(0.5, 0.3, 0.2))
internet_service <- sample(c("DSL", "Fiber optic", "No"), n, replace = TRUE, prob = c(0.4, 0.4, 0.2))

# Formulate churn logic: higher churn for low tenure, high monthly charges, and month-to-month contracts
churn_prob <- 0.1 + 
  ifelse(tenure_months < 12, 0.3, 0) + 
  ifelse(monthly_charges > 80, 0.2, 0) + 
  ifelse(contract_type == "Month-to-month", 0.2, -0.2) +
  ifelse(internet_service == "Fiber optic", 0.1, 0)

# Cap probabilities between 0.05 and 0.95
churn_prob <- pmin(pmax(churn_prob, 0.05), 0.95)

# Generate Churn labels based on probabilities
churn <- rbinom(n, 1, churn_prob)
churn <- ifelse(churn == 1, "Yes", "No")

# Create dataframe
churn_data <- data.frame(
  CustomerID = customer_id,
  Age = age,
  Tenure = tenure_months,
  MonthlyCharges = monthly_charges,
  TotalCharges = total_charges,
  Contract = as.factor(contract_type),
  InternetService = as.factor(internet_service),
  Churn = as.factor(churn)
)

# Create data directory if it doesn't exist
dir.create("data", showWarnings = FALSE)

# Save to CSV
write.csv(churn_data, "data/customer_churn.csv", row.names = FALSE)
cat("Data generated successfully and saved to 'data/customer_churn.csv'\n")
