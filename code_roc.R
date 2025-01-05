set.seed(123)  # For reproducibility

# Simulate true labels (0 or 1) for 100 observations
true_labels <- sample(c(0, 1), 100, replace = TRUE)

# Simulate predicted probabilities for the positive class (between 0 and 1)
predicted_probs <- runif(100)
# Define thresholds from 0 to 1
thresholds <- seq(0, 1, by = 0.01)

# Initialize vectors to store TPR and FPR values
tpr_values <- numeric(length(thresholds))
fpr_values <- numeric(length(thresholds))

# Calculate TPR and FPR at each threshold
for (i in 1:length(thresholds)) {
  threshold <- thresholds[i]
  
  # Classify samples based on the threshold
  predicted_class <- ifelse(predicted_probs >= threshold, 1, 0)
  
  # Calculate confusion matrix components
  TP <- sum((predicted_class == 1) & (true_labels == 1))  # True Positives
  FP <- sum((predicted_class == 1) & (true_labels == 0))  # False Positives
  TN <- sum((predicted_class == 0) & (true_labels == 0))  # True Negatives
  FN <- sum((predicted_class == 0) & (true_labels == 1))  # False Negatives
  
  # Calculate TPR and FPR
  tpr_values[i] <- TP / (TP + FN)
  fpr_values[i] <- FP / (FP + TN)
}

# View first few TPR and FPR values
head(data.frame(thresholds, tpr_values, fpr_values))

# Plot ROC curve
plot(fpr_values, tpr_values, type = "l", col = "blue", 
     xlab = "False Positive Rate (FPR)", ylab = "True Positive Rate (TPR)", 
     main = "ROC Curve", lwd = 2)
abline(a = 0, b = 1, col = "red", lty = 2)  # Add a diagonal line (random classifier)
