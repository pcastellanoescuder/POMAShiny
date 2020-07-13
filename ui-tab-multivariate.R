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
                  
                  radioButtons("mult_plot", h4("Multivariate methods:"), 
                               choices = c("Principal Component Analysis (PCA)" = 'pca',
                                           "Partial Least Squares - Discriminant Analysis (PLS-DA)" = 'plsda',
                                           "Sparse Partial Least Squares - Discriminant Analysis (sPLS-DA)" = 'splsda')
                               ),
                  
                  conditionalPanel(condition = ("input.mult_plot == 'pca'"),
                                   
                                   numericInput("num_comp1","Select number of components", min=2, max=20, value=6,step = 1),
                   
                                   prettySwitch("scale_pca", "Scale", fill = TRUE, status = "primary"),
                 
                                   prettySwitch("center_pca", "Center", fill = TRUE, status = "primary"),
                                   
                                   prettySwitch("ellipse1", "Show Ellipses", fill = TRUE, status = "primary")
                                   
                                   ),
                  
                  conditionalPanel(condition = ("input.mult_plot == 'plsda'"),
                                   
                                   numericInput("num_comp2","Select number of components",min=2,max=20,value=6,step = 1),
                                   
                                   numericInput("vip","Select VIP cutoff", value = 1.5),
                                   
                                   prettySwitch("ellipse2", "Show Ellipses", fill = TRUE, status = "primary", value = TRUE),
                                   
                                   radioButtons("validation_plsda", "Validation type:", choices = c("Mfold" = 'Mfold',
                                                                                                    "Leave One Out" = 'loo'),
                                                selected = 'Mfold'),
                                   
                                   conditionalPanel(condition = ("input.validation_plsda == 'Mfold'"),
                                                    
                                                    numericInput("plsda_folds", "Number of folds", value = 5)
                                                    
                                                    ),
                                   
                                   numericInput("validation_plsda_rep", "Number of iterations for validation process", value = 10)
                                   
                                   ),
                  
                  conditionalPanel(condition = ("input.mult_plot == 'splsda'"),
                                   
                                   numericInput("num_comp3","Select number of components",min=2,max=20,value=6,step = 1),
                                   
                                   numericInput("num_feat","Number of Features", value = 10),
                                   
                                   prettySwitch("ellipse3", "Show Ellipses", fill = TRUE, status = "primary", value = TRUE),
                                   
                                   radioButtons("validation_splsda", "Validation type:", choices = c("Mfold" = 'Mfold',
                                                                                                     "Leave One Out" = 'loo'),
                                                selected = 'Mfold'),
                                   
                                   conditionalPanel(condition = ("input.validation_splsda == 'Mfold'"),
                                                    
                                                    numericInput("splsda_folds", "Number of folds", value = 5)
                                                    
                                                    ),
                                   
                                   numericInput("validation_splsda_rep", "Number of iterations for validation process", value = 10)
                                   
                                   ),
                  
                  actionButton("plot_multivariate","Analyze", icon("step-forward"),
                               style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                                 title = "Multivariate analysis helper",
                                                                                                                 content = "multivariate",
                                                                                                                 icon = "question",
                                                                                                                 colour = "green")
                  )
         ),
  
  column(width = 9,
         
         conditionalPanel(condition = ("input.mult_plot == 'pca'"),
                          
                          fluidPage(
                            tabsetPanel(
                              tabPanel("Score Plot", plotlyOutput("pca_scores_plot")),
                              tabPanel("Score Table", dataTableOutput("pca_scores")),
                              tabPanel("Scree Plot", plotlyOutput("screeplot")),
                              tabPanel("Eigenvalues", dataTableOutput("pcaEigen")),
                              tabPanel("Biplot", plotlyOutput("biplot"))
                              )
                            )
                          ),
         
         conditionalPanel(condition = ("input.mult_plot == 'plsda'"),
                          
                          fluidPage(
                            tabsetPanel(
                              tabPanel("Score Plot", plotlyOutput("plsda_scores_plot")),
                              tabPanel("Score Table", dataTableOutput("plsda_scores")),
                              tabPanel("Error Rate Plot", plotlyOutput("plsda_errors_plot")),
                              tabPanel("BER Error Table", DT::dataTableOutput("ber_table")),
                              tabPanel("Overall Error Table", DT::dataTableOutput("overall_table")),
                              tabPanel("VIP Plot", plotlyOutput("vip_plsda_plot")),
                              tabPanel("VIP Table", DT::dataTableOutput("vip_table"))
                              )
                            )
                          ),
         
         conditionalPanel(condition = ("input.mult_plot == 'splsda'"),
                          fluidPage(
                            tabsetPanel(
                              tabPanel("Score Plot", plotlyOutput("splsda_scores_plot")),
                              tabPanel("Score Table", dataTableOutput("splsda_scores")),
                              tabPanel("Balanced Error Rate Plot", plotlyOutput("BalancedError")),
                              tabPanel("Balanced Error Table", DT::dataTableOutput("errors_splsda")),
                              tabPanel("Selected Features", DT::dataTableOutput("splsda_selected_var"))
                              
                              )
                            )
                          )
         )
  )

