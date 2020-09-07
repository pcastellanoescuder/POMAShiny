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
           inputId = "univariate_card",
           title = "Univariate analysis",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           radioButtons("univariate_test",  "Univariate methods:",
                        choices = c("T-test" = 'ttest',
                                    "ANOVA/ANCOVA" = 'anova',
                                    "Mann-Whitney U Test" = 'mann',
                                    "Kruskal Wallis Test" = 'kruskal'),
                        selected = 'ttest'
                        ),
           
           conditionalPanel(condition = ("input.univariate_test == 'ttest'"),
                            
                            prettySwitch("var_ttest", "Equal variances", fill = TRUE, status = "primary"),
                            
                            prettySwitch("paired_ttest", "Paired samples", fill = TRUE, status = "primary")

                            ),
           
           conditionalPanel(condition = ("input.univariate_test == 'mann'"),
                            
                            prettySwitch("paired_mann", "Paired samples", fill = TRUE, status = "primary")

                            ),
           
           actionButton("play_test","Analyze", icon("step-forward"),
                        style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                          title = "Univariate analysis helper",
                                                                                                          content = "univariate",
                                                                                                          icon = "question",
                                                                                                          colour = "green")
           )
         ),
  
  column(width = 9,
         
         conditionalPanel(condition = ("input.univariate_test == 'ttest'"),
                          DT::dataTableOutput("matriu_ttest")
         ),
         conditionalPanel(condition = ("input.univariate_test == 'anova'"),
                          
                          bs4TabCard(
                            side = "right",
                            width = 12,
                            id = "anova_card",
                            title = "ANOVA/ANCOVA",
                            status = "success",
                            solidHeader = FALSE,
                            collapsible = FALSE,
                            collapsed = FALSE,
                            closable = FALSE,
                            
                            bs4TabPanel(tabName = "ANOVA Results", DT::dataTableOutput("matriu_anova")),
                            bs4TabPanel(tabName = "ANCOVA Results", DT::dataTableOutput("matriu_ancova")))
                            
         ),
         conditionalPanel(condition = ("input.univariate_test == 'mann'"),
                          DT::dataTableOutput("matriu_mann")
                          
         ),
         conditionalPanel(condition = ("input.univariate_test == 'kruskal'"),
                          DT::dataTableOutput("matriu_kruskal")
         )
         )
  )

