
Limma (Linear Models for Microarray Data) is an R/Bioconductor software package that provides an integrated solution for analysing high-throughput experimental data. It contains rich features for information borrowing to overcome the problem of **small sample sizes**.     

How it works?    

On one hand, it fits a linear model to each feature of data and takes advantage of the flexibility of such models in various ways, for example to handle complex experimental designs and to test very flexible hypotheses.     

On the other hand, it leverages the highly parallel nature of features to borrow strength between the feature-wise models, allowing for different levels of variability between features and between samples, and making statistical conclusions more reliable when the number of samples is small.   

In this method you can analyze your **Covariates file** if you have it.       

**You have to normalize the data to use this method.**     

<a href="https://academic.oup.com/nar/article/43/7/e47/2414268"><i>Ritchie, M. E., Phipson, B., Wu, D., Hu, Y., Law, C. W., Shi, W., & Smyth, G. K. (2015). limma powers differential expression analyses for RNA-sequencing and microarray studies. Nucleic acids research, 43(7), e47-e47.</i></a>      

