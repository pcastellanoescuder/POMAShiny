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
           inputId = "boxplot_card",
           title = "Boxplot parameters",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           selectizeInput("sel_boxplot", "Features to plot:", choices = NULL, multiple = TRUE),
           
           prettySwitch("jitter_bx", "Show points", fill = TRUE, status = "primary"),
           
           prettySwitch("split_bx", "Split boxes", fill = TRUE, status = "primary") %>% helper(type = "markdown",
                                                                                               title = "Boxplot helper",
                                                                                               content = "boxplot",
                                                                                               icon = "question",
                                                                                               colour = "green")
           
         )
         ),
  
  column(width = 9,
         
         plotlyOutput("boxPlotly", height = "500px")

         )
  )

