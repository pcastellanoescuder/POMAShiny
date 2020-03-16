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
           
           h4("Heatmap Parameters:"),
           
           radioButtons("scaleHeatmap", "Scale:", choices = c("By column" = "column",
                                                              "By row" = "row",
                                                              "No scale" = "none"),
                        selected = "column"),
           numericInput("fontsize_row", "Font size rows:", 6, step = 1),
           numericInput("fontsize_col", "Font size columns:", 6, step = 1)
           
         )),
  
  column(width = 9,
         
         plotlyOutput("HeatMaply", height = "800px")

         ))

