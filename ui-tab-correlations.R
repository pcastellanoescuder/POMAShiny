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
  
                  h4("Correlation between:"),
                  
                  selectInput("one",label="Metabolite 1", choices = NULL),
                  
                  h4("and"),
                  
                  selectInput("two",label="Metabolite 2", choices = NULL), 
                  
                  radioButtons("corr_method", "Correlation Method:", c("Pearson" = "pearson",
                                                                       "Spearman" = "spearman",
                                                                       "Kendall" = "kendall")) %>% helper(type = "markdown",
                                                                                                          title = "Correlation analysis helper",
                                                                                                          content = "correlations",
                                                                                                          icon = "question",
                                                                                                          colour = "green")
  )),
  
  column(width = 9,
         
         fluidPage(
           tabsetPanel(
             tabPanel("Pairwise Correlation Scatterplot", 
                      plotlyOutput("cor_plot"),
                      br(),
                      textOutput("text")),
             tabPanel("Global Correlation Plot", plotlyOutput("corr_plot", height = 700))
           ))

  ))

