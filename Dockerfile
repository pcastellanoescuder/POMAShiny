# Get shiny serves plus tidyverse packages image

FROM rocker/shiny-verse:latest

# System libraries of general use

RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev 

# Install R packages required 

## CRAN

RUN R -e "install.packages(c('shiny', 'DT', 'bs4Dash', 'reshape2', 'plotly', 'fresh', 'shinyhelper', 'ggraph', 'rmarkdown', 'shinyWidgets', 'tidyverse', 'knitr', 'patchwork', 'BiocManager', 'devtools'), repos = 'http://cran.rstudio.com/')"

## Bioconductor

RUN R -e "BiocManager::install('Biobase')"

## GitHub

RUN R -e "devtools::install_github('pcastellanoescuder/POMA')"

# Copy the app to the image

COPY POMAShiny.Rproj /srv/shiny-server/
COPY /app /srv/shiny-server/

# Select port

EXPOSE 3838

# Allow permission
RUN sudo chown -R shiny:shiny /srv/shiny-server

# Run app
CMD ["/usr/bin/shiny-server.sh"]

