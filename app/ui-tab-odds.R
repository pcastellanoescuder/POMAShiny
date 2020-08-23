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
           inputId = "odds_card",
           title = "Odds Ratio parameters",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           selectizeInput("feat_odds", "Select model features:", choices = NULL, multiple = TRUE),
           
           prettySwitch("CIodds", "Show CI", fill = TRUE, status = "primary"),
           
           prettySwitch("covariatesOdds", "Include covariates", fill = TRUE, status = "primary"),

           actionButton("play_odds","Analyze", icon("step-forward"),
                        style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                          title = "Odds Ratio helper",
                                                                                                          content = "odds",
                                                                                                          icon = "question",
                                                                                                          colour = "green")
           )
         ),
  
  column(width = 9,
         
         bs4TabCard(
           side = "right",
           width = 12,
           id = "odds_tab_card",
           title = "Odds Raio",
           status = "success",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           bs4TabPanel(tabName = "Odds Ratio Table", DT::dataTableOutput("odds_table")),
           bs4TabPanel(tabName = "Odds Ratio Plot", plotlyOutput("oddsPlot"))
           )
         )
  )
  
