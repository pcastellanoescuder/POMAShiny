
Cluster analysis is also a multivariate method like the previous ones. However, it is in a separate section only to make the app and the analysis more understandable. POMAShiny allows users to compute easily a cluster analysis using the _k_-means algorithm.       

##### _k_-means

_k_-means is an unsupervised method that aims to assign each sample of the study to one of _k_ clusters based on the sample means and the nearest cluster centroid. Different parameters are available for the calculation and visualization of clusters.

  - Method: Distance used to calculate the multi dimensional scaling (MDS). Detailed below
  - Number of clusters (_k_): Number of clusters that are calculated
  - Show clusters: _k_ different clusters are projected in the MDS plot. By turning off this button a simple MDS plot are displayed
  - Show labels: By turning on this button sample IDs are shown in the plot. If this option is enabled, an additional button is displayed:
    - Show group: By turning on this option, sample IDs are replaced by group labels

##### MDS (multi dimensional scaling)

Since _k_-means is a multivariate method, POMAShiny uses the two first dimensions of a classical MDS to project the computed clusters. By turning off the "Show clusters" button, users visualize a plain MDS plot. Labeling options are the same for both scenarios.    

Both two first dimensions of MDS and calculated _k_ clusters are available in the "Cluster Table" tab.    

