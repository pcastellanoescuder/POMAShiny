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
           inputId = "multivariate_card",
           title = "Multivariate analysis",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           radioButtons("mult_plot", "Multivariate methods:", 
                        choices = c("Principal Component Analysis (PCA)" = 'pca',
                                    "Partial Least Squares - Discriminant Analysis (PLS-DA)" = 'plsda',
                                    "Sparse Partial Least Squares - Discriminant Analysis (sPLS-DA)" = 'splsda')
           ),
           
           conditionalPanel(condition = ("input.mult_plot == 'pca'"),
                            
                            numericInput("num_comp1","Select number of components", min=2, max=20, value=6,step = 1),
                            
                            prettySwitch("scale_pca", "Scale", fill = TRUE, status = "primary"),
                            
                            prettySwitch("center_pca", "Center", fill = TRUE, status = "primary"),
                            
                            prettySwitch("ellipse1", "Show ellipses", fill = TRUE, status = "primary")
                            
           ),
           
           conditionalPanel(condition = ("input.mult_plot == 'plsda'"),
                            
                            numericInput("num_comp2","Select number of components",min=2,max=20,value=6,step = 1),
                            
                            numericInput("vip","Select VIP cutoff", value = 1.5),
                            
                            prettySwitch("ellipse2", "Show ellipses", fill = TRUE, status = "primary", value = TRUE),
                            
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
                            
                            prettySwitch("ellipse3", "Show ellipses", fill = TRUE, status = "primary", value = TRUE),
                            
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
                          
                          bs4TabCard(
                            side = "right",
                            width = 12,
                            id = "pca_card",
                            title = "PCA",
                            status = "success",
                            solidHeader = FALSE,
                            collapsible = FALSE,
                            collapsed = FALSE,
                            closable = FALSE,
                            
                            bs4TabPanel(tabName = "Score Plot", plotlyOutput("pca_scores_plot")),
                            bs4TabPanel(tabName = "Score Table", dataTableOutput("pca_scores")),
                            bs4TabPanel(tabName = "Scree Plot", plotlyOutput("screeplot")),
                            bs4TabPanel(tabName = "Eigenvalues", dataTableOutput("pcaEigen")),
                            bs4TabPanel(tabName = "Biplot", plotlyOutput("biplot"))
                            )
                          ),
         
         conditionalPanel(condition = ("input.mult_plot == 'plsda'"),
                          
                          bs4TabCard(
                            side = "right",
                            width = 12,
                            id = "plsda_card",
                            title = "PLS-DA",
                            status = "success",
                            solidHeader = FALSE,
                            collapsible = FALSE,
                            collapsed = FALSE,
                            closable = FALSE,
      
                            bs4TabPanel(tabName = "Score Plot", plotlyOutput("plsda_scores_plot")),
                            bs4TabPanel(tabName = "Score Table", dataTableOutput("plsda_scores")),
                            bs4TabPanel(tabName = "Error Rate Plot", plotlyOutput("plsda_errors_plot")),
                            bs4TabPanel(tabName = "BER Error Table", DT::dataTableOutput("ber_table")),
                            bs4TabPanel(tabName = "Overall Error Table", DT::dataTableOutput("overall_table")),
                            bs4TabPanel(tabName = "VIP Plot", plotlyOutput("vip_plsda_plot")),
                            bs4TabPanel(tabName = "VIP Table", DT::dataTableOutput("vip_table"))
                            )
                          ),
         
         conditionalPanel(condition = ("input.mult_plot == 'splsda'"),
                          
                          bs4TabCard(
                            side = "right",
                            width = 12,
                            id = "splsda_card",
                            title = "sPLS-DA",
                            status = "success",
                            solidHeader = FALSE,
                            collapsible = FALSE,
                            collapsed = FALSE,
                            closable = FALSE,
                            
                            bs4TabPanel(tabName = "Score Plot", plotlyOutput("splsda_scores_plot")),
                            bs4TabPanel(tabName = "Score Table", dataTableOutput("splsda_scores")),
                            bs4TabPanel(tabName = "Balanced Error Rate Plot", plotlyOutput("BalancedError")),
                            bs4TabPanel(tabName = "Balanced Error Table", DT::dataTableOutput("errors_splsda")),
                            bs4TabPanel(tabName = "Selected Features", DT::dataTableOutput("splsda_selected_var"))
                            )
                          )
         )
  )
  

