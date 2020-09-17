
Limma (Linear Models for Microarray Data) was created for the statistical analysis of gene expression experiments as microarrays. However, over the last years this method has been user in many other omics such as metabolomics or proteomics.     

Limma performs a single-sample T-test using an empirical Bayes method to borrow information between all features. This method _"leverages the highly parallel nature of features to borrow strength between the feature-wise models, allowing for different levels of variability between features and between samples, and making statistical conclusions more reliable when the number of samples is small"_. See <a href="https://academic.oup.com/nar/article/43/7/e47/2414268"><i>Ritchie, M. E., Phipson, B., Wu, D., Hu, Y., Law, C. W., Shi, W., & Smyth, G. K. (2015). limma powers differential expression analyses for RNA-sequencing and microarray studies. Nucleic acids research, 43(7), e47-e47.</i></a>.     

POMAShiny allows users to compute limma models and the possibility to adjust these models by different covariates (if they have been included in the target file). The POMAShiny limma results are displayed in an interactive volcano plot at Limma's "Volcano Plot" tab.    

