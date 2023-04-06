# This file is part of POMAShiny.

# POMAShiny is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# POMAShiny is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with POMAShiny. If not, see <https://www.gnu.org/licenses/>.

fluidRow(
  column(width = 3,
         box(
           width = 12,
           inputId = "input_card",
           title = "Upload data panel",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           uiOutput("report_button"),
           uiOutput("space"),
           
           radioButtons("example_data", "Do you want to use our example data?",
                        choices = c("Yes" = 'yes',
                                    "No, upload my own data" = 'user_data'),
                        selected = 'yes'),
           
           conditionalPanel(condition = "input.example_data == 'yes'",
                            
                            radioButtons("example_dataset", "Please, select an example dataset:",
                                         choices = c("Colorectal Cancer Detection Using Targeted Serum Metabolic Profiling (3 groups)" = 'st000284',
                                                     "Targeted LC/MS of urine from boys with Duchenne Muscular Dystrophy and controls (2 groups)" = 'st000336'
                                                     ),
                                         selected = 'st000284')
           ),
                            
           conditionalPanel(condition = "input.example_data == 'user_data'",
                            
                            fileInput("target","Upload your target file (.csv):",
                                      accept = c("text/csv",
                                                 "text/comma-separated-values,text/plain",
                                                 ".csv")),
                            
                            fileInput("omicsdata","Upload your features file (.csv):", 
                                      accept = c("text/csv",
                                                 "text/comma-separated-values,text/plain",
                                                 ".csv")),
                            
                            prettySwitch("combine_feat", 
                                         "Combine features", 
                                         fill = TRUE, status = "primary", value = FALSE),
                            
                            conditionalPanel(condition = "input.combine_feat",
                                             
                                             fileInput("combine_data", "Grouping file (.csv):", 
                                                       accept = c("text/csv",
                                                                  "text/comma-separated-values,text/plain",
                                                                  ".csv")),
                                             
                                             selectizeInput("method_comb", "Combination method", 
                                                            choices = c("sum", "mean", "median", "robust", "NTR"),
                                                            selected = "sum")
                                             
                                             )
                            
                            ),
           
           actionButton("submit_data", 
                        "Submit", 
                        icon("paper-plane"),
                        style="color: #fff; background-color: #CD0000; border-color: #9E0000") %>% 
             helper(type = "markdown",
                    title = "Upload data helper",
                    content = "input_data",
                    icon = "question",
                    colour = "green")
           )
  ),
  
  column(width = 9,
         box(
           width = 12,
           inputId = "input_target_card",
           title = "Target File",
           status = "secondary",
           solidHeader = FALSE,
           collapsible = TRUE,
           collapsed = TRUE,
           closable = FALSE,
           DT::dataTableOutput("targetbox")
         ),
         box(
           width = 12,
           inputId = "input_feat_card",
           title = "Features File",
           status = "secondary",
           solidHeader = FALSE,
           collapsible = TRUE,
           collapsed = TRUE,
           closable = FALSE,
           DT::dataTableOutput("featuresbox")
         ),
         conditionalPanel(condition = ("input.combine_feat & input.example_data == 'umd'"),
                          box(
                            width = 12,
                            inputId = "input_comb_card",
                            title = "Combined Features Coefficient of Variation",
                            status = "secondary",
                            solidHeader = FALSE,
                            collapsible = TRUE,
                            collapsed = TRUE,
                            closable = FALSE,
                            DT::dataTableOutput("cv_combined")
                          )
         ),
         box(
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

