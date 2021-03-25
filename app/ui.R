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

bs4DashPage(
  old_school = FALSE,
  sidebar_min = TRUE,
  sidebar_collapsed = FALSE,
  controlbar_collapsed = TRUE,
  controlbar_overlay = TRUE,
  title = "POMAShiny",
  
  ## NAVBAR ----------------------------------------------------------------------
  
  bs4DashNavbar(
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
  
  bs4DashSidebar(
    skin = "dark",
    status = "warning",
    title = HTML("<b>POMAShiny</b>"),
    brandColor = "warning",
    url = "https://github.com/pcastellanoescuder/POMAShiny",
    src = "https://github.com/pcastellanoescuder/POMA/blob/master/man/figures/logo.png?raw=true",
    elevation = 3,
    opacity = 0.8,
      
    bs4SidebarMenu(
      
      bs4SidebarMenuItem("Home", tabName = "home", icon = "home"),
      bs4SidebarMenuItem("Upload Data", tabName = "inputdata", icon = "upload"),
      bs4SidebarMenuItem("Pre-processing", tabName = "preprocessing", icon = "wrench", startExpanded = FALSE,
                         bs4SidebarMenuSubItem("Impute Values", tabName = "impute_vals", icon = "angle-double-right"),
                         bs4SidebarMenuSubItem("Normalization", tabName = "normalization", icon = "angle-double-right"),
                         bs4SidebarMenuSubItem("Outlier Detection", tabName = "outliers", icon = "angle-double-right")
                         ),
      bs4SidebarMenuItem("EDA", tabName = "visualization", icon = "search", startExpanded = FALSE,
                         bs4SidebarMenuSubItem("Volcano Plot", tabName = "volcanoPlot", icon = "angle-double-right"),
                         bs4SidebarMenuSubItem("Boxplot", tabName = "boxPlot", icon = "angle-double-right"),
                         bs4SidebarMenuSubItem("Density Plot", tabName = "density", icon = "angle-double-right"),
                         bs4SidebarMenuSubItem("Heatmap", tabName = "HeatMap", icon = "angle-double-right")
                         ),
      bs4SidebarMenuItem("Statistical Analysis", tabName = "statistics", icon = "chart-bar", startExpanded = FALSE,
                         bs4SidebarMenuSubItem("Univariate Analysis", tabName = "univariate", icon = "angle-double-right"),
                         bs4SidebarMenuSubItem("Multivariate Analysis", tabName = "multivariate", icon = "angle-double-right"),
                         bs4SidebarMenuSubItem("Cluster Analysis", tabName = "cluster", icon = "angle-double-right"),
                         # bs4SidebarMenuSubItem("Limma", tabName = "limma", icon = "angle-double-right"),
                         bs4SidebarMenuSubItem("Correlation Analysis", tabName = "correlations", icon = "angle-double-right"),
                         bs4SidebarMenuSubItem("Regularized Regression", tabName = "featureselection", icon = "angle-double-right"),
                         bs4SidebarMenuSubItem("Random Forest", tabName = "randomforest", icon = "angle-double-right"),
                         bs4SidebarMenuSubItem("Rank Products", tabName = "rankprod", icon = "angle-double-right"),
                         bs4SidebarMenuSubItem("Odds Ratio", tabName = "odds", icon = "angle-double-right")
                         ),
      bs4SidebarMenuItem("Help", tabName = "help", icon = "question"),
      # bs4SidebarMenuItem("Tutorials", tabName = "tutorial", icon = "youtube"),
      bs4SidebarMenuItem("POMA", tabName = "poma", icon = "box"),
      bs4SidebarMenuItem("License", tabName = "license", icon = "clipboard"),
      bs4SidebarMenuItem("Code of Conduct", tabName = "conduct", icon = "clipboard-check"),
      bs4SidebarMenuItem("Contact", tabName = "contact", icon = "user")
      )
    ),
  
  ## CONTROLBAR ----------------------------------------------------------------------
  
  bs4DashControlbar(
    skin = "light",
    title = "Additional Information",
    
    bs4DashControlbarMenu(
      id = "controlbar_menu",
      status = "primary",
      side = "right", 
      vertical = FALSE,
      
      bs4DashControlbarItem(
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
  
  bs4DashBody(
    
    use_theme(poma_theme),
      
    bs4TabItems(
      
      bs4TabItem("home",
                 source("ui-tab-landing.R", local=TRUE)$value),
      bs4TabItem("inputdata",
                 source("ui-tab-inputdata.R", local=TRUE)$value),
      bs4TabItem("impute_vals",
                 source("ui-tab-imputevalues.R", local=TRUE)$value),
      bs4TabItem("normalization",
                 source("ui-tab-normalization.R", local=TRUE)$value),
      bs4TabItem("outliers",
                 source("ui-tab-outliers.R", local=TRUE)$value),
      bs4TabItem("volcanoPlot",
                 source("ui-tab-volcano.R", local=TRUE)$value),
      bs4TabItem("boxPlot",
                 source("ui-tab-boxplot.R", local=TRUE)$value),
      bs4TabItem("density",
                 source("ui-tab-density.R", local=TRUE)$value),
      bs4TabItem("HeatMap",
                 source("ui-tab-heatmap.R", local=TRUE)$value),
      bs4TabItem("univariate",
                 source("ui-tab-univariate.R", local=TRUE)$value),
      bs4TabItem("multivariate",
                 source("ui-tab-multivariate.R", local=TRUE)$value),
      bs4TabItem("cluster",
                 source("ui-tab-cluster.R", local=TRUE)$value),
      # bs4TabItem("limma",
      #            source("ui-tab-limma.R", local=TRUE)$value),
      bs4TabItem("correlations",
                 source("ui-tab-correlations.R", local=TRUE)$value),
      bs4TabItem("featureselection",
                 source("ui-tab-featureselection.R", local=TRUE)$value),
      bs4TabItem("randomforest",
                 source("ui-tab-random_forest.R", local=TRUE)$value),
      bs4TabItem("rankprod",
                 source("ui-tab-rankprod.R", local=TRUE)$value),
      bs4TabItem("odds",
                 source("ui-tab-odds.R", local=TRUE)$value),
      bs4TabItem("help",
                 source("ui-tab-help.R", local=TRUE)$value),
      # bs4TabItem("tutorial",
      #            source("ui-tab-tutorial.R", local=TRUE)$value),
      bs4TabItem("poma",
                 source("ui-tab-poma.R", local=TRUE)$value),
      bs4TabItem("license",
                 source("ui-tab-license.R", local=TRUE)$value),
      bs4TabItem("conduct",
                 source("ui-tab-conduct.R", local=TRUE)$value),
      bs4TabItem("contact",
                 source("ui-tab-contact.R", local=TRUE)$value)
      ) # bs4TabItems
    ), # bs4DashBody
  
  ## FOOTER ----------------------------------------------------------------------
  
  bs4DashFooter(
    
    fluidRow(
      column(
        width = 12,
        align = "center",
        a(href = "https://pcastellanoescuder.github.io", HTML("<b>Pol Castellano Escuder</b>")), ", ",
        a(href = "http://www.nutrimetabolomics.com/members/raul-gonzalez-dominguez", "Raúl González Domínguez"), ", ",
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
    right_text = NULL # "2020, GPL-3.0 License"
    )
  ) # bs4DashPage

