
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

In case of that you only want is try POMA and you don't have your own dataset... We offer a dataset (default) of a colorectal cancer metabolomic study (from Metabolomics Workbench). This option also include a covariates file of the study.  

_Zhu, J., Djukovic, D., Deng, L., Gu, H., Himmati, F., Chiorean, E. G., & Raftery, D. (2014). **Colorectal cancer detection using targeted serum metabolic profiling**. Journal of proteome research, 13(9), 4120-4130._  

**NOTE:** _Know that we have modified this dataset so that you can try all the options that POMA offers you._    

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


From: _van den Berg, R. A., Hoefsloot, H. C., Westerhuis, J. A., Smilde, A. K., & van der Werf, M. J. (2006). **Centering, scaling, and transformations: improving the biological information content of metabolomics data.** BMC genomics, 7(1), 142._   

User can check the normalization effect on the data for all methods by visualising the interactive boxplots tabs that are in "**Normalized Data**" panel. As more similar are the boxes in the "y" axis as better is the normalization.  

---

























