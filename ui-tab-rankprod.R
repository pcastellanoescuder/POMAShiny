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
           
           h4("Parameters:"),
           
           radioButtons("paired3",  "Paired samples:",
                        choices = c("TRUE" = '1', 
                                    "FALSE" = 'NA'),
                        selected = 'NA'),
           
           radioButtons("method", "Method:",
                        choices = c("Percentage of False Prediction" = 'pfp',
                                    "P-value" = 'pval'),
                        selected = 'pfp'),
           
           sliderInput("cutoff","Cutoff value:",
                       min=0.001, max=0.2,value=0.05,
                       step = 0.01),

           
           actionButton("rank_prod","Analyze", icon("step-forward"),
                        style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                          title = "Rank products helper",
                                                                                                          content = "rank_products",
                                                                                                          icon = "question",
                                                                                                          colour = "green")
         )),
  
  column(width = 9,
         
                          fluidPage(tabsetPanel(
                            tabPanel("Up-regulated metabolites", div(style = 'overflow-x: scroll', 
                                                        dataTableOutput("upregulated"), 
                                                        width = NULL,
                                                        status = "primary")),
                            tabPanel("Down-regulated metabolites", div(style = 'overflow-x: scroll', 
                                                        dataTableOutput("downregulated"), 
                                                        width = NULL,
                                                        status = "primary")),
                            tabPanel("Estimated PFP Plot", plotlyOutput("rank_prod_plot")))
                            ))
         
         
         
  )

