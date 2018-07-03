fluidRow(column(width = 3,
                wellPanel(
                h3("Missing values estimation"),
                
                radioButtons("select_remove", "1. Do you want to remove metabolites with too many missing values?",
                             choices = c("Yes" = 'yes',
                                         "No" = 'no'),
                             selected = NULL),
                
                conditionalPanel(condition = ("input.select_remove == 'yes'"),
                                 numericInput("value_remove", "Percentage of missing values allowed for each metabolite in each group:",
                                              value = 50,min = 0, max = 100)),
                
                radioButtons("select_method", "2. Select a method to imputate your data:",
                              choices = c("Replace missing values by zero" = 'none',
                                          "Half of the minimum positive value in the original data" = 'half_min',
                                          "Median" = 'median',
                                          "Mean" = 'mean',
                                          "Minimum" = 'min',
                                          "KNN" = 'knn'),
                             selected = 'half_min'),
  
                actionButton("process","Impute", icon("step-forward"),
                             style="color: #fff; background-color: #00b300; border-color: #009900")
  )),
  column(width = 9,
         
         bsCollapse(id="imp_collapse_panel",open="impute_panel",multiple = FALSE,
                    bsCollapsePanel(title="Prepared Data",value="raw_panel",
                                    div(style = 'overflow-x: scroll', DT::dataTableOutput("raw"), width = NULL,
                                        status = "primary")),
                    bsCollapsePanel(title="Imputed Data",value="impute_panel",
                                    div(style = 'overflow-x: scroll', DT::dataTableOutput("imputed"), width = NULL,
                                        status = "primary"))
  )
))

