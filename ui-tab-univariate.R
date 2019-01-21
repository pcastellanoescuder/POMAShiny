fluidRow(
  column(width = 3,
         wellPanel(
           
           radioButtons("univariate_test",  h4("Univariate methods:"),
                        choices = c("Limma"='limma', 
                                    "T-test" = 'ttest',
                                    "ANOVA" = 'anova',
                                    "Mann-Whitney U Test" = 'mann',
                                    "Kruskal Wallis Test" = 'kruskal'),
                        selected = 'ttest'
                        ),
           
           conditionalPanel(condition = ("input.univariate_test == 'ttest'"),
                            
                            radioButtons("variance",  h4("Variances are equal:"),
                                         choices = c("TRUE" = 'TRUE', 
                                                     "FALSE (Welch's T-test)" = 'FALSE'),
                                         selected = 'FALSE'),
                            radioButtons("paired",  h4("Paired samples:"),
                                         choices = c("TRUE" = 'TRUE', 
                                                     "FALSE" = 'FALSE'),
                                         selected = 'FALSE'),
                            
                            h4("Volcano Plot Parameters:"),
                            
                            numericInput("pcut",strong("P.Value threshold"),0.05, step = 0.01),
                            numericInput("FCcut",strong("Fold change threshold"),1.5, step = 0.1),
                            sliderInput("xlmslider", strong("xlim range"), 1, 10, 2, step = 0.5,animate = TRUE),
                            selectInput("theme", "Plot Theme:",
                                        c("default","Tufte","Economist","Solarized",
                                          "Stata","Excel 2003","Inverse Gray","Fivethirtyeight",
                                          "Tableau","Stephen","Wall Street","GDocs","Calc","Pander","Highcharts"))
                            ),
           
           conditionalPanel(condition = ("input.univariate_test == 'mann'"),
                            
                            radioButtons("paired2",  h4("Paired samples:"),
                                         choices = c("TRUE (Wilcoxon Signed Rank Test)" = 'TRUE', 
                                                     "FALSE" = 'FALSE'),
                                         selected = 'FALSE')),
           
           actionButton("play_test","Analyze", icon("step-forward"),
                        style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                          title = "Univariate analysis helper",
                                                                                                          content = "univariate",
                                                                                                          icon = "question",
                                                                                                          colour = "green")
           
         )),
  
  column(width = 8,
         conditionalPanel(condition = ("input.univariate_test == 'limma'"),
                          fluidPage(tabsetPanel(
                            tabPanel("Results without using co-variates", div(style = 'overflow-x: scroll', DT::dataTableOutput("matriu"), width = NULL,
                                                      status = "primary")),
                            tabPanel("Results using co-variates", div(style = 'overflow-x: scroll', DT::dataTableOutput("matriu_cov"), width = NULL,
                                                      status = "primary"))
                            )
                          )
         ),
         conditionalPanel(condition = ("input.univariate_test == 'ttest'"),
                          fluidPage(tabsetPanel(
                            tabPanel("Results",div(style='overflow-x: scroll', DT::dataTableOutput("matriu2"), width=NULL,
                                                        status="primary")),
                            tabPanel("Volcano Plot", plotlyOutput("vocalnoPlot")
                                                                  
                            )
                          ) #tabsetPanel
                          )#FluidPage
         ),
         conditionalPanel(condition = ("input.univariate_test == 'anova'"),
                          fluidPage(tabsetPanel(
                            tabPanel("Results without using co-variates", DT::dataTableOutput("matriu_anova")),
                            tabPanel("Results using co-variates", div(style = 'overflow-x: scroll', DT::dataTableOutput("matriu_anova_cov"), width = NULL,
                                                                       status = "primary"))
                          ) #tabsetPanel
                          )
         ),
         conditionalPanel(condition = ("input.univariate_test == 'mann'"),
                          fluidPage(
                            div(style = 'overflow-x: scroll', DT::dataTableOutput("matriu_mann"), width = NULL,
                                status = "primary")
                          )
         ),
         conditionalPanel(condition = ("input.univariate_test == 'kruskal'"),
                          fluidPage(
                            DT::dataTableOutput("matriu_kruskal")
                          )
         )
  )
)

