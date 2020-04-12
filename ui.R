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

options(repos = BiocManager::repositories())
getOption("repos")

source("helpers.R")
source("themes.R")

dashboardPage(skin = "blue",

  dashboardHeader(title = logo_poma),

  dashboardSidebar(sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("home")),
    menuItem("Input Data", tabName = "inputdata", icon = icon("upload")),
    menuItem("Pre-processing", tabName = "preprocessing", icon = icon("wrench"), startExpanded = FALSE,
      menuSubItem("Impute Values", tabName = "impute_vals"),
      menuSubItem("Normalization", tabName = "normalization")),
    menuItem("Summary Plots", tabName = "visualization", icon = icon("search"), startExpanded = FALSE,
             menuSubItem("Volcano Plot", tabName = "volcanoPlot"),
             menuSubItem("Boxplot", tabName = "boxPlot"),
             menuSubItem("Heatmap", tabName = "HeatMap")),
    menuItem("Statistics", tabName = "statistics", icon = icon("sliders"), startExpanded = FALSE,
      menuSubItem("Univariate analysis", tabName = "univariate"),
      menuSubItem("Multivariate analysis", tabName = "multivariate"),
      menuSubItem("Limma", tabName = "limma"),
      menuSubItem("Correlation analysis", tabName = "correlations"),
      menuSubItem("Feature Selection", tabName = "featureselection"),
      menuSubItem("Random Forest", tabName = "randomforest"),
      menuSubItem("Rank Products", tabName = "rankprod"),
      menuSubItem("Odds Ratio", tabName = "odds")
      ),
    menuItem("Help", tabName = "help", icon = icon("question")),
    menuItem("Terms & Conditions", tabName = "terms", icon = icon("clipboard")),
    menuItem("About Us", tabName = "about", icon = icon("user")),
    menuItem("Give us feedback", tabName = "feedback", icon = icon("backward"))
  )),

  dashboardBody(

    poma_theme,

    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "mycss.css")
    ),
    tabItems(
      tabItem(tabName = "home",
              source("ui-tab-landing.R",local=TRUE)$value),
      tabItem(tabName = "inputdata",
              source("ui-tab-inputdata.R",local=TRUE)$value),
      tabItem("impute_vals",
              source("ui-tab-imputevalues.R",local=TRUE)$value),
      tabItem("normalization",
              source("ui-tab-normalization.R",local=TRUE)$value),
      tabItem("volcanoPlot",
              source("ui-tab-volcano.R", local=TRUE)$value),
      tabItem("boxPlot",
              source("ui-tab-boxplot.R", local=TRUE)$value),
      tabItem("HeatMap",
              source("ui-tab-heatmap.R", local=TRUE)$value),
      tabItem("univariate",
              source("ui-tab-univariate.R", local=TRUE)$value),
      tabItem("multivariate",
              source("ui-tab-multivariate.R",local=TRUE)$value),
      tabItem("limma",
              source("ui-tab-limma.R",local=TRUE)$value),
      tabItem("correlations",
              source("ui-tab-correlations.R",local=TRUE)$value),
      tabItem("featureselection",
              source("ui-tab-featureselection.R",local=TRUE)$value),
      tabItem("randomforest",
              source("ui-tab-random_forest.R",local=TRUE)$value),
      tabItem("rankprod",
              source("ui-tab-rankprod.R",local=TRUE)$value),
      tabItem("odds",
              source("ui-tab-odds.R",local=TRUE)$value),
      tabItem("help",
              source("ui-tab-help.R",local=TRUE)$value),
      tabItem("terms",
              source("ui-tab-terms.R",local=TRUE)$value),
      tabItem("about",
              source("ui-tab-about.R",local=TRUE)$value),
      tabItem("feedback",
              source("ui-tab-mail.R",local=TRUE)$value)

      ),

    tags$hr(),

    ## FOOTER

    tags$footer(p(h5(("Pol Castellano Escuder"), align="center",width=3),
              p(("Statistics and Bioinformatics Research Group"),"and", align="center",width=3),
              p(("Biomarkers and Nutritional & Food Metabolomics Research Group"),"from",
                align="center", width=3),
              p(("University of Barcelona"),align="center",width=3),
              p(("Copyright (C) 2018, code licensed under GPLv3"),align="center",width=4),
              p(("Code available on Github:"),a("https://github.com/pcastellanoescuder/POMA_Shiny",
                                                href="https://github.com/pcastellanoescuder/POMA_Shiny"),
                align="center",width=4),
              p(("POMA R package available on Github:"),a("https://github.com/pcastellanoescuder/POMA",
                                                href="https://github.com/pcastellanoescuder/POMA"),
                align="center",width=4))),

    ## GOOGLE ANALYTICS

    tags$head(includeScript("google-analytics.js"))
  )
)

