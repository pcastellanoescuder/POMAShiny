
Usually, metabolomics data have a high number of missing values. This is, in major part, due to low signal intensity of peaks.       

In the imputation process POMA is divided in two steps:   

1. Remove all metabolites of the data that have more of specific percentage (defined by user) of missing values in one or more study groups. By default this parameter is 20%. POMA will remove of the dataset metabolites that have more than percentage selected by user of missing values at least one of the groups.

2. POMA offers six types of imputation methods that are: 

  - replace missing values (NA) by zero
  - replace missing values (NA) by half of the minimum positive value in the original data (in each column)
  - replace missing values (NA) by the median of the column (metabolite)
  - replace missing values (NA) by the mean of the column (metabolite)
  - replace missing values (NA) by the minimum value in the column (metabolite range)
  - replace missing values (NA) using KNN method   
  

<a href="https://onlinelibrary.wiley.com/doi/full/10.1002/elps.201500352"><i>Armitage, E. G., Godzien, J., Alonso‐Herranz, V., López‐Gonzálvez, Á., & Barbas, C. (2015). Missing value imputation strategies for metabolomics data. Electrophoresis, 36(24), 3050-3060.</i></a>  

