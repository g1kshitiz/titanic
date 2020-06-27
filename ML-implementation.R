##################################################
##
## Machine Learning Models
##
##################################################
library(dplyr)
library(caret)
library(lattice)
load("titanic.RData")

## Baseline prediction by guessing the outcome
# Simplest prediction method is randomly guessing the outcome
# without any use of predictors
set.seed(seed)
y_hat_guess <- sample(c(0, 1), nrow(test_set), replace = TRUE) %>%
  factor(levels = levels(train_set$Survived))
result <- tibble(method = "Guessing",
                 train_accuracy = NA,
                 accuracy = mean(y_hat_guess == test_set$Survived),
                 F1_score = F_meas(data = y_hat_guess, reference = test_set$Survived))

## Logistic Regression
fit_glm <- train(Survived ~ ., data = train_set, method = "glm")

y_hat_glm <- predict(fit_glm, test_set) %>%
  factor(levels = levels(train_set$Survived))

# We get a warning that "prediction from a rank-deficient fit
# may be misleading. Thus, we know that some of our feattures
# are correlated.

result <- add_row(result, method = "Logistic Regression",
                  train_accuracy = fit_glm$results$Accuracy,
                  accuracy = mean(y_hat_glm == test_set$Survived),
                  F1_score = F_meas(data = y_hat_glm, reference = test_set$Survived))

## k Nearest Neighbors
set.seed(seed)
fit_knn <- train(Survived ~ ., data = train_set, method = "knn",
                 trControl = trainControl(method = "cv", number = 10, p = 0.9),
                 tuneGrid = data.frame(k = seq(3, 37, 2)))

plot(fit_knn)

y_hat_knn <- predict(fit_knn, test_set) %>%
  factor(levels = levels(train_set$Survived))
result <- add_row(result, method = "k Nearest Neighbors",
                  train_accuracy = max(fit_knn$results$Accuracy),
                  accuracy = mean(y_hat_knn == test_set$Survived),
                  F1_score = F_meas(data = y_hat_knn, reference = test_set$Survived))

## rpart
set.seed(seed)
fit_rpart <- train(Survived ~ .,
                   method = "rpart",
                   tuneGrid = data.frame(cp = seq(0, 0.05, 0.002)),
                   data = train_set)
fit_rpart$bestTune

y_hat_rpart <- predict(fit_rpart, test_set) %>%
  factor(levels = levels(train_set$Survived))

result <- add_row(result, method = "rpart",
                  train_accuracy = max(fit_rpart$results$Accuracy),
                  accuracy = mean(y_hat_rpart == test_set$Survived),
                  F1_score = F_meas(data = y_hat_rpart, reference = test_set$Survived))
plot(fit_rpart)

## Random Forest
set.seed(seed)
fit_rf <- train(Survived ~ .,
                method = "rf",
                tuneGrid = data.frame(mtry = seq(1, 7)),
                importance = TRUE,
                data = train_set)
fit_rf$bestTune

y_hat_rf <- predict(fit_rf, test_set) %>%
  factor(levels = levels(train_set$Survived))
result <- add_row(result, method = "Random Forest",
                  train_accuracy = max(fit_rf$results$Accuracy),
                  accuracy = mean(y_hat_rf == test_set$Survived),
                  F1_score = F_meas(data = y_hat_rf, reference = test_set$Survived))

varImp(fit_rf)

## Linear Discriminant Analysis

# lda using the more important variables
set.seed(seed)
fit_lda <- train(Survived ~ Sex + Fare + Age + Pclass + FamilySize, data = train_set, method = "lda")

y_hat_lda <- predict(fit_lda, test_set) %>%
  factor(levels = levels(train_set$Survived))

result <- add_row(result, method = "Linear Discriminant Analysis",
                  train_accuracy = fit_lda$results$Accuracy,
                  accuracy = mean(y_hat_lda == test_set$Survived),
                  F1_score = F_meas(data = y_hat_lda, reference = test_set$Survived))

result %>% knitr::kable()
  
## Final Model
## Random Forest

