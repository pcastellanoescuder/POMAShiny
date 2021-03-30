
In this panel users can upload their data to be analyzed in POMAShiny. Data format must be a CSV (*comma-separated-value*) file.

#### Target File

A .CSV with two mandatory columns + *n* optional covariates:

  - Each row denotes a sample (the same as in the features file)
  - First/Left-hand column must be sample IDs => red
  - Second/Left-hand column must be sample group/factor (e.g. treatment) => green
  - Covariates (optional): From the third column (included) users can also include several study covariates => purple

Once target file has been uploaded, users can select those rows that will be analyzed in the "Target File" panel. If any selection is done, only selected rows will be analyzed in POMAShiny, if not (default) all rows (samples) will be included in the analysis.

#### Features File

A .CSV with *m* columns:

  - Each row denotes a sample and each column denotes a feature
  - First row must contain the feature names

#### Grouping File (optional)

POMAShiny allows to combine features applying a summarization function to sets of features as defined by a "Grouping File" (see "Help" panel). This feature is powered by the `MSnbase` R/Bioconductor package and it is very useful when the data contain different peptides of the same protein or different ions of the same compound, which is a common scenario in MS data analysis.

The grouping file must be a three-column CSV containing the original feature names (first column), the grouping factor (second column), and the new feature names (third column) **in the same order as Features File**. Read carefully the `MSnbase` package documentation for this function [here](https://lgatto.github.io/MSnbase/reference/combineFeatures.html).

Five summarization methods are provided to do this process: "sum", "mean", "median", "robust", and "NTR". Once this process is complete, the coefficient of variation of combined features is shown as a downloadable table in the "Combined Features Coefficient of Variation" tab.

**NOTE:** Authors recommend to read carefully the [documentation](https://lgatto.github.io/MSnbase/reference/combineFeatures.html) and to check provided [example data](https://github.com/pcastellanoescuder/POMAShiny/tree/master/example_data) before use this feature.   

#### Exploratory report

After uploading the data **and clicking the "Submit" button**, POMAShiny allows users to generate an exploratory data analysis PDF report automatically by clicking the green button with the label "Exploratory report" in the top of the central panel. See a PDF report example [here](https://pcastellanoescuder.github.io/POMA/articles/POMA-eda.html).

#### Example data

POMAShiny includes two example datasets that are both freely available at https://www.metabolomicsworkbench.org. The first example dataset consists of a targeted metabolomics three-group study and the second example dataset consists of a targeted metabolomics two-group study. These two datasets allow users to explore all available functionalities in POMAShiny. Both dataset documentations are available at https://github.com/pcastellanoescuder/POMA.    

Alternatively, an example data (CSV format) including a grouping file is also provided in order to test the "Combine features" operation. These example data are available [here](https://github.com/pcastellanoescuder/POMAShiny/tree/master/example_data).  

**NOTE:** Once target and features files are uploaded and the desired rows are selected in the target file (if necessary), users must have to click the "Submit" button to continue with the analysis.

