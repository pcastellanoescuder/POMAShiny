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
         
         box(
           width = 12,
           inputId = "heatmap_card",
           title = "Heatmap parameters",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           prettySwitch("sample_names", "Show sample names", fill = TRUE, status = "primary", value = TRUE),
           prettySwitch("feature_names", "Show feature names", fill = TRUE, status = "primary"),
           
           br() %>% helper(type = "markdown",
                           title = "Heatmap helper",
                           content = "heatmap",
                           icon = "question",
                           colour = "green")
           
         )
         ),
  
  column(width = 9,
         
         plotOutput("heatmap", height = "500px")

         )
  )

