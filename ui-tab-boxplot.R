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
           
           h4("Boxplot Parameters:"),
           
           selectizeInput("sel_boxplot", "Selected features:", choices = NULL, multiple = TRUE),
           # numericInput("pval_cutoff",strong("P.Value threshold"),0.05, step = 0.01),
           # numericInput("log2FC",strong("log2 Fold change threshold"),1.5, step = 0.1),
           checkboxInput("jitter", "Jitter points:")
           # numericInput("xlim", "x-axis range", value = 2)
           
         )),
  
  column(width = 9,
         
         plotlyOutput("boxPlotly")

         ))

