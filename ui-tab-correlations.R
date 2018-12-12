fluidRow(
  column(width = 3,
                wellPanel(
  
                  h4("Correlation between:"),
                  
                  selectInput("one",label="Metabolite 1", choices = NULL),
                  
                  h4("and"),
                  
                  selectInput("two",label="Metabolite 2", choices = NULL), 
                  
                  radioButtons("corr_method", "Correlation Method:", c("Pearson" = "pearson",
                                                                       "Spearman" = "spearman",
                                                                       "Kendall" = "kendall"))
  )),
  
  column(width = 8,
         
         fluidPage(
           tabsetPanel(
             tabPanel("Pairwise Correlation Scatterplot", plotlyOutput("cor_plot")),
             tabPanel("Global Correlation Plot", plotlyOutput("corr_plot", height = 700))
           ))

  ))

