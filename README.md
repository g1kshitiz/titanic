# titanic
This project predicts whether a given passenger on the Titanic would survive based on given features using some popular machine learning algorithms.
The original 'titanic' library contains a 'titanic_train' and a 'titanic_test' dataset. However, the outcomes for the test dataset is not known.
Thus, the 'titanic_train' dataset from the 'titanic' library is first split into a training set and a test set.

wrangle-data.R - creates a modified dataset, then splits it into a training set and a test set, and finally saves the data as R object.

exploratory-data-analysis.R - generates plots and explores relationships between survival and every other feature.

ML-implementation.R - implements machine learning algorithms and examines the accuracy on the test set.
