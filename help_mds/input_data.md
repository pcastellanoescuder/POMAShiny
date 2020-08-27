
The "Upload Data" panel allows user to upload data to be analyzed in POMAShiny.  

**Target File**

A .CSV with two columns:

  - First/Left-hand column must be sample IDs.
  - Second/Left-hand column must be sample group/factor (e.g. treatment).

**Features File**

A .CSV with *n* columns:

  - Each row denotes a sample and each column denotes a feature.
  - First row must contain feature names.

**Covariates file (optional)**

A .CSV with *n* columns:

  - First/Left-hand column must be sample IDs (and must be equal than target file first column).
  - Each row denotes a sample (the same as in target and features files) and each column denotes a covariate.

**Exploratory report:** You will find a green button with the name "Exploratory report" in the top of central panel. If you "click" this button POMA will generate an automatically exploratory report of your data.    

In case of that you only want is try POMA and you don't have your own dataset... We offer a dataset of a colorectal cancer metabolomic study (from Metabolomics Workbench). This option also include a covariates file of the study.  

<a href="https://pubs.acs.org/doi/abs/10.1021/pr500494u"><i>Zhu, J., Djukovic, D., Deng, L., Gu, H., Himmati, F., Chiorean, E. G., & Raftery, D. (2014). Colorectal cancer detection using targeted serum metabolic profiling. Journal of proteome research, 13(9), 4120-4130.</i></a>   

**NOTE:** _Know that we have modified this dataset so that you can try all the options that POMA offers you._  