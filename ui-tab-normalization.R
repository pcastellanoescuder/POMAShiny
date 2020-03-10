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
                wellPanel(
  radioButtons("normalization_type", h4("Normalization methods:"),
               choices = c("None" = 'none',
                           "Autoscaling" = 'auto_scaling', 
                           "Level scaling" = 'level_scaling',
                           "Log scaling" = 'log_scaling',
                           "Log transformation" = 'log_transformation',
                           "Vast scaling" = 'vast_scaling',
                           "Log pareto scaling" = 'log_pareto'), selected = 'log_pareto'),
  
  actionButton("norm_data","Normalize", icon("step-forward"),
               style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                 title = "Normalization helper",
                                                                                                 content = "normalization",
                                                                                                 icon = "question",
                                                                                                 colour = "green")
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

