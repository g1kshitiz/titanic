### Titanic: Predicting Survival of Passengers
## Machine Learning Implementations

options(digits = 5)
library(titanic)
library(dplyr)
library(caret)
#library(ggplot2)
# load data sets
data("titanic_train")

seed <- 2

summary(titanic_train)
#str(titanic_train)
## cleaning the data and removing certain features:
# name, passengerId (irrelevant), cabin (sparse data)
titanic_clean <- titanic_train %>%
  mutate(Survived = factor(Survived),
         Embarked = factor(Embarked),
         # set median age to all NA values
         Age = ifelse(is.na(Age), median(Age, na.rm = TRUE), Age),
         # count family members (siblings/spouses + parents/children)
         FamilySize = SibSp + Parch + 1) %>%
  select(Survived, Pclass, Sex, Age, SibSp, Parch, FamilySize, Fare, Embarked)

set.seed(3)
test_index <- createDataPartition(titanic_clean$Survived, p = 0.25, list = FALSE)

test_set <- titanic_clean %>% slice(test_index)
train_set <- titanic_clean %>% slice(-test_index)

## Data Types:
# Survived: non-ordinal categorical
# Pclass: ordinal categorical
# Sex: non-ordinal categorial
# Age: discrete
# SibSp: discrete
# Parch: discrete
# FamilySize: discrete
# Fare: continuous
# Embarked: non-ordinal categorical

save.image(file = "titanic.RData")

