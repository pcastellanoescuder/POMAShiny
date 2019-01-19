fluidRow(
  column(width = 3,
         wellPanel(
           radioButtons("enrichment", h4("Biological significance analyses:"),
                        choices = c("Food analysis" = 'food_method',
                                    "Biological analysis" = 'KEGG'), selected = "food_method"),
           h6(textOutput("numheat")),
           conditionalPanel(condition = ("input.enrichment == 'food_method'"),
                            
                            radioButtons("dataset", label=h5("Select Dataset Original"), c("Food dataset" = "example", Upload = "upload"),selected = 'example'),
                            conditionalPanel(
                              condition = "input.dataset == 'upload'",
                              
                              fileInput('file1', 'Choose CSV/text File',
                                        accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
                              checkboxInput('header', 'Header', FALSE),
                              radioButtons('sep', label= p(em(h5('Separator'))),
                                           c(Comma=',',
                                             Semicolon=';',
                                             Tab='\t'),
                                           '\t'),
                              radioButtons('quote',label= p(em(h5 ('Quote'))),
                                           c(None='',
                                             'Double Quote'='"',
                                             'Single Quote'="'"),
                                           '')
                            )),
           hr(),
           radioButtons("select_method", "Which significant p-values do you want to use:",
                        choices = c("Before adjusting (FDR)" = 'before_FDR',
                                    "After adjusting (FDR)" = 'after_FDR' ),
                        selected = 'before_FDR')
           ,
           
           actionButton("play_test_enrich","Analyze", icon("step-forward"),
                        style="color: #fff; background-color: #00b300; border-color: #009900")
      
            )),
  
  column(width = 9,
           fluidPage(tabsetPanel(
                            tabPanel("Hypergeometric test", 
                                     div(style = 'overflow-x: scroll', DT::dataTableOutput("matriu_enrich"), width = NULL,
                                      status = "primary")),
                            tabPanel("Bar Plot", 
                                     fluidRow(
                                       column(5,plotOutput(outputId = 'bar_plot', width = "800px", height = "800px"))))        
                          ) #tabsetPanel
                          )#FluidPage
         )
         
  )
