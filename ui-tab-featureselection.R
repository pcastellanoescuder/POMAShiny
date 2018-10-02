fluidRow(
  column(width = 3,
                wellPanel(
  radioButtons("feat_selection", h4("Feature Selection Methods:"),
               choices = c("Lasso" = 'lasso',
                           "Ridge Regression" = 'ridge')), 
                           
  
  actionButton("feat_selection_action","Submit", icon("step-forward"),
               style="color: #fff; background-color: #00b300; border-color: #009900")
  )),
  
  column(width = 8,
         
         conditionalPanel(condition = ("input.feat_selection == 'lasso'"),
                          fluidPage(tabsetPanel(
                            tabPanel("Lasso Plot", plotlyOutput("lasso_plot")),
                            tabPanel("Cross-Validation", plotlyOutput("cvglmnet")),
                            tabPanel("Selected Features", DT::dataTableOutput("table_selected"))))),
         
         conditionalPanel(condition = ("input.feat_selection == 'ridge'"),
                          fluidPage(tabsetPanel(
                            tabPanel("Ridge Plot", plotlyOutput("ridge_plot")),
                            tabPanel("Cross-Validation", plotlyOutput("cvglmnet2")),
                            tabPanel("Selected Features", DT::dataTableOutput("table_selected2")))))
         
           
  ))

