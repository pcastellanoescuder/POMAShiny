# ui.R
source("helpers.R")
# collects all of the tab UIs
#shinyUI(
#
dashboardPage(skin = "blue",
  dashboardHeader(title = h2("POMA: Statistical and enrichment analysis tool for targeted metabolomic data"),
                  titleWidth = 800),
  
  dashboardSidebar(sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("home")),
    menuItem("Input Data", tabName = "inputdata", icon = icon("upload")),
    menuItem("Pre-processing", tabName = "preprocessing", icon = icon("wrench"), startExpanded = FALSE,
      menuSubItem("Impute Values", tabName = "impute_vals"),
      menuSubItem("Normalization", tabName = "normalization")),
    menuItem("Multivariate analysis", tabName = "multivariate", icon = icon("signal"))
    
  )),
  dashboardBody(
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
      tabItem("multivariate", 
              source("ui-tab-multivariate.R",local=TRUE)$value) 
      ),
    
    ## ==================================================================================== ##   
    tags$hr(),
    ## ==================================================================================== ##
    ## FOOTER
    ## ==================================================================================== ##  
    tags$footer(p(h5(("Pol Castellano and Magalí Palau"),align="center",width=3),
              p(("Statistics and Bioinformatics Research Group"),"and",align="center",width=3),
              p(("Biomarkers and Nutritional & Food Metabolomics Research Group"),"from",
                align="center",width=3),
              p(("University of Barcelona"),align="center",width=3),
              p(("Copyright (C) 2018, code licensed under GPLv3"),align="center",width=4)))
             #p(("Code available on Github:"),a("link_html"),align="center",width=4),
    
    ## ==================================================================================== ##
    ## END
    ## ==================================================================================== ## 
    #tags$head(includeScript("google-analytics.js"))
  ) 
) 

