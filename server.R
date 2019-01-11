# server.R

options(shiny.maxRequestSize = 100*1024^2)

source("helpers.R")
print(sessionInfo())

shinyServer(function(input, output,session) {
  
  ## Server functions are divided by tab
  ## 
  source("server-inputdata.R",local = TRUE)
  source("server-normalization.R",local = TRUE)
  source("server-imputevalues.R",local=TRUE)
  source("server-univariate.R",local = TRUE)
  source("server-multivariate.R",local = TRUE)
  source("server-featureselection.R",local = TRUE)
  source("server-random_forest.R",local = TRUE)
  source("server-rankprod.R",local = TRUE)
  source("server-correlations.R",local = TRUE)
  source("server-mail.R",local = TRUE)
  
})