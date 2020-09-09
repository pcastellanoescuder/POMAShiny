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

fluidRow(
  
  column(width = 3,
         
         bs4Card(
           width = 12,
           inputId = "regularization_card",
           title = "Regularization parameters",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           radioButtons("feat_selection", "Methods:",
                        choices = c("Lasso" = 'lasso',
                                    "Ridge Regression" = 'ridge',
                                    "Elasticnet" = 'elasticnet')
                        ),
           
           conditionalPanel("input.feat_selection == 'elasticnet'",
                            
                            sliderInput("alpha_sel", "Elasticnet Mixing Parameter", min = 0.1, max = 0.9, value = 0.5, step = 0.1)
                            
                            ),
           
           numericInput("lasso_test", "Test partition (%):", value = 0),
           
           numericInput("nfolds_lasso", "Internal CV folds:", value = 10),
           
           actionButton("feat_selection_action","Analyze", icon("step-forward"),
                        style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                          title = "Feature Selection helper",
                                                                                                          content = "feature_selection",
                                                                                                          icon = "question",
                                                                                                          colour = "green")
           )
         ),
  
  column(width = 9,
         
         conditionalPanel(condition = ("input.feat_selection == 'lasso'"),
                          
                          bs4TabCard(
                            side = "right",
                            width = 12,
                            id = "lasso_tab_card",
                            title = "Lasso",
                            status = "success",
                            solidHeader = FALSE,
                            collapsible = FALSE,
                            collapsed = FALSE,
                            closable = FALSE,
                            
                            bs4TabPanel(tabName = "Lasso Plot", plotlyOutput("lasso_plot")),
                            bs4TabPanel(tabName = "Cross-Validation", plotlyOutput("cvglmnet_lasso")),
                            bs4TabPanel(tabName = "Feature Coefficients", DT::dataTableOutput("selected_lasso")),
                            bs4TabPanel(tabName = "Prediction Metrics", DT::dataTableOutput("cm_lasso"))
                            )
                          ),
         
         conditionalPanel(condition = ("input.feat_selection == 'ridge'"),
                          
                          bs4TabCard(
                            side = "right",
                            width = 12,
                            id = "ridge_tab_card",
                            title = "Ridge",
                            status = "success",
                            solidHeader = FALSE,
                            collapsible = FALSE,
                            collapsed = FALSE,
                            closable = FALSE,
                            
                            bs4TabPanel(tabName = "Ridge Plot", plotlyOutput("ridge_plot")),
                            bs4TabPanel(tabName = "Cross-Validation", plotlyOutput("cvglmnet_ridge")),
                            bs4TabPanel(tabName = "Feature Coefficients", DT::dataTableOutput("selected_ridge")),
                            bs4TabPanel(tabName = "Prediction Metrics", DT::dataTableOutput("cm_ridge"))
                            )
                          ),
         
         conditionalPanel(condition = ("input.feat_selection == 'elasticnet'"),
                          
                          bs4TabCard(
                            side = "right",
                            width = 12,
                            id = "elasticnet_tab_card",
                            title = "Elasticnet",
                            status = "success",
                            solidHeader = FALSE,
                            collapsible = FALSE,
                            collapsed = FALSE,
                            closable = FALSE,
                            
                            bs4TabPanel(tabName = "Elasticnet Plot", plotlyOutput("elasticnet_plot")),
                            bs4TabPanel(tabName = "Cross-Validation", plotlyOutput("cvglmnet_elasticnet")),
                            bs4TabPanel(tabName = "Feature Coefficients", DT::dataTableOutput("selected_elasticnet")),
                            bs4TabPanel(tabName = "Prediction Metrics", DT::dataTableOutput("cm_elasticnet"))
                            )
                          )
  )
)

