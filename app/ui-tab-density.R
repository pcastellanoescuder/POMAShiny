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
           inputId = "density_card",
           title = "Density plot parameters",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           prettySwitch("group_dens", "Plot groups", fill = TRUE, status = "primary", value = TRUE),
           
           conditionalPanel("!input.group_dens",
                            selectizeInput("sel_density", "Features to plot:", choices = NULL, multiple = TRUE)
                            ),
           br() %>% helper(type = "markdown",
                          title = "Density plot helper",
                          content = "density",
                          icon = "question",
                          colour = "green")
           
         )
         ),
  
  column(width = 9,
         
         plotlyOutput("densplot", height = "500px")

         )
  )

