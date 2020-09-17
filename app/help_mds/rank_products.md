
The rank product is a biologically motivated test for the detection of differential expressed/concentrated features in high throughput experiments. It's a non-parametric statistical method based on the ranks of fold changes. Over the last years this methodology has become popular in many omics fields such as transcriptomics, metabolomics and proteomics.    

Rank product test in POMAShiny skips the normalization and outlier detection steps to avoid possible negative values generated in the normalization process. Consequently, this method is based on the imputed data and all samples will be used to perform the analysis. If the user wants to remove some detected outliers from this test, it's possible to select all samples except the detected outliers in the Upload Data panel -> Target File tab table and repeat the imputation step.       

In the Rank Products panel, users can select if their data is paired or not and the possibility to apply a log2 transformarion over each feature (default). Also the method to perform the test (percentage of false prediction or p-value) and the cutoff can be modulated by users. For more details see <a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5860065/"><i>Del Carratore, F., Jankevics, A., Eisinga, R., Heskes, T., Hong, F.,
Breitling, and R. (2017) RankProd 2.0: a refactored Bioconductor package for detecting differentially expressed features in molecular profiling datasets. Bioinformatics, 33, 2774–2775.</i></a>      

