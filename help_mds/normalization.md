
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