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
  # title = "POMAShiny",
  
  header = dashboardHeader(
    title = span(img(src = "pomalogo.png", height = 35), "POMA"),
    titleWidth = 300,
    dropdownMenu(
      type = "notifications",
      headerText = strong("HELP"),
      icon = icon("question"),
      badgeStatus = NULL
    ),
    tags$li(
      a(
        strong("ABOUT POMA"),
        height = 40,
        href = "xxx",
        title = "",
        target = "_blank"
      ),
      class = "dropdown"
    )
  ),
  
  ## NAVBAR ----------------------------------------------------------------------
  
  # bs4DashNavbar(
  #   skin = "dark",
  #   status = "primary",
  #   border = TRUE,
  #   sidebarIcon = "chevron-left",
  #   controlbarIcon = "th",
  #   fixed = FALSE,
  #   HTML('<script async defer src="https://buttons.github.io/buttons.js"></script>
  #        <a class="github-button" href="https://github.com/pcastellanoescuder/POMAShiny"
  #        data-show-count="true" aria-label="Star pcastellanoescuder/POMAShiny on GitHub">Star</a>'),
  #   HTML('<script async defer src="https://buttons.github.io/buttons.js"></script>
  #        <a class="github-button" href="https://github.com/pcastellanoescuder/POMAShiny/issues"
  #        data-show-count="true" aria-label="Issue pcastellanoescuder/POMAShiny on GitHub">Issue</a>'),
  #   includeScript("google-analytics.js")
  #   ),
  
  ## SIDEBAR ----------------------------------------------------------------------
  
  sidebar = dashboardSidebar(
    # skin = "dark",
    # status = "warning",
    # title = HTML("<b>POMAShiny</b>"),
    # brandColor = "warning",
    # url = "https://github.com/pcastellanoescuder/POMAShiny",
    # src = "https://github.com/pcastellanoescuder/POMA/blob/master/man/figures/logo.png?raw=true",
    # elevation = 3,
    # opacity = 0.8,
      
    sidebarMenu(
      
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Upload Data", tabName = "inputdata", icon = icon("upload")),
      menuItem("Pre-processing", tabName = "preprocessing", icon = icon("wrench"), startExpanded = FALSE,
               menuSubItem("Impute Values", tabName = "impute_vals", icon = icon("angle-double-right")),
               menuSubItem("Normalization", tabName = "normalization", icon = icon("angle-double-right")),
               menuSubItem("Outlier Detection", tabName = "outliers", icon = icon("angle-double-right"))
               ),
      menuItem("EDA", tabName = "visualization", icon = icon("search"), startExpanded = FALSE,
               menuSubItem("Volcano Plot", tabName = "volcanoPlot", icon = icon("angle-double-right"))
      #                    bs4SidebarMenuSubItem("Boxplot", tabName = "boxPlot", icon = "angle-double-right"),
      #                    bs4SidebarMenuSubItem("Density Plot", tabName = "density", icon = "angle-double-right"),
      #                    bs4SidebarMenuSubItem("Heatmap", tabName = "HeatMap", icon = "angle-double-right")
      #                    ),
      # bs4SidebarMenuItem("Statistical Analysis", tabName = "statistics", icon = "chart-bar", startExpanded = FALSE,
      #                    bs4SidebarMenuSubItem("Univariate Analysis", tabName = "univariate", icon = "angle-double-right"),
      #                    bs4SidebarMenuSubItem("Multivariate Analysis", tabName = "multivariate", icon = "angle-double-right"),
      #                    bs4SidebarMenuSubItem("Cluster Analysis", tabName = "cluster", icon = "angle-double-right"),
      #                    bs4SidebarMenuSubItem("Correlation Analysis", tabName = "correlations", icon = "angle-double-right"),
      #                    bs4SidebarMenuSubItem("Regularized Regression", tabName = "featureselection", icon = "angle-double-right"),
      #                    bs4SidebarMenuSubItem("Random Forest", tabName = "randomforest", icon = "angle-double-right"),
      #                    bs4SidebarMenuSubItem("Rank Products", tabName = "rankprod", icon = "angle-double-right"),
      #                    bs4SidebarMenuSubItem("Odds Ratio", tabName = "odds", icon = "angle-double-right")
                         ),
      # bs4SidebarMenuItem("Help", tabName = "help", icon = "question"),
      # # bs4SidebarMenuItem("Tutorials", tabName = "tutorial", icon = "youtube"),
      # bs4SidebarMenuItem("POMA", tabName = "poma", icon = "box"),
      # bs4SidebarMenuItem("License", tabName = "license", icon = "clipboard"),
      # bs4SidebarMenuItem("Code of Conduct", tabName = "conduct", icon = "clipboard-check"),
      menuItem("Contact", tabName = "contact", icon = icon("user"))
      )
    ),
  
  ## CONTROLBAR ----------------------------------------------------------------------
  
  # controlbar = dashboardControlbar(
  #   skin = "light",
  #   # title = "Additional Information",
  # 
  #   controlbarMenu(
  #     # id = "controlbar_menu",
  #     status = "primary",
  #     side = "right",
  #     vertical = FALSE,
  # 
  #     controlbarItem(
  #       # tabName = "Active Dataset",
  #       active = TRUE,
  # 
  #       verbatimTextOutput("samples_num"),
  #       verbatimTextOutput("groups_num"),
  #       verbatimTextOutput("features_num"),
  #       verbatimTextOutput("covariates_num")
  #     )
  #     )
  #   ),
  
  ## BODY ----------------------------------------------------------------------
  
  body = dashboardBody(
    
    use_theme(poma_theme),
      
    tabItems(
      
      tabItem("home",
              source("ui-tab-landing.R", local=TRUE)$value),
      tabItem("inputdata",
              source("ui-tab-inputdata.R", local=TRUE)$value),
      tabItem("impute_vals",
              source("ui-tab-imputevalues.R", local=TRUE)$value),
      tabItem("normalization",
              source("ui-tab-normalization.R", local=TRUE)$value),
      tabItem("outliers",
              source("ui-tab-outliers.R", local=TRUE)$value),
      # tabItem("volcanoPlot",
      #         source("ui-tab-volcano.R", local=TRUE)$value),
      # tabItem("boxPlot",
      #         source("ui-tab-boxplot.R", local=TRUE)$value),
      # tabItem("density",
      #         source("ui-tab-density.R", local=TRUE)$value),
      # tabItem("HeatMap",
      #         source("ui-tab-heatmap.R", local=TRUE)$value),
      # tabItem("univariate",
      #         source("ui-tab-univariate.R", local=TRUE)$value),
      # tabItem("multivariate",
      #         source("ui-tab-multivariate.R", local=TRUE)$value),
      # tabItem("cluster",
      #         source("ui-tab-cluster.R", local=TRUE)$value),
      # tabItem("correlations",
      #         source("ui-tab-correlations.R", local=TRUE)$value),
      # tabItem("featureselection",
      #         source("ui-tab-featureselection.R", local=TRUE)$value),
      # tabItem("randomforest",
      #         source("ui-tab-random_forest.R", local=TRUE)$value),
      # tabItem("rankprod",
      #         source("ui-tab-rankprod.R", local=TRUE)$value),
      # tabItem("odds",
      #         source("ui-tab-odds.R", local=TRUE)$value),
      tabItem("help",
              source("ui-tab-help.R", local=TRUE)$value),
      tabItem("poma",
              source("ui-tab-poma.R", local=TRUE)$value),
      tabItem("license",
              source("ui-tab-license.R", local=TRUE)$value),
      tabItem("conduct",
              source("ui-tab-conduct.R", local=TRUE)$value),
      tabItem("contact",
              source("ui-tab-contact.R", local=TRUE)$value)
      ) # tabItems
    )#, # bs4DashBody
  
  ## FOOTER ----------------------------------------------------------------------
  
  # dashboardFooter(
  #   
  #   fluidRow(
  #     column(
  #       width = 12,
  #       align = "center",
  #       a(href = "https://pcastellanoescuder.github.io", HTML("<b>Pol Castellano Escuder</b>")), ", ",
  #       a(href = "http://www.nutrimetabolomics.com/members/raul-gonzalez-dominguez", "Raúl González Domínguez"), ", ",
  #       a(href = "https://sites.google.com/view/estbioinfo/home?authuser=0", "Francesc Carmona Pontaque"), ", ",
  #       a(href = "http://www.nutrimetabolomics.com/team/cristina", "Cristina Andrés Lacueva"), " and ",
  #       a(href = "https://webgrec.ub.edu/webpages/000011/cat/asanchez.ub.edu.html", "Alex Sánchez Pla"), 
  #       br(),
  #       "Statistics and Bioinformatics Research Group", "and",
  #       "Biomarkers and Nutritional & Food Metabolomics Research Group", "from",
  #       br(),
  #       "University of Barcelona",
  #       br(),
  #       "Copyright (C) 2021, code licensed under GPL-3.0",
  #       br(),
  #       "Code available on Github:", a(href = "https://github.com/pcastellanoescuder/POMAShiny", "https://github.com/pcastellanoescuder/POMAShiny")
  #       )
  #     ),
  #   right_text = NULL
  #   )
  ) # bs4DashPage

