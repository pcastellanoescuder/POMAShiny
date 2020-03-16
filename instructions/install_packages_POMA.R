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


#### Cran

installifnot <- function(pckgName){
  if (!(require(pckgName, character.only = TRUE))) {
    install.packages(pckgName, dep = TRUE)
    require(pckgName, character.only = TRUE)
  }
}

pk1 <- c('shiny', 'DT', 'shinydashboard', 'reshape2', 'scales', 'plotly', 'glmnet', 'shinyhelper', 'shinyBS', 'markdown', 
         'broom', 'randomForest', 'tidyverse', 'viridis', 'knitr', 'heatmaply', 'patchwork', 'prettydoc', 'BiocManager', 'devtools')

for (i in 1:length(pk1)){
  installifnot(pk1[i])
}

#### Bioconductor

installBiocifnot <- function(pckgName){
  if (!(require(pckgName, character.only = TRUE))) {
    BiocManager::install(pckgName)
    require(pckgName, character.only = TRUE)
  }
}

pk2 <- c('impute', 'RankProd', 'mixOmics', 'limma')

for (i in 1:length(pk2)){
  installBiocifnot(pk2[i])
}

#### Github

devtools::install_github("nik01010/dashboardthemes")

