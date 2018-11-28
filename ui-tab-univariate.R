fluidRow(
  column(width = 3,
         wellPanel(
           
           radioButtons("univariate_test",  h4("Univariate methods:"),
                        choices = c("Limma"='limma', 
                                    "Welch's T-test" = 'ttest',
                                    "ANOVA" = 'anova',
                                    "Mann-Whitney U Test" = 'mann',
                                    "Kruskal Wallis Test" = 'kruskal')
                        ),
           
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
                            tabPanel("Volcano Plot",
                                     box(
                                       width = 9, status = "info", solidHeader = F,collapsible = F,
                                       title = "Do you want to display a volcano plot?",
                                       tags$button(id="goPlot",type="button",class="btn btn-primary action-button","GO PLOT!")
                                     ),
                                     bsModal("KEGGPlotModal", h3("Volcano Plot"), "goPlot", size = "large",
                                                              box(title = "Parameters", width = 3, status = "info", solidHeader = TRUE,collapsible = TRUE,
                                                                  numericInput("pcut",strong("P.Value threshold"),0.05),
                                                                  numericInput("FCcut",strong("Fold change threshold"),1.5),
                                                                  sliderInput("xlmslider", strong("xlim range"), 1, 10, 5, step = 0.5,animate = TRUE),
                                                                  #sliderInput("ylmslider", strong("ylim range"), 1, 50, 5, step = 0.5,animate = TRUE),
                                                                  selectInput("theme", "Plot Theme:",
                                                                              c("default","Tufte","Economist","Solarized",
                                                                                "Stata","Excel 2003","Inverse Gray","Fivethirtyeight",
                                                                                "Tableau","Stephen","Wall Street","GDocs","Calc","Pander","Highcharts"))
                                                              ),
                                                              box(title = "Plot", width = 9, status = "success", solidHeader = F,collapsible = TRUE,
                                                                  div(
                                                                    downloadLink('downloadDataPNG', 'Download PNG',class="downloadLinkblack"),
                                                                    downloadLink('downloadDataPDF', 'Download PDF',class="downloadLinkred"),
                                                                    downloadLink('downloadDataTIFF', 'Download TIFF',class="downloadLinkgreen"),
                                                                    plotOutput("vocalnoPlot",height="100%",width="100%")
                                                                  )
                                                              )
                                                              
                                                              
                            ))
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
                            DT::dataTableOutput("matriu_mann")
                          )
         ),
         conditionalPanel(condition = ("input.univariate_test == 'kruskal'"),
                          fluidPage(
                            DT::dataTableOutput("matriu_kruskal")
                          )
         )
  )
)

