fluidRow(
  column(width = 3,
                wellPanel(
                  
                  h4("Parameters:"),
                  
                  sliderInput('rf_ntrees',"Number of trees:",
                               min=10,max=500,value=500,
                               step = 1),
                  sliderInput('rf_mtry', "Number of variables randomly sampled as candidates at each split:",
                               min=1,max=20,value=5,
                               step = 1),
                  sliderInput('rf_nodesize',"Node Size:",
                               min=1,max=30,value=5,
                               step = 1),
                  sliderInput('rf_numvar',"Number of Selected Variates:",
                               min=1,max=40,value=15,
                               step = 1),
  
  actionButton("plot_rf","Analyze", icon("step-forward"),
               style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                title = "Random forest helper",
                                                                                                content = "random_forest",
                                                                                                icon = "question",
                                                                                                colour = "green")
  )),
  
  column(width = 8,
         
         fluidPage(tabsetPanel(
           tabPanel("Confusion Matrix", dataTableOutput("confusion")),
           tabPanel("OOB Error Rate Plot", plotlyOutput("oob_error")),
           tabPanel("OOB Error Rate Table", div(style = 'overflow-x: scroll', 
                                                  dataTableOutput("oob_error_table"), 
                                                  width = NULL,
                                                  status = "primary")),
           tabPanel("MeanDecreaseGini Plot", plotlyOutput("Gini")),
           tabPanel("MeanDecreaseGini Table", div(style = 'overflow-x: scroll', 
                                       dataTableOutput("gini_table"), 
                                       width = NULL,
                                       status = "primary"))
           
           
         ))

                          
  ))
         


