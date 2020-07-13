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
         
         downloadButton("report", "Exploratory report", style="color: #fff; background-color: #00b300; border-color: #009900"),
                
         br(),
         br(),
         
         radioButtons("example_data", "Do you want to use our example data?",
                      choices = c("Yes" = 'yes',
                                  "No, upload my own data" = 'umd'),
                      selected = 'yes'),
         
         conditionalPanel(condition = ("input.example_data == 'umd'"),
                          
                          fileInput("target","Upload your target file (.csv):", accept = c(
                            "text/csv",
                            "text/comma-separated-values,text/plain",
                            ".csv")),
                          
                          fileInput("metabolites","Upload your features file (.csv):", accept = c(
                            "text/csv",
                            "text/comma-separated-values,text/plain",
                            ".csv")),
                          
                          helpText("Optional. This file must has same rownames",
                                   "(IDs) than the target file"),
                          
                          fileInput("covariates",
                                    "Upload your covariates file (.csv):",
                                    accept = c(
                                      "text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))),
         
         actionButton("upload_data","Submit", icon("paper-plane"),
             style="color: #fff; background-color: #CD0000; border-color: #9E0000") %>% helper(type = "markdown",
                                                                                               title = "Input Data helper",
                                                                                               content = "input_data",
                                                                                               icon = "question",
                                                                                               colour = "green"),
         helpText("After click the button above,",
                  "go to the Pre-processing step")
         ),
  
  column(9,
         
         bsCollapse(id="input_collapse_panel",open="target_panel", multiple = FALSE,
                    
                    bsCollapsePanel(title="Target File", value="target_panel", DT::dataTableOutput("targetbox")),
                    bsCollapsePanel(title="Features File", value="data_panel", DT::dataTableOutput("contents")),
                    bsCollapsePanel(title="Covariates File", value="cov_panel", DT::dataTableOutput("covariates")),
                    bsCollapsePanel(title="Prepared Data", value="prepared_panel", DT::dataTableOutput("submited"))
                    ))
  )

