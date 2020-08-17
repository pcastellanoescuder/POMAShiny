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

shiny::shinyApp(
  
  ui = bs4DashPage(
    old_school = FALSE,
    sidebar_min = TRUE,
    sidebar_collapsed = FALSE,
    controlbar_collapsed = TRUE,
    controlbar_overlay = TRUE,
    title = "POMAShiny",
    
    ## NAVBAR ----------------------------------------------------------------------
    
    navbar = bs4DashNavbar(
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
           data-show-count="true" aria-label="Issue pcastellanoescuder/POMAShiny on GitHub">Issue</a>')
      ),
    
    ## SIDEBAR ----------------------------------------------------------------------
    
    sidebar = bs4DashSidebar(
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
                           bs4SidebarMenuSubItem("Limma", tabName = "limma", icon = "angle-double-right"),
                           bs4SidebarMenuSubItem("Correlation Analysis", tabName = "correlations", icon = "angle-double-right"),
                           bs4SidebarMenuSubItem("Feature Selection", tabName = "featureselection", icon = "angle-double-right"),
                           bs4SidebarMenuSubItem("Random Forest", tabName = "randomforest", icon = "angle-double-right"),
                           bs4SidebarMenuSubItem("Rank Products", tabName = "rankprod", icon = "angle-double-right"),
                           bs4SidebarMenuSubItem("Odds Ratio", tabName = "odds", icon = "angle-double-right")
                           ),
        bs4SidebarMenuItem("Help", tabName = "help", icon = "question"),
        bs4SidebarMenuItem("Terms & Conditions", tabName = "terms", icon = "clipboard"),
        bs4SidebarMenuItem("About", tabName = "about", icon = "user"),
        bs4SidebarMenuItem("Give us Feedback", tabName = "feedback", icon = "backward")
        )
      ),
    
    ## CONTROLBAR ----------------------------------------------------------------------
    
    controlbar = bs4DashControlbar(
      skin = "light",
      title = "Additional Information",
      
      bs4DashControlbarMenu(
        id = "controlbar_menu",
        status = "primary",
        side = "right", 
        vertical = FALSE,
        
        bs4DashControlbarItem(
          active = TRUE,
          tabName = "Active Dataset",
          verbatimTextOutput("samples_num"),
          verbatimTextOutput("groups_num"),
          verbatimTextOutput("features_num"),
          verbatimTextOutput("covariates_num")
        ),
        bs4DashControlbarItem(
          tabName = "POMA Status",
          includeMarkdown("instructions/badges.md")
        ),
        bs4DashControlbarItem(
          tabName = "Session Info",
          verbatimTextOutput("session_info")
        )
      )
      ),

    ## BODY ----------------------------------------------------------------------
    
    body = bs4DashBody(
      
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
        bs4TabItem("limma",
                   source("ui-tab-limma.R", local=TRUE)$value),
        bs4TabItem("correlations",
                   source("ui-tab-correlations.R", local=TRUE)$value),
        # bs4TabItem("featureselection",
        #            source("ui-tab-featureselection.R", local=TRUE)$value),
        # bs4TabItem("randomforest",
        #            source("ui-tab-random_forest.R", local=TRUE)$value),
        # bs4TabItem("rankprod",
        #            source("ui-tab-rankprod.R", local=TRUE)$value),
        # bs4TabItem("odds",
        #            source("ui-tab-odds.R", local=TRUE)$value),
        bs4TabItem("help",
                   source("ui-tab-help.R", local=TRUE)$value),
        bs4TabItem("terms",
                   source("ui-tab-terms.R", local=TRUE)$value),
        bs4TabItem("about",
                   source("ui-tab-about.R", local=TRUE)$value),
        bs4TabItem("feedback",
                   source("ui-tab-mail.R", local=TRUE)$value)
        
        ) # bs4TabItems
      ), # bs4DashBody
    
    ## FOOTER ----------------------------------------------------------------------
    
    footer = bs4DashFooter(
      
      copyrights = a(
        href = "https://pcastellanoescuder.github.io",
        target = "_blank", "Pol Castellano Escuder, "
        ),
      a(
        href = "http://www.nutrimetabolomics.com",
        target = "_blank", "Raúl González Domínguez, "
      ),
      a(
        href = "http://www.nutrimetabolomics.com",
        target = "_blank", "Cristina Andrés Lacueva and "
      ),
      a(
        href = "https://sites.google.com/view/estbioinfo/home",
        target = "_blank", "Alex Sánchez Pla"
      ),
      right_text = "2020, GPL-3.0 License"
      )
    
    ), # bs4DashPage
  
  server = function(input, output, session) {
    
    source("server-rightsidebar.R",local = TRUE)
    source("server-inputdata.R",local = TRUE)
    source("server-imputevalues.R",local=TRUE)
    source("server-normalization.R",local = TRUE)
    source("server-outliers.R",local = TRUE)
    source("server-volcano.R",local = TRUE)
    source("server-boxplot.R",local = TRUE)
    source("server-density.R",local = TRUE)
    source("server-heatmap.R",local = TRUE)
    source("server-univariate.R",local = TRUE)
    source("server-multivariate.R",local = TRUE)
    source("server-cluster.R",local = TRUE)
    source("server-limma.R",local = TRUE)
    source("server-correlations.R",local = TRUE)
    # source("server-featureselection.R",local = TRUE)
    # source("server-random_forest.R",local = TRUE)
    # source("server-rankprod.R",local = TRUE)
    # source("server-odds.R",local = TRUE)
    }
  ) # shinyApp

