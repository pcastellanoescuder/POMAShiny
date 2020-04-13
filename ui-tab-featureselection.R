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

fluidRow(
  column(width = 3,
                wellPanel(
                  
                  radioButtons("feat_selection", h4("Feature Selection Methods:"),
                               choices = c("Lasso" = 'lasso',
                                           "Ridge Regression" = 'ridge')),
                  numericInput("nfolds_lasso", "Internal CV folds:", value = 10),
                  
                  actionButton("feat_selection_action","Submit", icon("step-forward"),
                               style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                                 title = "Feature Selection helper",
                                                                                                                 content = "feature_selection",
                                                                                                                 icon = "question",
                                                                                                                 colour = "green")
  )),
  
  column(width = 9,
         
         conditionalPanel(condition = ("input.feat_selection == 'lasso'"),
                          fluidPage(tabsetPanel(
                            tabPanel("Lasso Plot", plotlyOutput("lasso_plot")),
                            tabPanel("Cross-Validation", plotlyOutput("cvglmnet_lasso")),
                            tabPanel("Selected Feature Coefficients", DT::dataTableOutput("selected_lasso"))))),
         
         conditionalPanel(condition = ("input.feat_selection == 'ridge'"),
                          fluidPage(tabsetPanel(
                            tabPanel("Ridge Plot", plotlyOutput("ridge_plot")),
                            tabPanel("Cross-Validation", plotlyOutput("cvglmnet_ridge")),
                            tabPanel("Feature Coefficients", DT::dataTableOutput("selected_ridge")))))
         
           
  ))

