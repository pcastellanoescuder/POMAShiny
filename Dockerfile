# Get shiny serves plus tidyverse packages image

FROM rocker/shiny-verse:latest

# System libraries of general use

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libboost-all-dev \
    libmpfr-dev \
    libnetcdf-dev \
    xtail \
    wget

# Install R packages required 

## CRAN

RUN R -e "install.packages(c('shiny', 'DT', 'bs4Dash', 'reshape2', 'plotly', 'fresh', 'shinyhelper', 'ggraph', 'rmarkdown', 'shinyWidgets', 'tidyverse', 'knitr', 'patchwork', 'BiocManager'), repos = 'http://cran.rstudio.com/')"

## Bioconductor

RUN R -e "BiocManager::install(c('Biobase', 'POMA', 'MSnbase'))"

# Copy the app to the image

COPY /app /pomashiny

# Select port

EXPOSE 3838

# Allow permission

RUN sudo chown -R shiny:shiny /pomashiny

# Run app

CMD ["R", "-e", "shiny::runApp('/pomashiny', host = '0.0.0.0', port = 3838)"]

