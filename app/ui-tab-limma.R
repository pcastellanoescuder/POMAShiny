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
           inputId = "limma_card",
           title = "Limma parameters",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           selectInput("coef_limma", "Select a contrast:", choices = NULL),
           
           actionButton("play_limma","Analyze", icon("step-forward"),
                        style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                          title = "Limma analysis helper",
                                                                                                          content = "limma",
                                                                                                          icon = "question",
                                                                                                          colour = "green")
           )
         ),
  
  column(width = 9,
         
         bs4TabCard(
           side = "right",
           width = 12,
           id = "limma_tab_card",
           title = "Limma",
           status = "success",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           bs4TabPanel(tabName = "Results without covariates", DT::dataTableOutput("limma")),
           bs4TabPanel(tabName = "Results with covariates", DT::dataTableOutput("limma_cov"), width = NULL),
           bs4TabPanel(tabName = "Volcano Plot", 
                       
                       dropdownButton(
                         circle = TRUE, status = "warning", icon = icon("gear"), margin = "25px", 
                         
                         selectInput("pval_limma", "p-value type", choices = c("raw", "adjusted"), selected = "raw"),
                         
                         numericInput("pval_cutoff_limma", strong("p-value threshold"), value = 0.05, step = 0.01),
                         
                         numericInput("log2FC_limma", strong("log2 Fold change threshold"), value = 1.5, step = 0.1),
                         
                         numericInput("xlim_limma", "x-axis range", value = 2)
                         ),
                       
                       plotlyOutput("limma_volcano"))
         )
         )
  )

