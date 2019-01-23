fluidRow(column(width = 3,
                wellPanel(
                h4("Missing values estimation"),
                
                radioButtons("zeros_are_NA", "1. Are the zeros in your data missing values?",
                             choices = c("Yes" = 'yes',
                                         "No" = 'no'),
                             selected = 'yes'),
                
                radioButtons("select_remove", "2. Do you want to remove metabolites with too many missing values?",
                             choices = c("Yes" = 'yes',
                                         "No" = 'no'),
                             selected = 'yes'),
                
                conditionalPanel(condition = ("input.select_remove == 'yes'"),
                                 sliderInput("value_remove", "Percentage of missing values allowed for each metabolite in each group:",
                                              value = 20, min = 5, max = 100)),
                
                radioButtons("select_method", "3. Select a method to imputate your data:",
                              choices = c("Replace missing values by zero" = 'none',
                                          "Half of the minimum positive value in the original data" = 'half_min',
                                          "Median" = 'median',
                                          "Mean" = 'mean',
                                          "Minimum" = 'min',
                                          "KNN" = 'knn'),
                             selected = 'knn'),
  
                actionButton("process","Impute", icon("step-forward"),
                             style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                               title = "Impute values helper",
                                                                                                               content = "impute",
                                                                                                               icon = "question",
                                                                                                               colour = "green")
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

