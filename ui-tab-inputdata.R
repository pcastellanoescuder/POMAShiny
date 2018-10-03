tabPanel("Input Data", 
         fluidRow(column(width = 2,
                         
              
                         radioButtons("example_data", "Do you want to use our example data?",
                                      choices = c("Yes" = 'yes',
                                                  "No, upload my own data" = 'umd'),
                                      selected = 'yes'),
                         
                         conditionalPanel(condition = ("input.example_data == 'yes'")),
                         
                         conditionalPanel(condition = ("input.example_data == 'umd'"),
                                          fileInput("metabolites","Please choose your data (.csv):", accept = c("text/csv", 
                                                                                                               "text/comma-separated-values,text/plain",
                                                                                                               ".csv")),
                                          helpText("Select if your data has column names (default)"),
                                          checkboxInput("header", "Header", TRUE)),

                  selectInput("samples",label="Samples (IDs)",choices=NULL),
                  selectInput("groups",label="Groups",choices=NULL),
                  selectInput("metF",label="First Metabolite",choices=NULL),
                  selectInput("metL",label="Last Metabolite",choices=NULL),
         
                  conditionalPanel(condition = ("input.example_data == 'umd'"),
                  tags$hr(),
                  helpText("Optional. This file must has same rownames",
                           "(IDs) than metabolites matrix"),
                  fileInput("target",
                            "Upload your covariates file (.csv):",
                            accept = c(
                              "text/csv",
                              "text/comma-separated-values,text/plain",
                              ".csv"))),
                  
                  actionButton("upload_data","Submit", icon("paper-plane"),
                      style="color: #fff; background-color: #CD0000; border-color: #9E0000"),
                  
                  helpText("After click the button above,",
                           "go to the Pre-processing step")
                  ),

         column(10,
                bsCollapse(id="input_collapse_panel",open="data_panel",multiple = FALSE,
                           bsCollapsePanel(title="Uploaded Data",value="data_panel",
                                           div(style = 'overflow-x: scroll', DT::dataTableOutput("contents"), width = NULL,
                                               status = "primary")),
                           bsCollapsePanel(title="Prepared Data",value="prepared_panel",
                                           div(style = 'overflow-x: scroll', DT::dataTableOutput("submited"), width = NULL,
                                               status = "primary")),
                           bsCollapsePanel(title="Covariates file",value="cov_panel",
                                           div(style = 'overflow-x: scroll', DT::dataTableOutput("covariates"), width = NULL,
                                               status = "primary"))
                           ))))

