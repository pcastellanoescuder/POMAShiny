
Unlike univariate methods, multivariate methods are focused in the study of more than one feature at a time. These type of approaches have been widely used because their informativeness. Since being more complex than conventional univariate statistics, these methods can provide information about the structure of the data and different internal relationships that would not be observed with univariate statistics. However, the interpretation of these type of analysis can be more complex.     
##### PCA (principal component analysis)

PCA is one of the most used methods for data dimension reduction. POMAShiny allows users to compute a PCA controlling different parameters:

  - Number of components: This number indicates the number of components that are calculated
  - Scale and Center: By default these parameters are disabled. If the data have been normalized
  - Show ellipses: By turning on this button, the ellipses computed assuming a multivariate normal distribution are drawn in a score plot and biplot

##### PLS-DA (partial least squares discriminant analysis)

PLS-DA is a supervised method that uses the multiple linear regression method to find the direction of maximum covariance between the data and the sample group. POMAShiny allows users to compute a PLS-DA controlling different parameters:

  - Number of components: This number indicates the number of components that are calculated
  - VIP cutoff: This value indicates the variable importance in the projection (VIP) cutoff. Features shown in the VIP plot tab are based on this value. Only features with a VIP higher than this value are shown in the plot. This is a reactive option, it means that users doesn't have to recalculate a PLS-DA to change this value, it can be changed and the VIP plot are updated automatically without doing anything more
  - Show ellipses: By turning on this button (default), the ellipses computed assuming a multivariate normal distribution are drawn in a score plot
  - Validation type: Internal validation to use, options are "Mfold" (default) or "Leave One Out"
  - Number of folds: Number of folds for Mfold validation method (default is 5). If the validation method is loo, this value will become to 1
  - Number of iterations for validation process: Number of iterations for the validation method selected

##### sPLS-DA (sparse partial least squares discriminant analysis)

Often, sPLS-DA method is used to classify samples (supervised analysis) and to select features. POMAShiny allows users to compute a sPLS-DA controlling different parameters:

  - Number of components: This number indicates the number of components that are calculated
  - Number of features: The number of features to keep in the model
  - Show ellipses: By turning on this button (default), the ellipses computed assuming a multivariate normal distribution are drawn in a score plot
  - Validation type: Internal validation to use, options are "Mfold" (default) or "Leave One Out"
  - Number of folds: Number of folds for Mfold validation method (default is 5). If the validation method is loo, this value will become to 1
  - Number of iterations for validation process: Number of iterations for the validation method selected
  
  