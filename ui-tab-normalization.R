fluidRow(
  column(width = 3,
                wellPanel(
  radioButtons("normalization_type", h4("Normalization methods:"),
               choices = c("None" = 'none',
                           "Autoscaling" = 'auto_scaling', 
                           "Level scaling" = 'level_scaling',
                           "Log scaling" = 'log_scaling',
                           "Log transformation" = 'log_transformation',
                           "Vast scaling" = 'vast_scaling',
                           "Log pareto" = 'log_pareto')),
                           #"Pareto scaling" = 'pareto_scaling')),
  
  actionButton("norm_data","Normalize", icon("step-forward"),
               style="color: #fff; background-color: #00b300; border-color: #009900")
  )),
  
  column(width = 9,
         bsCollapse(id="norm_collapse_panel",open="norm_panel",multiple = FALSE,
                    bsCollapsePanel(title="Not Normalized Data",value="not_norm_panel",
                                    div(style = 'overflow-x: scroll', DT::dataTableOutput("input_normalized"), width = NULL,
                                        status = "primary")),
                    bsCollapsePanel(title="Normalized Data",value="norm_panel",
                                    tabsetPanel(
                                      tabPanel("Data",
                                    div(style = 'overflow-x: scroll', DT::dataTableOutput("normalized"), width = NULL,
                                        status = "primary")),
                                    tabPanel("Raw Data Boxplot", plotlyOutput("norm_plot1")),
                                    tabPanel("Normalized Boxplot", plotlyOutput("norm_plot2"))
                                    ))
         )))

