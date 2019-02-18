# This file is part of POMA.

# POMA is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# POMA is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with POMA. If not, see <https://www.gnu.org/licenses/>.

installifnot <- function(pckgName){
  if (!(require(pckgName, character.only = TRUE))) {
    install.packages(pckgName, dep = TRUE)
    require(pckgName, character.only = TRUE)
  }
}

pk1 <- c("shiny", "shinydashboard", "DT", "reshape2", "ggplot2", "gplots", "scales", "plotly", "readxl", "glmnet", "ggvis", "shinyhelper",
         "broom", "readr", "markdown", "ggthemes", "dplyr", "ggrepel", "ggfortify", "shinyBS", "glue", "limma", "tidyr", "mixOmics", "devtools",
         "Rcpp", "randomForest", "tidyverse", "ggpubr", "gridExtra", "formattable", "viridis", "knitr","kableExtra")

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

