
POMAShiny offers three different wide used regularization methods both for feature selection and prediction model creation purposes. These methods are lasso, ridge regression and elasticnet. All of these methods are based on penalized logistic regression and are therefore only available for two-group studies. If the purpose is not predictive, users can set the test parameter to zero. Otherwise, if the purpose is to build a predictive model, users can select the proportion (%) of samples that are used as a test set.     

- Test partition (%): Percentage of observations that are used as test set. These samples are used only to perform an external validation. If this value is set to zero, all samples are used to create the model and no external validation is computed
- Internal CV folds: Number of folds for CV (default is 10). This value can be as large as the sample size (leave-one-out CV), it is not recommended for large datasets. Smallest value allowable 3    
- Elasticnet Mixing Parameter (only for elasticnet): This value corresponds to the alpha (or penalty) parameter     

