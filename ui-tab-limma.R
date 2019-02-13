
fluidRow(
  column(width = 3,
         wellPanel(
           selectInput("coef_limma", h4("Select your contrast:"),
                       choices = NULL),
           
           actionButton("play_limma","Analyze", icon("step-forward"),
                        style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                          title = "Limma analysis helper",
                                                                                                          content = "limma",
                                                                                                          icon = "question",
                                                                                                          colour = "green")
           )),
  
  column(width = 8,
         fluidPage(tabsetPanel(
                   tabPanel("Results without using co-variates", div(style = 'overflow-x: scroll', DT::dataTableOutput("matriu"), width = NULL,
                                                                     status = "primary")),
                   tabPanel("Results using co-variates", div(style = 'overflow-x: scroll', DT::dataTableOutput("matriu_cov"), width = NULL,
                                                             status = "primary"))
                   ))
         ))


                 
                 