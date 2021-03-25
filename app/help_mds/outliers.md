
POMAShiny allows the analysis of outliers by different plots and tables as well as the possibility to remove statistical outliers from the analysis using different customizable parameters.    

The method implemented in POMAShiny is based on the distances among observations (euclidean by default) and their distances to each group centroid in a two-dimensional space. Once this is computed, the classical univariate outlier detection formula _Q3 + x*IQR_ is used to detect multivariate group-dependant outliers using the computed distance to each group centroid.    

Select the method (distance), type and coefficient (_x_; the higher this value, the less sensitive the method is to outliers) to adapt the outlier detection method to your data. By switching the button "Show labels" all plots display automatically the sample IDs in the outlier detection plots.

  - Distances Polygon Plot: Group centroids and sample coordinates in a two-dimensionality space
  - Distances Boxplot: Boxplots of all computed distances to group centroid by group

**NOTE:** If the "Remove outliers" button is turned on (default), all detected outliers are excluded from the analysis automatically. 
