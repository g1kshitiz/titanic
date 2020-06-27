####################################################
## 
## Exploratory Data Analysis
##
####################################################
library(ggplot2)
library(dplyr)
load("titanic.RData")

## Demographics of Titanic Passengers
## faceted by sex
train_set %>%
  ggplot(aes(Age, fill = Sex)) +
  geom_density(alpha = 0.2) +
  facet_grid(Sex ~ .)

# We see that the age distribution of both males and
# females had the same general shape

## stacked plot
train_set %>%
  ggplot(aes(Age, y = ..count.., fill = Sex)) +
  geom_density(alpha = 0.2) # position = "stack")

# Age distributions are bimodal with one mode around
# 28 and another mode near 2-4 years

## QQ-plot of Age distribution
train_set %>%
  ggplot(aes(sample = Age)) +
  geom_qq(dparams = summarize(train_set, mean = mean(Age), sd = sd(Age) )) +
  geom_abline()

## Exploring Survival based on Sex
train_set %>%
  ggplot(aes(Survived, fill = Sex)) +
  geom_bar() #position = position_dodge())

train_set %>%
  ggplot(aes(Sex, fill = Survived)) +
  geom_bar() #position = position_dodge())

# It can be seen that less than half of the total passengers survived.
# Moreover, most of the survivors were female. 
# Furthermore, most females survived, but most males did not.


## Exploring Survival based on Age
train_set %>%
  ggplot(aes(Age, y = ..count.., fill = Survived)) +
  geom_density(alpha = 0.2) 

# It is seen that children (aged 0 to 8 years old) are the only
# age group more likely to survive than die
# Similarly, the age group of around 18-30 had the most deaths
# Furthermore, people above the age 70 had the highest proportion of deaths


## Survival by Fare
train_set %>%
  filter(Fare > 0) %>%
  ggplot(aes(Survived, Fare)) +
  geom_boxplot() +
  scale_y_continuous() +
  geom_jitter(alpha = 0.2)

# It is seen that suviving passengers paid higher fares in general. 
# Moreover, the surviving group had a higher median fare.

## Survival by Passenger Class
train_set %>%
  ggplot(aes(Pclass, fill = Survived)) +
  geom_bar() +
  xlab("Passenger Class")

# We see that there were more passengers in the third class than the
# other two classes combined.
# Moreover, the survival rate was highest for first class 
# passengers, followed by second class passengers and then those
# in the third class
# Also, the majority of deaths occurred among the passengers
# in third class.

train_set %>%
  ggplot(aes(Age, y = ..count.., fill = Survived)) +
  geom_density(position = "stack") +
  facet_grid(Sex ~ Pclass)

## Survival by Family Size
train_set %>%
  ggplot(aes(FamilySize, y = ..count.., fill = Survived)) +
  geom_density() 

# Siblings and Spouse
train_set %>%
  ggplot(aes(SibSp, y = ..count.., fill = Survived)) +
  geom_density() 

# Parents and Children
train_set %>%
  ggplot(aes(Parch, y = ..count.., fill = Survived)) +
  geom_density() 


## We see that people who boarded the titanic without any
# relatives had the highest deaths. Similarly, people with 3 or
# three or more siblings are more likely to die than to
# survive
train_set %>%
  ggplot(aes(FamilySize, y = ..count.., fill = Survived)) +
  geom_density(position = "stack") +
  facet_grid(Pclass ~ .)

# Not surprisingly, we see that people with three or more relatives
# tend to be in third class.

