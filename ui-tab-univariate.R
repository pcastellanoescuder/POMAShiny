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
           
           radioButtons("univariate_test",  h4("Univariate methods:"),
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
                          fluidPage(DT::dataTableOutput("matriu_ttest"))
         ),
         conditionalPanel(condition = ("input.univariate_test == 'anova'"),
                          fluidPage(tabsetPanel(
                            tabPanel("ANOVA Results", DT::dataTableOutput("matriu_anova")),
                            tabPanel("ANCOVA Results", DT::dataTableOutput("matriu_ancova")) 
                          ))
         ),
         conditionalPanel(condition = ("input.univariate_test == 'mann'"),
                          fluidPage(DT::dataTableOutput("matriu_mann")
                          )
         ),
         conditionalPanel(condition = ("input.univariate_test == 'kruskal'"),
                          fluidPage( DT::dataTableOutput("matriu_kruskal"))
         )
  )
)

