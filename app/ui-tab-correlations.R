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
           inputId = "corr_card",
           title = "Correlation parameters",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           radioButtons("corr_method", "Correlation Method:", c("Pearson" = "pearson",
                                                                "Spearman" = "spearman",
                                                                "Kendall" = "kendall")
                        ) %>% helper(type = "markdown",
                                     title = "Correlation analysis helper",
                                     content = "correlations",
                                     icon = "question",
                                     colour = "green")
           )
         ),
  
  column(width = 9,
         
         bs4TabCard(
           side = "right",
           width = 12,
           id = "corr_tab_card",
           title = "Correlations",
           status = "success",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           bs4TabPanel(tabName = "Pairwise Correlation Scatterplot", 
                       
                       dropdownButton(
                         circle = TRUE, status = "warning", icon = icon("gear"), margin = "25px", 
                         
                         selectInput("one", label = "Select feature 1:", choices = NULL),
                         
                         selectInput("two", label = "Select feature 2:", choices = NULL),
                         
                         selectInput("my_factor", label = "Select a factor:", choices = NULL),
                         
                         prettySwitch("facet_factor", "Facet by Group", fill = TRUE, status = "primary"),
                         
                         prettySwitch("showL", "Show Labels", fill = TRUE, status = "primary"),
                         
                         prettySwitch("smooth", "Smooth Line (lm)", fill = TRUE, status = "primary"),
                         
                         conditionalPanel(condition = ("input.smooth"),
                                          selectInput("smooth_color", "Smooth line colour", choices = c("red", "blue", "green"))
                         ),
                         
                         actionButton("exclude_toggle", "Hide points", icon("ban"),
                                      style="color: #fff; background-color: #FF0000; border-color: #AF0000"),
                         
                         actionButton("exclude_reset", "Reset", icon("sync-alt"),
                                      style="color: #fff; background-color: #00b300; border-color: #009900")
                         
                         ),
                       plotOutput("cor_plot", click = "plot1_click", brush = brushOpts(id = "plot1_brush"), height = "500px")
                       ),
           
           bs4TabPanel(tabName = "Pairwise Correlation Table", DT::dataTableOutput("correlation_table")
           ),
             
           bs4TabPanel(tabName = "Correlogram", 
                      
                      dropdownButton(
                        circle = TRUE, status = "warning", icon = icon("gear"), margin = "25px", 
                        
                        numericInput("lab_correlogram", "Label Size", value = 5)
                        
                        ),
                      plotOutput("corr_plot", height = "500px")
                      ),
             
           bs4TabPanel(tabName = "Correlation Network", 
                      
                      dropdownButton(
                        circle = TRUE, status = "warning", icon = icon("gear"), margin = "25px", 
                        
                        sliderInput("cor_coeff", "Correlation Cutoff", min = 0, max = 1 , value = 0.7)
                        
                        ),
                      plotOutput("corr_net", height = "500px")
                      ),
           
           bs4TabPanel(tabName = "Gaussian Graphical Model", 
                       
                       dropdownButton(
                         circle = TRUE, status = "warning", icon = icon("gear"), margin = "25px", 
                         
                         sliderInput("rho", "Regularization Parameter", min = 0, max = 1 , value = 0.7)
                         
                       ),
                       plotOutput("ggm", height = "500px")
           )
           )
  )
)

