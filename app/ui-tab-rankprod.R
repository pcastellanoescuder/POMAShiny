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
           inputId = "rankprod_card",
           title = "Rank product parameters",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           prettySwitch("paired_RP", "Paired Samples", fill = TRUE, status = "primary"),
           
           prettySwitch("logged_RP", "Logged", fill = TRUE, status = "primary", value = TRUE),
           
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
         
         bs4TabCard(
           side = "right",
           width = 12,
           id = "rankprod_tab_card",
           title = "Rank Products",
           status = "success",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           bs4TabPanel(tabName = "Up-regulated features", DT::dataTableOutput("upregulated")),
           bs4TabPanel(tabName = "Down-regulated features", DT::dataTableOutput("downregulated")),
           bs4TabPanel(tabName = "Up-regulated Estimated PFP Plot", plotlyOutput("rank_prod_plot_up")),
           bs4TabPanel(tabName = "Down-regulated Estimated PFP Plot", plotlyOutput("rank_prod_plot_down"))
           )
  )
)

