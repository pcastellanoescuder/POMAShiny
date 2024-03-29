# POMAShiny <img src='app/mds/pix/logo.png' align='right' height='139'/>

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![Last
Commit](https://img.shields.io/github/last-commit/pcastellanoescuder/POMAShiny.svg)](https://github.com/pcastellanoescuder/POMAShiny/commits/master)
[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

<!-- badges: end -->

## Overview

POMAShiny is a web-based tool that provides a structured, flexible and
user-friendly workflow for pre-processing, exploratory data analysis
(EDA) and statistical analysis of metabolomics and proteomics data. This
tool is based on the
[**POMA**](http://pcastellanoescuder.github.io/POMA/) R/Bioconductor
package, which increases the reproducibility and flexibility of the
analysis outside the web environment. POMAShiny’s workflow is structured
in four sequential and well-defined panels: 1) data upload, 2)
pre-processing, 3) EDA and 4) statistical analysis panels. POMAShiny is
hosted at <https://webapps.nutrimetabolomics.com/POMAShiny>.

<img src="inst/png/POMAShiny_demo.png" width="500%"/>

## Run POMAShiny locally

### Step 1: Clone this repository

Open the terminal and run:

``` bash
git clone "https://github.com/pcastellanoescuder/POMAShiny.git"
```

### Step 2: Install package dependencies

Open the `POMAShiny.Rproj` with [RStudio](https://rstudio.com) and run:

``` r
# CRAN packages
installifnot <- function(pckgName){
  if (!(require(pckgName, character.only = TRUE))) {
    install.packages(pckgName, dep = TRUE)
    require(pckgName, character.only = TRUE)
  }
}

pk1 <- c('shiny', 'DT', 'devtools', 'reshape2', 'plotly', 'fresh', 'shinyhelper', 'ggraph', 
         'rmarkdown', 'shinyWidgets', 'tidyverse', 'knitr', 'patchwork', 'BiocManager')

for (i in 1:length(pk1)){
  installifnot(pk1[i])
}

# Install the old version of 'bs4Dash'
devtools::install_version("bs4Dash", version = "0.5.0", repos = "http://cran.us.r-project.org")

# Bioconductor packages
installBiocifnot <- function(pckgName){
  if (!(require(pckgName, character.only = TRUE))) {
    BiocManager::install(pckgName)
    require(pckgName, character.only = TRUE)
  }
}

pk2 <- c('Biobase', 'POMA', 'MSnbase')

for (i in 1:length(pk2)){
  installBiocifnot(pk2[i])
}
```

NOTE: *POMAShiny was built with `bs4Dash` version 0.5.0 and is not
compatible with newer versions of `bs4Dash` due to substantial breaking
changes in the API. We keep the old version as indicated by the
`bs4Dash` developers.*

### Step 3: Deploy POMAShiny locally :tada:

Once all dependencies have been installed run the following command and
enjoy the analysis!

``` r
shiny::runApp(appDir = "app")
```

## Run POMAShiny Docker container image

### Step 1: Pull Docker image

Pull the POMAShiny Docker container image hosted at [Docker
Hub](https://hub.docker.com/repository/docker/pcastellanoescuder/pomashiny)
by running the following command in the terminal.

``` bash
docker pull pcastellanoescuder/pomashiny:v.1.1.14
```

### Step 2: Run Docker image

Run the container on your terminal once it has been pulled.

``` bash
docker run -d --rm -p 3838:3838 pomashiny
```

### Step 3: Run POMAShiny in your browser

Open your browser and paste `http://0.0.0.0:3838`. Then, enjoy the
analysis!

## Code of Conduct

Please note that the POMAShiny project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
