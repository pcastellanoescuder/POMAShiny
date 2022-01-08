# This file is part of POMAShiny.

# POMAShiny is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# POMAShiny is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with POMAShiny. If not, see <https://www.gnu.org/licenses/>.

# options(repos = BiocManager::repositories())
# getOption("repos")

source("helpers.R")
source("themes.R")

dashboardPage(
  # old_school = FALSE,
  # sidebar_min = TRUE,
  # sidebar_collapsed = FALSE,
  # controlbar_collapsed = TRUE,
  # controlbar_overlay = TRUE,
  dashboardHeader(title = "POMAShiny"),
  
  ## NAVBAR ----------------------------------------------------------------------
  
  bs4Dash::bs4DashNavbar(
    skin = "dark",
    status = "primary",
    border = TRUE,
    sidebarIcon = "chevron-left",
    controlbarIcon = "th",
    fixed = FALSE,
    HTML('<script async defer src="https://buttons.github.io/buttons.js"></script>
         <a class="github-button" href="https://github.com/pcastellanoescuder/POMAShiny"
         data-show-count="true" aria-label="Star pcastellanoescuder/POMAShiny on GitHub">Star</a>'),
    HTML('<script async defer src="https://buttons.github.io/buttons.js"></script>
         <a class="github-button" href="https://github.com/pcastellanoescuder/POMAShiny/issues"
         data-show-count="true" aria-label="Issue pcastellanoescuder/POMAShiny on GitHub">Issue</a>'),
    includeScript("google-analytics.js")
    ),
  
  ## SIDEBAR ----------------------------------------------------------------------
  
  dashboardSidebar(
    skin = "dark",
    status = "warning",
    title = HTML("<b>POMAShiny</b>"),
    brandColor = "warning",
    url = "https://github.com/pcastellanoescuder/POMAShiny",
    src = "https://github.com/pcastellanoescuder/POMA/blob/master/man/figures/logo.png?raw=true",
    elevation = 3,
    opacity = 0.8,
      
    sidebarMenu(
      
      bs4Dash::menuItem("Home", tabName = "home", icon = bs4Dash::ionicon("home")),
      bs4Dash::menuItem("Upload Data", tabName = "inputdata", icon = bs4Dash::ionicon("upload")),
      bs4Dash::menuItem("Pre-processing", tabName = "preprocessing", icon = bs4Dash::ionicon("wrench"), startExpanded = FALSE,
                         bs4SidebarMenuSubItem("Impute Values", tabName = "impute_vals", icon = bs4Dash::ionicon("angle-double-right")),
                         bs4SidebarMenuSubItem("Normalization", tabName = "normalization", icon = bs4Dash::ionicon("angle-double-right")),
                         bs4SidebarMenuSubItem("Outlier Detection", tabName = "outliers", icon = bs4Dash::ionicon("angle-double-right"))
                         ),
      bs4Dash::menuItem("EDA", tabName = "visualization", icon = bs4Dash::ionicon("search"), startExpanded = FALSE,
                         bs4SidebarMenuSubItem("Volcano Plot", tabName = "volcanoPlot", icon = bs4Dash::ionicon("angle-double-right")),
                         bs4SidebarMenuSubItem("Boxplot", tabName = "boxPlot", icon = bs4Dash::ionicon("angle-double-right")),
                         bs4SidebarMenuSubItem("Density Plot", tabName = "density", icon = bs4Dash::ionicon("angle-double-right")),
                         bs4SidebarMenuSubItem("Heatmap", tabName = "HeatMap", icon = bs4Dash::ionicon("angle-double-right"))
                         ),
      bs4Dash::menuItem("Statistical Analysis", tabName = "statistics", icon = bs4Dash::ionicon("chart-bar"), startExpanded = FALSE,
                         bs4SidebarMenuSubItem("Univariate Analysis", tabName = "univariate", icon = bs4Dash::ionicon("angle-double-right")),
                         bs4SidebarMenuSubItem("Multivariate Analysis", tabName = "multivariate", icon = bs4Dash::ionicon("angle-double-right")),
                         bs4SidebarMenuSubItem("Cluster Analysis", tabName = "cluster", icon = bs4Dash::ionicon("angle-double-right")),
                         bs4SidebarMenuSubItem("Correlation Analysis", tabName = "correlations", icon = bs4Dash::ionicon("angle-double-right")),
                         bs4SidebarMenuSubItem("Regularized Regression", tabName = "featureselection", icon = bs4Dash::ionicon("angle-double-right")),
                         bs4SidebarMenuSubItem("Random Forest", tabName = "randomforest", icon = bs4Dash::ionicon("angle-double-right")),
                         bs4SidebarMenuSubItem("Rank Products", tabName = "rankprod", icon = bs4Dash::ionicon("angle-double-right")),
                         bs4SidebarMenuSubItem("Odds Ratio", tabName = "odds", icon = bs4Dash::ionicon("angle-double-right"))
                         ),
      bs4Dash::menuItem("Help", tabName = "help", icon = bs4Dash::ionicon("question")),
      # bs4Dash::menuItem("Tutorials", tabName = "tutorial", icon = "youtube"),
      bs4Dash::menuItem("POMA", tabName = "poma", icon = bs4Dash::ionicon("box")),
      bs4Dash::menuItem("License", tabName = "license", icon = bs4Dash::ionicon("clipboard")),
      bs4Dash::menuItem("Code of Conduct", tabName = "conduct", icon = bs4Dash::ionicon("clipboard-check")),
      bs4Dash::menuItem("Contact", tabName = "contact", icon = bs4Dash::ionicon("user"))
      )
    ),
  
  ## CONTROLBAR ----------------------------------------------------------------------
  
  bs4Dash::bs4DashControlbar(
    skin = "light",
    title = "Additional Information",
    
    bs4Dash::controlbarMenu(
      id = "controlbar_menu",
      # status = "primary",
      side = "right", 
      vertical = FALSE,
      
      bs4Dash::controlbarItem(
        tabName = "Active Dataset",
        active = TRUE,
        
        verbatimTextOutput("samples_num"),
        verbatimTextOutput("groups_num"),
        verbatimTextOutput("features_num"),
        verbatimTextOutput("covariates_num")
      )
      )
    ),
  
  ## BODY ----------------------------------------------------------------------
  
  bs4Dash::dashboardBody(
    
    use_theme(poma_theme),
      
    bs4Dash::tabItems(
      
      bs4Dash::tabItem("home",
                 source("ui-tab-landing.R", local=TRUE)$value),
      bs4Dash::tabItem("inputdata",
                 source("ui-tab-inputdata.R", local=TRUE)$value),
      bs4Dash::tabItem("impute_vals",
                 source("ui-tab-imputevalues.R", local=TRUE)$value),
      bs4Dash::tabItem("normalization",
                 source("ui-tab-normalization.R", local=TRUE)$value),
      bs4Dash::tabItem("outliers",
                 source("ui-tab-outliers.R", local=TRUE)$value),
      bs4Dash::tabItem("volcanoPlot",
                 source("ui-tab-volcano.R", local=TRUE)$value),
      bs4Dash::tabItem("boxPlot",
                 source("ui-tab-boxplot.R", local=TRUE)$value),
      bs4Dash::tabItem("density",
                 source("ui-tab-density.R", local=TRUE)$value),
      bs4Dash::tabItem("HeatMap",
                 source("ui-tab-heatmap.R", local=TRUE)$value),
      bs4Dash::tabItem("univariate",
                 source("ui-tab-univariate.R", local=TRUE)$value),
      bs4Dash::tabItem("multivariate",
                 source("ui-tab-multivariate.R", local=TRUE)$value),
      bs4Dash::tabItem("cluster",
                 source("ui-tab-cluster.R", local=TRUE)$value),
      bs4Dash::tabItem("correlations",
                 source("ui-tab-correlations.R", local=TRUE)$value),
      bs4Dash::tabItem("featureselection",
                 source("ui-tab-featureselection.R", local=TRUE)$value),
      bs4Dash::tabItem("randomforest",
                 source("ui-tab-random_forest.R", local=TRUE)$value),
      bs4Dash::tabItem("rankprod",
                 source("ui-tab-rankprod.R", local=TRUE)$value),
      bs4Dash::tabItem("odds",
                 source("ui-tab-odds.R", local=TRUE)$value),
      bs4Dash::tabItem("help",
                 source("ui-tab-help.R", local=TRUE)$value),
      # bs4Dash::tabItem("tutorial",
      #            source("ui-tab-tutorial.R", local=TRUE)$value),
      bs4Dash::tabItem("poma",
                 source("ui-tab-poma.R", local=TRUE)$value),
      bs4Dash::tabItem("license",
                 source("ui-tab-license.R", local=TRUE)$value),
      bs4Dash::tabItem("conduct",
                 source("ui-tab-conduct.R", local=TRUE)$value),
      bs4Dash::tabItem("contact",
                 source("ui-tab-contact.R", local=TRUE)$value)
      ) # bs4TabItems
    ), # bs4DashBody
  
  ## FOOTER ----------------------------------------------------------------------
  
  bs4Dash::dashboardFooter(
    
    fluidRow(
      column(
        width = 12,
        align = "center",
        a(href = "https://pcastellanoescuder.github.io", HTML("<b>Pol Castellano Escuder</b>")), ", ",
        a(href = "http://www.nutrimetabolomics.com/members/raul-gonzalez-dominguez", "Raúl González Domínguez"), ", ",
        a(href = "https://sites.google.com/view/estbioinfo/home?authuser=0", "Francesc Carmona Pontaque"), ", ",
        a(href = "http://www.nutrimetabolomics.com/team/cristina", "Cristina Andrés Lacueva"), " and ",
        a(href = "https://webgrec.ub.edu/webpages/000011/cat/asanchez.ub.edu.html", "Alex Sánchez Pla"), 
        br(),
        "Statistics and Bioinformatics Research Group", "and",
        "Biomarkers and Nutritional & Food Metabolomics Research Group", "from",
        br(),
        "University of Barcelona",
        br(),
        "Copyright (C) 2021, code licensed under GPL-3.0",
        br(),
        "Code available on Github:", a(href = "https://github.com/pcastellanoescuder/POMAShiny", "https://github.com/pcastellanoescuder/POMAShiny")
        )
      ),
    right_text = NULL
    )
  ) # bs4DashPage

