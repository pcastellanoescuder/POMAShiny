
POMAShiny provides different options to conduct an accurate and interactive correlation analysis. In the "Correlation parameters" menu users can select the correlation method (pearson, spearman or kendall) to be used for all available visualizations explained below.        

##### Pairwise Correlation Scatterplot

POMAShiny provides a highly modulable and interactive scatterplot of pairwise correlation between features. Here, users can select two desired features and explore them in a very comfortable way, being able to remove some points of the plot by clicking over, drawing a smoth line based on a linear model, showing the sample IDs instead of points or exploring and comparing pairwise correlations within each study group (factor).     

##### Pairwise Correlation Table

A table with all pairwise correlations in the data. This table can be sorted by all different columns and it can be downloaded in different formats.   

##### Correlogram

A global correlation plot or correlogram is provided in this tab. This plot allows users to visualize all correlations in the data at once. Users can control the label size by clicking in the upper left corner menu.   

##### Correlation Network

POMAShiny offers a correlation network visualization, where correlations between features can be observed in a very clear way. Only pairs of features with a correlation absolute value over "Correlation Cutoff" indicated in the upper left corner menu are shown.   

##### Gaussian Graphical Models

POMAShiny provides an alternative method for correlation network visualization. Estimation of gaussian graphical models through `glasso` R package is provided in this tab. Users can define the regularizarion parameter to estimate an sparse inverse correlation matrix using lasso in the upper left corner menu.  

