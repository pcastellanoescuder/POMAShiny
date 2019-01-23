
### Input Data Panel

This panel allows user upload his data to be analyzed in POMA.  

**Metabolomic Data**: Each row denotes a sample and each column denotes a metabolite.  
**Covariates file (optional)**: Each row denotes a sample (the same as in metabolomic data) and each column denotes covariate.

**Exploratory report:** You will find a green button with the name "Exploratory report" in the top of central panel. If you "click" this button POMA will generate an automatically exploratory report of your data.  

If you want to upload your data, please select "**No, upload my own data**" button and remember that:    

- Your metabolomic matrix must be a .CSV (*comma-separated-value*) file.
- First/Left-hand column must be sample IDs.
- Second/Left-hand column must be sample groups.
- Ideally, first row should be column names (metabolites). If not, don't worry, POMA will can deal with it if you "click" on **Header** button.  

If you want include a covariates file, please, upload it in "**Upload your covariates file**" and remember:

- Covariates file must be a .CSV (*comma-separated-value*) file.
- First/Left-hand column must be sample IDs. This sample IDs must be same rownames (IDs) than metabolites matrix IDs.  

In case of that you only want is try POMA and you don't have your own dataset... We offer a dataset (default) of a colorectal cancer metabolomic study (from <a href="https://www.metabolomicsworkbench.org/data/DRCCMetadata.php?Mode=Study&StudyID=ST000284&StudyType=MS&ResultType=1">Metabolomics workbench</a>  ). This option also include a covariates file of the study.  

<a href="https://pubs.acs.org/doi/abs/10.1021/pr500494u"><i>Zhu, J., Djukovic, D., Deng, L., Gu, H., Himmati, F., Chiorean, E. G., & Raftery, D. (2014). Colorectal cancer detection using targeted serum metabolic profiling. Journal of proteome research, 13(9), 4120-4130.</i></a>   

**NOTE:** _Know that we have modified this dataset so that you can try all the options that POMA offers you._    

---

### Imputation missing values Panel

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

---

### Normalization Panel

This panel include different normalization methods for your **metabolomic** matrix. This step is required to make all metabolites comparable among them. By default the application do not normalize data, however it is recommended to select one normalization method. 

POMA app offers all these following different types of normalization methods:  

| Method 	| Unit 	| Goal 	| Advantages 	| Disadvantages 	|
|--------------------	|---------	|------------------------------------------------------------------------------------------	|-------------------------------------------------------------------	|---------------------------------------------------------------------------	|
| Autoscaling 	| (-) 	| Compare metabolites based on correlations 	| All metabolites become equally important 	| Inflation of the measurement errors 	|
| Level scaling 	| (-) 	| Focus on relative response 	| Suited for identification of e.g. biomarkers 	| Inflation of the measurement errors 	|
| Log scaling 	| Log (-) 	|  	|  	|  	|
| Log transformation 	| Log O 	| Correct for heteroscedasticity, pseudo scaling. Make multiplicative models additive 	| Reduce heteroscedasticity, multiplicative effects become additive 	| Difficulties with values with large relative standard deviation and zeros 	|
| Vast scaling 	| (-) 	| Focus on the metabolites that show small fluctuations 	| Aims for robustness, can use prior group knowledge 	| Not suited for large induced variation without group structure 	|
| Log pareto scaling 	| Log (-) 	| Reduce the relative importance of large values, but keep data structure partially intact 	| Stays closer to the original measurement than autoscaling 	| Sensitive to large fold changes 	|   


<a href="https://bmcgenomics.biomedcentral.com/articles/10.1186/1471-2164-7-142"><i>van den Berg, R. A., Hoefsloot, H. C., Westerhuis, J. A., Smilde, A. K., & van der Werf, M. J. (2006). Centering, scaling, and transformations: improving the biological information content of metabolomics data. BMC genomics, 7(1), 142.</i></a>   

User can check the normalization effect on the data for all methods by visualising the interactive boxplots tabs that are in "**Normalized Data**" panel. As more similar are the boxes in the "y" axis as better is the normalization.  

---

<img src="pix/flowchart.pdf" alt="flowchart" title="Stats Flowchart" width="600" height="800" />



