
  #### Limma
  
  *linear models for microarray and RNA-Seq Data*. This function is
implemented in limma R package and is prepared to perform a singl-sample
t-test using an empirical Bayes method to borrow information between
features. The final output is a list of features with a column with a
value of the contract (logFC). The AveExpr column gives the average
log2-expression level for that gene across all the arrays and channels
in the experiment. Column t is the moderated t-statistic. Column P.Value
is the associated p-value and adj.P.Value is the p-value adjusted for
multiple testing by false discovery rate (FDR).

#### Correlation analysis

The Correlation analysis tab includes two different ways to visualize
the correlations in your data.

- Pairwise Correlation Scatterplot: This scatterplot show the
correlation (and p-value of this correlation) between two features
in the data. The user can choose any pair of features in the dataset
and modify the correlation method (pearson, spearman or kendall) in
a reactive, fast and easy panel.

<img src="pix/simple_correlations.png" width="70%" />
  
  - Global Correlation Heatmap: Where you can see the correlation matrix
of your data in a heatmap format. This plot show all correlations in
data at the same time.


  


