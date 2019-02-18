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
           selectInput("coef_limma", h4("Select your contrast:"),
                       choices = NULL),
           
           actionButton("play_limma","Analyze", icon("step-forward"),
                        style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                          title = "Limma analysis helper",
                                                                                                          content = "limma",
                                                                                                          icon = "question",
                                                                                                          colour = "green")
           )),
  
  column(width = 8,
         fluidPage(tabsetPanel(
                   tabPanel("Results without using co-variates", div(style = 'overflow-x: scroll', DT::dataTableOutput("matriu"), width = NULL,
                                                                     status = "primary")),
                   tabPanel("Results using co-variates", div(style = 'overflow-x: scroll', DT::dataTableOutput("matriu_cov"), width = NULL,
                                                             status = "primary"))
                   ))
         ))

