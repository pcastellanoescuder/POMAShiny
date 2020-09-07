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
         
         bs4Card(
           width = 12,
           inputId = "norm_card",
           title = "Normalization",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           radioButtons("normalization_method", "Methods:",
                        choices = c("None" = 'none',
                                    "Autoscaling" = 'auto_scaling', 
                                    "Level scaling" = 'level_scaling',
                                    "Log scaling" = 'log_scaling',
                                    "Log transformation" = 'log_transformation',
                                    "Vast scaling" = 'vast_scaling',
                                    "Log pareto scaling" = 'log_pareto'), 
                        selected = 'log_pareto'),
           
           prettySwitch("jitNorm", "Show boxplot points", fill = TRUE, status = "primary"),
           
           actionButton("norm_data","Normalize", icon("step-forward"),
                        style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                          title = "Normalization helper",
                                                                                                          content = "normalization",
                                                                                                          icon = "question",
                                                                                                          colour = "green")
         )
  ),
  
  column(width = 9,
         
         bs4Card(
           width = 12,
           inputId = "norm_raw_card",
           title = "Not Normalized Data",
           status = "secondary",
           solidHeader = FALSE,
           collapsible = TRUE,
           collapsed = TRUE,
           closable = FALSE,
           DT::dataTableOutput("input_normalized")
         ),
         bs4TabCard(
           side = "right",
           width = 12,
           id = "norm_proc_card",
           title = "Normalized Data",
           status = "success",
           solidHeader = FALSE,
           collapsible = TRUE,
           collapsed = FALSE,
           closable = FALSE,
           
           bs4TabPanel(tabName = "Data", DT::dataTableOutput("normalized")),
           bs4TabPanel(tabName = "Raw Data Boxplot", plotlyOutput("norm_plot1")),
           bs4TabPanel(tabName = "Normalized Boxplot", plotlyOutput("norm_plot2"))
           )
         )
  )
         
