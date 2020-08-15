# This file is part of POMA.

# POMA is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# POMA is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with POMA. If not, see <https://www.gnu.org/licenses/>.

fluidRow(
  column(width = 3,
         
         bs4Card(
           width = 12,
           inputId = "input_card",
           title = "Upload data panel",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           downloadButton("report", "Exploratory report", style="color: #fff; background-color: #00b300; border-color: #009900"),
           
           br(),
           br(),
           
           radioButtons("example_data", "Do you want to use our example data?",
                        choices = c("Yes" = 'yes',
                                    "No, upload my own data" = 'umd'),
                        selected = 'yes'),
           
           conditionalPanel(condition = "input.example_data == 'yes'",
                            
                            radioButtons("example_dataset", "Please, select an example dataset:",
                                         choices = c("Targeted LC/MS of urine from boys with Duchenne Muscular Dystrophy and controls (2 groups)" = 'st000336',
                                                     "Colorectal Cancer Detection Using Targeted Serum Metabolic Profiling (3 groups)" = 'st000284'),
                                         selected = 'st000336')
           ),
                            
           conditionalPanel(condition = "input.example_data == 'umd'",
                            
                            fileInput("target","Upload your target file (.csv):", accept = c(
                              "text/csv",
                              "text/comma-separated-values,text/plain",
                              ".csv")),
                            
                            fileInput("metabolites","Upload your features file (.csv):", accept = c(
                              "text/csv",
                              "text/comma-separated-values,text/plain",
                              ".csv"))
                            ),
           
           actionButton("upload_data","Submit", icon("paper-plane"),
                        style="color: #fff; background-color: #CD0000; border-color: #9E0000") %>% helper(type = "markdown",
                                                                                                          title = "Input Data helper",
                                                                                                          content = "input_data",
                                                                                                          icon = "question",
                                                                                                          colour = "green"),
           helpText("After click the button above,",
                    "go to the Pre-processing step")
           )
         ),
  
  column(width = 9,
         
         bs4Card(
           width = 12,
           inputId = "input_target_card",
           title = "Target File",
           status = "secondary",
           solidHeader = FALSE,
           collapsible = TRUE,
           collapsed = FALSE,
           closable = FALSE,
           DT::dataTableOutput("targetbox")
         ),
         bs4Card(
           width = 12,
           inputId = "input_feat_card",
           title = "Features File",
           status = "secondary",
           solidHeader = FALSE,
           collapsible = TRUE,
           collapsed = TRUE,
           closable = FALSE,
           DT::dataTableOutput("contents")
         ),
         bs4Card(
           width = 12,
           inputId = "input_sub_card",
           title = "Prepared Data",
           status = "success",
           solidHeader = FALSE,
           collapsible = TRUE,
           collapsed = FALSE,
           closable = FALSE,
           DT::dataTableOutput("submited")
         )
         )
  )

