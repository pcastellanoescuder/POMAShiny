
In this panel users can upload their data to be analyzed in POMAShiny. Data format must be a CSV (*comma-separated-value*) file.

#### Target File

A .CSV with two mandatory columns + *n* optional covariates:

  - Each row denotes a sample (the same as in the features file)
  - First/Left-hand column must be sample IDs => red
  - Second/Left-hand column must be sample group/factor (e.g. treatment) => green
  - Covariates (optional): From the third column (included) users can also include several experiment covariates => purple

Once this file has been uploaded, users can select desired rows in the "Target File" panel table to create a subset of the whole uploaded data. If this selection is done, only selected rows are analyzed in POMAShiny, if not (default) all uploaded data are analyzed.

#### Features File

A .CSV with *m* columns:

  - Each row denotes a sample and each column denotes a feature
  - First row must contain the feature names

#### Exploratory report

After uploading the data **and clicking the "Submit" button**, POMAShiny allows users to generate an exploratory data analysis PDF report automatically by clicking the green button with the label "Exploratory report" in the top of the central panel. See a PDF report example [here](https://pcastellanoescuder.github.io/POMA/articles/POMA-eda.html).

#### Example data

POMAShiny includes two example datasets that are both freely available at https://www.metabolomicsworkbench.org. The first example dataset consists of a targeted metabolomics three-group study and the second example dataset consists of a targeted metabolomics two-group study. These two datasets allow users to explore all available functionalities in POMAShiny. Both dataset documentations are available at https://github.com/pcastellanoescuder/POMA.

**NOTE:** Once target and features files are uploaded and the desired rows are selected in the target file (if necessary), users must have to click the "Submit" button to continue with the analysis.

