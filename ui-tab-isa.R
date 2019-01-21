tabPanel("Intelligent Statistical Analysis", 
         fluidRow(column(width = 10,
                         
                         radioButtons("from",  h3("Intelligent Statistical Analysis:"),
                                      choices = c("Default 'Pre-processing' by POMA"= 'beginning', 
                                                  "Selected 'Pre-processing' by user" = 'userpre'),
                                      selected = 'beginning'
                         ),
                         
                         radioButtons("paired22",  h4("Is your data paired?"),
                                      choices = c("TRUE" = 'TRUE', 
                                                  "FALSE" = 'FALSE'),
                                      selected = 'FALSE'),
                         
                         downloadButton("report2", "Generate statistical intelligent report", 
                                        style="color: #fff; background-color: #00b300; border-color: #009900")
         )))

