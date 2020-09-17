
Usually, mass spectrometry faces with a high number of missing values, most of them due to low signal intensity of peaks. Missing value imputation process in POMAShiny is divided in three sequential steps:   

1. Distinguish between zeros and missing values. In case of the data have values of these two types users can distinguish or not between them. This option may be useful in experiments combining endogenous and exogenous features, as in this case the exogenous ones could be a real zero (absence) and the endogenous ones are unlikely to be real zeros.

2. Remove all features of the data that have more of a specific percentage (defined by user) of missing values in ALL study groups. By default this percentage is 20%.

3. Imputation. POMAShiny offers six different methods to impute missing values: 

  - replace missing values by zero
  - replace missing values by half of the minimum positive value in the original data (in each column)
  - replace missing values by the median of the column (feature)
  - replace missing values by the mean of the column (feature)
  - replace missing values by the minimum value in the column (feature)
  - replace missing values using KNN algorithm (default)   
  
<a href="https://onlinelibrary.wiley.com/doi/full/10.1002/elps.201500352"><i>Armitage, E. G., Godzien, J., Alonso‐Herranz, V., López‐Gonzálvez, Á., & Barbas, C. (2015). Missing value imputation strategies for metabolomics data. Electrophoresis, 36(24), 3050-3060.</i></a>     

