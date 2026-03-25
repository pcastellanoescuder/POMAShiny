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

source("helpers.R")
source("themes.R")

bs4DashPage(
  title = "POMAShiny",
  freshTheme = poma_theme,
  dark = FALSE,
  scrollToTop = TRUE,

  ## NAVBAR ----------------------------------------------------------------------

  header = bs4DashNavbar(
    skin = "dark",
    status = "primary",
    border = TRUE,
    sidebarIcon = shiny::icon("bars"),
    controlbarIcon = shiny::icon("th"),
    fixed = FALSE,
    HTML('<script async defer src="https://buttons.github.io/buttons.js"></script>
         <a class="github-button" href="https://github.com/pcastellanoescuder/POMAShiny"
         data-show-count="true" aria-label="Star pcastellanoescuder/POMAShiny on GitHub">Star</a>'),
    HTML('<script async defer src="https://buttons.github.io/buttons.js"></script>
         <a class="github-button" href="https://github.com/pcastellanoescuder/POMAShiny/issues"
         data-show-count="true" aria-label="Issue pcastellanoescuder/POMAShiny on GitHub">Issue</a>')
  ),

  ## SIDEBAR ----------------------------------------------------------------------

  sidebar = bs4DashSidebar(
    skin = "dark",
    status = "warning",
    elevation = 3,
    collapsed = FALSE,
    minified = TRUE,
    expandOnHover = TRUE,
    fixed = FALSE,
    id = "sidebar",

    bs4SidebarMenu(
      id = "sidebarmenu",

      bs4SidebarMenuItem("Home", tabName = "home", icon = icon("home")),
      bs4SidebarMenuItem("Upload Data", tabName = "inputdata", icon = icon("upload")),
      bs4SidebarMenuItem("Pre-processing", icon = icon("wrench"), startExpanded = FALSE,
                         bs4SidebarMenuSubItem("Impute Values", tabName = "impute_vals", icon = icon("angle-double-right")),
                         bs4SidebarMenuSubItem("Normalization", tabName = "normalization", icon = icon("angle-double-right")),
                         bs4SidebarMenuSubItem("Outlier Detection", tabName = "outliers", icon = icon("angle-double-right"))
                         ),
      bs4SidebarMenuItem("EDA", icon = icon("search"), startExpanded = FALSE,
                         bs4SidebarMenuSubItem("Volcano Plot", tabName = "volcanoPlot", icon = icon("angle-double-right")),
                         bs4SidebarMenuSubItem("Boxplot", tabName = "boxPlot", icon = icon("angle-double-right")),
                         bs4SidebarMenuSubItem("Density Plot", tabName = "density", icon = icon("angle-double-right")),
                         bs4SidebarMenuSubItem("Heatmap", tabName = "HeatMap", icon = icon("angle-double-right"))
                         ),
      bs4SidebarMenuItem("Statistical Analysis", icon = icon("chart-bar"), startExpanded = FALSE,
                         bs4SidebarMenuSubItem("Univariate Analysis", tabName = "univariate", icon = icon("angle-double-right")),
                         bs4SidebarMenuSubItem("Multivariate Analysis", tabName = "multivariate", icon = icon("angle-double-right")),
                         bs4SidebarMenuSubItem("Cluster Analysis", tabName = "cluster", icon = icon("angle-double-right")),
                         bs4SidebarMenuSubItem("Correlation Analysis", tabName = "correlations", icon = icon("angle-double-right")),
                         bs4SidebarMenuSubItem("Regularized Regression", tabName = "featureselection", icon = icon("angle-double-right")),
                         bs4SidebarMenuSubItem("Random Forest", tabName = "randomforest", icon = icon("angle-double-right")),
                         bs4SidebarMenuSubItem("Rank Products", tabName = "rankprod", icon = icon("angle-double-right")),
                         bs4SidebarMenuSubItem("Odds Ratio", tabName = "odds", icon = icon("angle-double-right"))
                         ),
      bs4SidebarMenuItem("Help", tabName = "help", icon = icon("question")),
      bs4SidebarMenuItem("POMA", tabName = "poma", icon = icon("box")),
      bs4SidebarMenuItem("License", tabName = "license", icon = icon("clipboard")),
      bs4SidebarMenuItem("Code of Conduct", tabName = "conduct", icon = icon("clipboard-check")),
      bs4SidebarMenuItem("Contact", tabName = "contact", icon = icon("user"))
    )
  ),

  ## CONTROLBAR ----------------------------------------------------------------------

  controlbar = bs4DashControlbar(
    skin = "light",
    collapsed = TRUE,
    overlay = TRUE,
    pinned = FALSE,

    controlbarMenu(
      id = "controlbar_menu",
      type = "pills",

      controlbarItem(
        title = "Active Dataset",

        verbatimTextOutput("samples_num"),
        verbatimTextOutput("groups_num"),
        verbatimTextOutput("features_num"),
        verbatimTextOutput("covariates_num")
      )
    )
  ),

  ## BODY ----------------------------------------------------------------------

  body = bs4DashBody(

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

  footer = bs4DashFooter(
    left = fluidRow(
      column(
        width = 12,
        align = "center",
        a(href = "https://pcastellanoescuder.github.io", HTML("<b>Pol Castellano Escuder</b>")), ", ",
        a(href = "http://www.nutrimetabolomics.com/members/raul-gonzalez-dominguez", "Raul Gonzalez Dominguez"), ", ",
        a(href = "https://sites.google.com/view/estbioinfo/home?authuser=0", "Francesc Carmona Pontaque"), ", ",
        a(href = "http://www.nutrimetabolomics.com/team/cristina", "Cristina Andres Lacueva"), " and ",
        a(href = "https://webgrec.ub.edu/webpages/000011/cat/asanchez.ub.edu.html", "Alex Sanchez Pla"),
        br(),
        "Statistics and Bioinformatics Research Group", " and ",
        "Biomarkers and Nutritional & Food Metabolomics Research Group", " from ",
        "University of Barcelona",
        br(),
        "Copyright (C) 2021, code licensed under GPL-3.0",
        br(),
        "Code available on Github: ", a(href = "https://github.com/pcastellanoescuder/POMAShiny", "https://github.com/pcastellanoescuder/POMAShiny")
      )
    )
  )
) # bs4DashPage
