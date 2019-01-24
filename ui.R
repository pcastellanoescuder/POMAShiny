options(repos = BiocInstaller::biocinstallRepos())
getOption("repos")

# ui.R
source("helpers.R")
source("themes.R")
# collects all of the tab UIs

dashboardPage(skin = "blue", 
  #dashboardHeader(title = h2("POMA: Statistical analysis tool for targeted metabolomic data"),
  #                titleWidth = 800),
  dashboardHeader(title = logo_poma),
  # Version 2.0: "POMA: Statistical and enrichment analysis tool for targeted metabolomic data"
  
  dashboardSidebar(sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("home")),
    menuItem("Input Data", tabName = "inputdata", icon = icon("upload")),
    menuItem("Pre-processing", tabName = "preprocessing", icon = icon("wrench"), startExpanded = FALSE,
      menuSubItem("Impute Values", tabName = "impute_vals"),
      menuSubItem("Normalization", tabName = "normalization")),
    menuItem("Statistics", tabName = "statistics", icon = icon("sliders"), startExpanded = FALSE,
      menuSubItem("Univariate analysis", tabName = "univariate"), 
      menuSubItem("Multivariate analysis", tabName = "multivariate"),
      menuSubItem("Correlation analysis", tabName = "correlations"),
      menuSubItem("Feature Selection", tabName = "featureselection"),
      menuSubItem("Random Forest", tabName = "randomforest"),
      menuSubItem("Rank Products", tabName = "rankprod"),
      menuSubItem("Automatic Statistical Analysis", tabName = "isa", icon = icon("star"))),
    menuItem("Help", tabName = "help", icon = icon("question")),
    menuItem("Terms & Conditions", tabName = "terms", icon = icon("clipboard")),
    menuItem("About Us", tabName = "about", icon = icon("user")),
    menuItem("Give us feedback", tabName = "feedback", icon = icon("backward"))
  )),
  dashboardBody(
    #shinyDashboardThemes(
    #  theme = "blue_gradient"   
    #),  
    
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
      tabItem("univariate", 
              source("ui-tab-univariate.R", local=TRUE)$value),
      tabItem("multivariate", 
              source("ui-tab-multivariate.R",local=TRUE)$value),
      tabItem("correlations", 
              source("ui-tab-correlations.R",local=TRUE)$value),
      tabItem("featureselection", 
              source("ui-tab-featureselection.R",local=TRUE)$value),
      tabItem("randomforest", 
              source("ui-tab-random_forest.R",local=TRUE)$value),
      tabItem("rankprod", 
              source("ui-tab-rankprod.R",local=TRUE)$value),
      tabItem("isa", 
              source("ui-tab-isa.R",local=TRUE)$value),
      tabItem("help", 
              source("ui-tab-help.R",local=TRUE)$value),
      tabItem("terms", 
              source("ui-tab-terms.R",local=TRUE)$value),
      tabItem("about", 
              source("ui-tab-about.R",local=TRUE)$value),
      tabItem("feedback", 
              source("ui-tab-mail.R",local=TRUE)$value)
      
      ),
    
    ## ==================================================================================== ##   
    tags$hr(),
    ## ==================================================================================== ##
    ## FOOTER
    ## ==================================================================================== ##  
    tags$footer(p(h5(("Pol Castellano and Magalí Palau"), align="center",width=3),
              p(("Statistics and Bioinformatics Research Group"),"and", align="center",width=3),
              p(("Biomarkers and Nutritional & Food Metabolomics Research Group"),"from",
                align="center", width=3),
              p(("University of Barcelona"),align="center",width=3),
              p(("Copyright (C) 2018, code licensed under GPLv3"),align="center",width=4))),
             #p(("Code available on Github:"),a("link_html"),align="center",width=4),
    
    ## ==================================================================================== ##
    ## END
    ## ==================================================================================== ## 
    tags$head(includeScript("google-analytics.js"))
  ) 
) 

