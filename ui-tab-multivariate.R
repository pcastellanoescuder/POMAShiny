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
  
  conditionalPanel(condition = ("input.mult_plot == 'plsda'"),
                   sliderInput("vip","Select VIP cutoff",min=0,max=3,value=1.5, step = .1)),
  
  conditionalPanel(condition = ("input.mult_plot == 'pca'"),
                   numericInput("num_comp","Select number of components",min=2,max=20,value=6,
                                step = 1)),
  conditionalPanel(condition = ("input.mult_plot == 'pca'"),
                   radioButtons("scale","Scale:",
                                choices = c("TRUE" = 'TRUE',
                                            "FALSE" = 'FALSE'),
                                selected = 'TRUE')),
  conditionalPanel(condition = ("input.mult_plot == 'pca'"),
                   radioButtons("center","Center:",
                                choices = c("TRUE" = 'TRUE',
                                            "FALSE" = 'FALSE'),
                                selected = 'TRUE')),
  conditionalPanel(condition = ("input.mult_plot == 'plsda'"),
                   numericInput("num_comp2","Select number of components",min=2,max=20,value=6,
                                step = 1)),
  conditionalPanel(condition = ("input.mult_plot == 'splsda'"),
                   numericInput("num_comp3","Select number of components",min=2,max=20,value=6,
                                step = 1),
                   numericInput("num_feat","Number of Features",min=1,max=30,value=10,
                                step = 1)),
                          
  
  actionButton("plot_multivariate","Analyze", icon("step-forward"),
               style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                 title = "Multivariate analysis helper",
                                                                                                 content = "multivariate",
                                                                                                 icon = "question",
                                                                                                 colour = "green")
  )),
  
  column(width = 9,

         conditionalPanel(condition = ("input.mult_plot == 'pca'"),
                          fluidPage(tabsetPanel(
                            tabPanel("Score Plot", plotlyOutput("pca2D")),
                            tabPanel("Score Table", div(style = 'overflow-x: scroll', 
                                                         dataTableOutput("pcaX"), 
                                                         width = NULL,
                                                         status = "primary")),
                            tabPanel("Scree Plot", plotlyOutput("ScreePlot")),
                            tabPanel("Eigenvalues", div(style = 'overflow-x: scroll', 
                                                        dataTableOutput("pcaEigen"), 
                                                        width = NULL,
                                                        status = "primary")),
                            tabPanel("Biplot", div(plotlyOutput("Biplot"), style = 'display: block; margin-left: 150px'))
                            ))),
         
         conditionalPanel(condition = ("input.mult_plot == 'plsda'"),
                          fluidPage(tabsetPanel(
                            tabPanel("Score Plot", plotlyOutput("plsda2D")),
                            tabPanel("Score Table", div(style = 'overflow-x: scroll', 
                                                        dataTableOutput("plsdaX1"), 
                                                        width = NULL,
                                                        status = "primary")),
                            tabPanel("Error Rate Plot", plotlyOutput("plsda_errors")),
                            tabPanel("BER Error Table", DT::dataTableOutput("ber_table")),
                            tabPanel("Overall Error Table", DT::dataTableOutput("overall_table")),
                            tabPanel("VIP Plot", plotlyOutput("vip_plsdaOutput")),
                            tabPanel("VIP Table", div(style = 'overflow-x: scroll', 
                                                      DT::dataTableOutput("vip_table"), 
                                                      width = NULL,
                                                      status = "primary")),
                            tabPanel("ROC Curve", plotOutput("auc_plsdaOutput"))
                            ))),
         
         conditionalPanel(condition = ("input.mult_plot == 'splsda'"),
                          fluidPage(tabsetPanel(
                            tabPanel("Score Plot", plotlyOutput("splsda2D")),
                            tabPanel("Score Table", div(style = 'overflow-x: scroll', 
                                                        dataTableOutput("splsdaX1"), 
                                                        width = NULL,
                                                        status = "primary")),
                            tabPanel("Balanced Error Rate", plotlyOutput("BalancedError")),
                            tabPanel("Balanced Error Table", DT::dataTableOutput("errors_splsda")),
                            tabPanel("Selected Features", DT::dataTableOutput("selected_var")),
                            tabPanel("ROC Curve", plotOutput("auc_splsdaOutput")))))
         
         
           
  ))

