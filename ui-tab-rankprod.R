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
           
           prettySwitch("paired_RP", "Paired Samples", fill = TRUE, status = "primary"),
           
           radioButtons("method_RP", "Method:",
                        choices = c("Percentage of False Prediction" = 'pfp',
                                    "P-value" = 'pval'),
                        selected = 'pfp'),
           
           numericInput("cutoff_RP", "Cutoff value:", value = 0.05),

           actionButton("rank_prod","Analyze", icon("step-forward"),
                        style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                          title = "Rank products helper",
                                                                                                          content = "rank_products",
                                                                                                          icon = "question",
                                                                                                          colour = "green")
           )
         ),
  
  column(width = 9,
         
         fluidPage(
           
           tabsetPanel(
             tabPanel("Up-regulated features", DT::dataTableOutput("upregulated")),
             tabPanel("Down-regulated features", DT::dataTableOutput("downregulated")),
             tabPanel("Estimated PFP Plot", plotOutput("rank_prod_plot"))
             )
           )
         )
  )

