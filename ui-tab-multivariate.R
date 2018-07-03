fluidRow(
  column(width = 3,
                wellPanel(
  radioButtons("mult_plot", h4("Multivariate visualization methods:"),
               choices = c("Principal Component Analysis (PCA)" = 'pca',
                           "Partial Least Squares - Discriminant Analysis (PLS-DA)" = 'plsda',
                           "Sparse Partial Least Squares - Discriminant Analysis (sPLS-DA)" = 'splsda')),
                           
  
  actionButton("plot_multivariate","Analyze", icon("step-forward"),
               style="color: #fff; background-color: #00b300; border-color: #009900")
  )),
  
  column(width = 6,

         conditionalPanel(condition = ("input.mult_plot == 'pca'"),
                          fluidPage(tabsetPanel(
                            tabPanel("Scores Plot", plotOutput("pca2D")),
                            tabPanel("Scree Plot", plotOutput("ScreePlot")),
                            tabPanel("Biplot", plotOutput("Biplot"))))),
         
         conditionalPanel(condition = ("input.mult_plot == 'plsda'"),
                          fluidPage(tabsetPanel(
                            tabPanel("Scores Plot", plotOutput("plsda2D")),
                            tabPanel("Error Rate Plot", plotOutput("plsda_errors")),
                            tabPanel("ROC Curve", plotOutput("auc_plsdaOutput"))))),
         
         conditionalPanel(condition = ("input.mult_plot == 'splsda'"),
                          fluidPage(tabsetPanel(
                            tabPanel("Scores Plot", plotOutput("splsda2D")),
                            tabPanel("Balanced Error Rate", plotOutput("BalancedError")),
                            tabPanel("ROC Curve", plotOutput("auc_splsdaOutput")))))
         
           
  ))

