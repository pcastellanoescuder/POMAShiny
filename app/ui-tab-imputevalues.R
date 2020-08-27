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
         
         bs4Card(
           width = 12,
           inputId = "impute_card",
           title = "Missing value imputation",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           radioButtons("ZerosAsNA", "1. Are the zeros in your data missing values?",
                        choices = c("Yes" = TRUE,
                                    "No" = FALSE),
                        selected = TRUE),
           
           radioButtons("RemoveNA", "2. Do you want to remove features with too many missing values?",
                        choices = c("Yes" = TRUE,
                                    "No" = FALSE),
                        selected = TRUE),
           
           conditionalPanel(condition = ("input.RemoveNA == 'TRUE'"),
                            sliderInput("cutoff_imp", "Percentage of missing values allowed for each feature in each group:",
                                        value = 20, min = 5, max = 100)),
           
           radioButtons("imputation_method", "3. Select a method to imputate your data:",
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
           )
         ),
  
  column(width = 9,
         
         bs4Card(
           width = 12,
           inputId = "impute_raw_card",
           title = "Prepared Data",
           status = "secondary",
           solidHeader = FALSE,
           collapsible = TRUE,
           collapsed = TRUE,
           closable = FALSE,
           DT::dataTableOutput("raw")
           ),
         bs4Card(
           width = 12,
           inputId = "impute_proc_card",
           title = "Imputed Data",
           status = "success",
           solidHeader = FALSE,
           collapsible = TRUE,
           collapsed = FALSE,
           closable = FALSE,
           DT::dataTableOutput("imputed")
         )
  )
  )

