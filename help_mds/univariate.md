
Univariate analysis is the simplest form of data analysis where the data being analyzed contains only one variable. Since it's a single variable it doesn't deal with causes or relationships.   

##### Parametric methods

##### Limma

Limma (Linear Models for Microarray Data) is an R/Bioconductor software package that provides an integrated solution for analysing high-throughput experimental data. It contains rich features for information borrowing to overcome the problem of **small sample sizes**.     

How it works?    

On one hand, it fits a linear model to each metabolite of data and takes advantage of the flexibility of such models in various ways, for example to handle complex experimental designs and to test very flexible hypotheses.     

On the other hand, it leverages the highly parallel nature of metabolomic data to borrow strength between the metabolite-wise models, allowing for different levels of variability between metabolites and between samples, and making statistical conclusions more reliable when the number of samples is small.   

In this method you can analyze your **Covariates file** if you have it.       

**You have to normalize the data to use this method.**     

<a href="https://academic.oup.com/nar/article/43/7/e47/2414268"><i>Ritchie, M. E., Phipson, B., Wu, D., Hu, Y., Law, C. W., Shi, W., & Smyth, G. K. (2015). limma powers differential expression analyses for RNA-sequencing and microarray studies. Nucleic acids research, 43(7), e47-e47.</i></a>      

##### T-test

This is an statistical hypothesis test in which the test statistic follows a Student's t-distribution under the null hypothesis. This analysis is used when you are comparing **two groups.**

A t-test is applied when the variable follow a **normal distribution**.

**Correlated (or Paired) T Test:** The correlated T test is performed when the samples typically consist of matched pairs of similar units, or when there are cases of repeated measures. This method can also applies on cases where the samples are related in some manner or have matching characteristics. Correlated or paired T tests are of dependent type, as these involve cases where the two sets of samples are related.    
**Equal Variance (or pooled) T Test:** The equal variance T test is used when the number of samples in each groups is the same, or the variance of the two data sets is similar.  

**Unequal Variance T Test:** The unequal variance T test is used when the number of samples in each group is different and the variance of the two data sets is also different. This test is also called the **Welch's t-test**.     

##### ANOVA

A variance analysis (ANOVA) tests the hypothesis that the averages of **two or more** populations are the same. The ANOVA evaluates the importance of one or more factors when comparing the means of the response variable in the different levels of the factors. The null hypothesis states that all the means of the population (mean of the levels of the factors) are the same, while the alternative hypothesis states that at least one is different.    

In this method you can analyze your **Covariates file** if you have it.     

##### Non Parametric methods

##### Mann-Whitney U Test

Mann-Whitney U test is the **non-parametric alternative test to the independent sample t-test**. It is a non-parametric test that is used to compare **two group** means that come from the same population, and used to test whether two sample means are equal or not.  Usually, the Mann-Whitney U test is used when the data is ordinal or when the **assumptions of the t-test are not met**.     

When your have **paired groups**, this test becomes a **Wilcoxon signed-rank test**.     

**Assumptions:**     

1. The sample drawn from the population is random.
2. Independence within the samples and mutual independence is assumed. That means that an observation is in one group or the other (it cannot be in both).
3. Ordinal measurement scale is assumed.    

##### Kruskal Wallis Test

Kruskal-Wallis test is a non-parametric method to test whether a group of data comes from the same population. Intuitively, it is similar to the ANOVA with the data replaced by categories. It is an extension of the Mann-Whitney U test for **3 or more groups**.     

Since it is a non-parametric test, the Kruskal-Wallis test does not assume normality in the data, as **opposed to the traditional ANOVA**. It assumes, under the null hypothesis, that the data come from the same distribution.    

