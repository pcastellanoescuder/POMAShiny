fluidRow(
  column(width = 3,
         wellPanel(
           
           h4("Parameters:"),
           
           radioButtons("param_rank_log", "Logged:",
                        choices = c("Yes" = TRUE,
                                    "No" = FALSE
                                    ), selected = FALSE),
           
           conditionalPanel(condition = ("input.param_rank_log == 'TRUE'"),
                            sliderInput("param_rank_log_val","Log-base value:",min=1,max=10,value=2,step = 1)),
           
           radioButtons("method", "Method:",
                        choices = c("Percentage of False Prediction" = 'pfp',
                                    "P-value" = 'pval'),
                        selected = 'pfp'),
           
           sliderInput("cutoff","Cutoff value:",
                       min=0.001, max=0.2,value=0.05,
                       step = 0.01),

           
           actionButton("rank_prod","Analyze", icon("step-forward"),
                        style="color: #fff; background-color: #00b300; border-color: #009900")
         )),
  
  column(width = 8,
         
                          fluidPage(tabsetPanel(
                            tabPanel("Up-regulated metabolites", div(style = 'overflow-x: scroll', 
                                                        dataTableOutput("upregulated"), 
                                                        width = NULL,
                                                        status = "primary")),
                            tabPanel("Down-regulated metabolites", div(style = 'overflow-x: scroll', 
                                                        dataTableOutput("downregulated"), 
                                                        width = NULL,
                                                        status = "primary")),
                            tabPanel("Estimated PFP Plot", plotlyOutput("rank_prod_plot")))
                            ))
         
         
         
  )
