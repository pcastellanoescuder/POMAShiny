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
           
           selectInput("one", label = "Select feature 1:", choices = NULL),
           
           selectInput("two", label = "Select feature 2:", choices = NULL),
           
           selectInput("my_factor", label = "Select a factor:", choices = NULL),
           
           prettySwitch("facet_factor", "Facet by Group", fill = TRUE, status = "primary"),
           
           prettySwitch("showL", "Show Labels", fill = TRUE, status = "primary"),
           
           prettySwitch("smooth", "Smooth Line (lm)", fill = TRUE, status = "primary"),

           conditionalPanel(condition = ("input.smooth"),
                            selectInput("smooth_color", "Smooth line colour", choices = c("red", "blue", "green"))),
           
           radioButtons("corr_method", "Correlation Method:", c("Pearson" = "pearson",
                                                                "Spearman" = "spearman",
                                                                "Kendall" = "kendall")),
           
           actionButton("exclude_toggle", "Hide points", icon("ban"),
                        style="color: #fff; background-color: #FF0000; border-color: #AF0000"),
           
           actionButton("exclude_reset", "Reset", icon("sync-alt"),
                        style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                          title = "Correlation analysis helper",
                                                                                                          content = "correlations",
                                                                                                          icon = "question",
                                                                                                          colour = "green")
         )),
  
  column(width = 9,
         
         fluidPage(
           
           tabsetPanel(
             
             tabPanel("Pairwise Correlation Scatterplot", 
                      plotOutput("cor_plot", click = "plot1_click", brush = brushOpts(id = "plot1_brush"), height = "500px")
                      ),
             
             tabPanel("Correlogram", 
                      
                      dropdownButton(
                        circle = TRUE, status = "POMAClass", icon = icon("gear"), margin = "25px", 
                        numericInput("lab_correlogram", "Label Size", value = 5)
                        ),
                      plotlyOutput("corr_plot", height = 700)
                      ),
             
             tabPanel("Correlation Network", 
                      
                      dropdownButton(
                        circle = TRUE, status = "POMAClass", icon = icon("gear"), margin = "25px", 
                        sliderInput("cor_coeff", "Correlation Cutoff", min = 0, max = 1 , value = 0.7)
                        ),
                      plotOutput("corr_net", height = 700)
                      )
             
         )
         
  ))
)

