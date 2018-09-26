fluidRow(
  column(width = 3,
                wellPanel(
  radioButtons("mult_plot", h4("Multivariate methods:"),
               choices = c("Principal Component Analysis (PCA)" = 'pca',
                           "Partial Least Squares - Discriminant Analysis (PLS-DA)" = 'plsda',
                           "Sparse Partial Least Squares - Discriminant Analysis (sPLS-DA)" = 'splsda')),
  
  conditionalPanel(condition = ("input.mult_plot == 'plsda'"),
                   sliderInput("vip","Select VIP cutoff",min=0,max=3,value=1.5, step = .1)),
  
  conditionalPanel(condition = ("input.mult_plot == 'pca'"),
                   numericInput("num_comp","Select number of componets",min=2,max=20,value=6,
                                step = 1)),
  conditionalPanel(condition = ("input.mult_plot == 'plsda'"),
                   numericInput("num_comp2","Select number of componets",min=2,max=20,value=6,
                                step = 1)),
  conditionalPanel(condition = ("input.mult_plot == 'splsda'"),
                   numericInput("num_comp3","Select number of componets",min=2,max=20,value=6,
                                step = 1)),
                           
  
  actionButton("plot_multivariate","Analyze", icon("step-forward"),
               style="color: #fff; background-color: #00b300; border-color: #009900")
  )),
  
  column(width = 8,

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
                            tabPanel("Biplot", plotlyOutput("Biplot"))))),
         
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
                            tabPanel("ROC Curve", plotOutput("auc_plsdaOutput"),
                                     sliderInput("roc_comp1","Select ROC components",
                                                 min=1,max=5,value=1))
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
                            tabPanel("ROC Curve", plotOutput("auc_splsdaOutput")))))
         
           
  ))

