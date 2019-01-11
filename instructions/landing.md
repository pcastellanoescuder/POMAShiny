
### Why POMA?

<h4><b><span style="color:#f49338">Fast:</span></b> Analyze and visualize your data in few steps</h4>
<h4><b><span style="color:#f49338">Friendly:</span></b> POMA is very intuitive and no needed programming skills in any step of workflow</h4>
<h4><b><span style="color:#f49338">Free:</span></b> All POMA options and analysis are completely free for all users</h4>

### Input Data 

- Upload your data in the *"Input Data"* tab.   
- Data must be a .CSV *comma-separated-value* file.
- First/Left-hand column must be sample IDs.
- Second/Left-hand column must be sample groups.
- Ideally, first row should be column names (metabolites).  

**Metabolomic Data**

  - Each row denotes a sample and each column denotes a metabolite.

<img src="pix/met_data.png" alt="Metabolites" title="Metabolomic Data" width="600" height="250" />

**Covariates file (optional)**

  - Each row denotes a sample (the same as in metabolomic data) and each column denotes covariate.

<img src="pix/cov_data.png" alt="Covariates" title="Covariates File" width="500" height="180" />  

### Impute Values

Metabolomics data usually presents a high number of missing values. By default, the missing values are treated as the result of low signal intensity.   

For this reason, the imputation of missing values is an essential step in metabolomic data analysis workflow. To deal with that, POMA provides the **Impute Value** panel which allows the user: 

1. To remove all metabolites of the data that have more of specific percentage (defined by user) of missing values in one or more study groups. By default this parameter is 20%.  

2. To impute missing values of the data using different methods such as:

  - replace by zero
  - replace by half of the minimum positive value in the original data (default)
  - replace by median
  - replace by mean
  - replace by minimum
  - KNN method   

### Normalization

Normalization is required to make all metabolites comparable among them. By default the application do not normalize data, however it is recommended to select one normalization method. POMA app offers all these following different types of normalization methods:  

  - Autoscaling 
  - Level scaling
  - Log scaling
  - Log transformation
  - Vast scaling
  - Log Pareto

### Statistics

The Statistical Analysis tab contains a set of different panels to analyze the data:  1) Univariate analysis; 2) Multivariate analysis; 3) Correlations; 4) Random Forest; 5) Feature selection and 6) Rank Products. Each one of them includes different options and methods. Below is a brief explanation of each one:  

#### Univariate analysis

<img src="pix/volcano.png" alt="VOLCANO" title="VOLCANO PLOT" width="400" height="180" /> 

The Univariate Analysis panel contains three types of analysis to perform comparaisions of each group per each metabolite.  

  - limma: _linear models for microarray and RNA-Seg Data_. This function is implemented in limma R package and is prepared to perform a singl-sample t-test using an empirical Bayes method to borrow information between metabolites. The final output is a list of metabolites with a column with a value of the contract (logFC). The AveExpr column gives the average log2-expression level for that gene across all the arrays and channels in the experiment. Column t is the moderated t-statistic. Column P.Value is the associated p-value and adj.P.Value is the p-value adjusted for multiple testing by false discovery rate (FDR).  
  - T-test. The results can be shown with a interactive volcano plot easy to modify and download.  
  - One-way Analysis of Variance (ANOVA). If data has more than two groups. 
  
<sub><i>All of the previous methods can be corrected by covariables if the user has provided a covariate matrix.</i></sub> 

#### Multivariate analysis

<img src="pix/pca.png" alt="PCA" title="PCA" width="400" height="180" /> 
<img src="pix/plsda.png" alt="PLSDA" title="PLSDA" width="400" height="180" /> 
<img src="pix/plsda_errors.png" alt="PLSDAERR" title="PLSDA ERRORS" width="400" height="180" /> 
<img src="pix/splsda.png" alt="SPLSDA" title="SPLSDA" width="400" height="180" /> 

This step is powered by mixOmics R package. POMA multivariate analysis includes three principal multivariate methods:

  - Principal Component Analysis (PCA)
  - Partial Least Squares Discriminant Analysis (PLS-DA)
  - Sparse Partial Least Squares Discriminant Analysis (sPLS-DA)

#### Correlations

<img src="pix/correlations.png" alt="CORR" title="CORRELATIONS" width="400" height="180" /> 
<img src="pix/global_correlations.png" alt="GCORR" title="GLOBAL CORRELATIONS" width="400" height="180" /> 
#### Random Forest

<img src="pix/random_forest.png" alt="RANDOMFOR" title="RANDOM FOREST" width="400" height="180" /> 

#### Feature Selection

<img src="pix/lasso.png" alt="LASSO" title="LASSO" width="400" height="180" /> 

In statistics, feature selection, also known as variable selection, is the process of selecting a subset of relevant features (for example, variables) for use in model construction.   

POMA includes a section thought specified for feature selection. This section includes two of the most used methods for this purpose.

  - Ridge regression
  - Lasso

#### Rank Products

<img src="pix/rankprod.png" alt="RANKPROD" title="RANK PRODUCTS" width="400" height="180" /> 

