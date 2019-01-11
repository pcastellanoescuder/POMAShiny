installifnot <- function(pckgName){
  if (!(require(pckgName, character.only = TRUE))) {
    install.packages(pckgName, dep = TRUE)
    require(pckgName, character.only = TRUE)
  }
}

pk1 <- c("shiny", "shinydashboard", "DT", "reshape2", "ggplot2", "gplots", "scales", "plotly", "readxl", "glmnet", "ggvis", "shinyhelper",
         "broom", "readr", "markdown", "ggthemes", "dplyr", "ggrepel", "ggfortify", "shinyBS", "glue", "limma", "tidyr", "mixOmics", "devtools",
         "Rcpp", "randomForest", "tidyverse", "ggpubr", "gridExtra", "formattable", "viridis", "shinyAce", "sendmailR")

for (i in 1:length(pk1)){
  installifnot(pk1[i])
}

installBiocifnot <- function(pckgName){
  if (!(require(pckgName, character.only = TRUE))) {
    source("http://Bioconductor.org/biocLite.R")
    biocLite(pckgName)
    require(pckgName, character.only = TRUE)
  }
}

installBiocifnot("impute")
installBiocifnot("RankProd")

devtools::install_github("vqv/ggbiplot")
devtools::install_github("nik01010/dashboardthemes")
