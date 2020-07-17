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
           
           prettySwitch("remove_outliers", "Remove outliers from data", fill = TRUE, status = "primary"),
           
           selectizeInput("outliers_method", "Method:", choices = c("euclidean", "maximum", "manhattan", "canberra", "minkowski")),
           
           selectizeInput("outliers_type", "Type:", choices = c("median", "centroid")),
           
           numericInput("outlier_coef", "Coefficient", value = 1.5),
           
           prettySwitch("labels_outliers", "Show labels", fill = TRUE, status = "primary")
           
           )
         ),
  
  column(width = 9,
         
         fluidPage(
           tabsetPanel(
             
             tabPanel("Distances Polygon Plot", plotlyOutput("polygon_plot")),
             tabPanel("Distances Boxplot", plotlyOutput("outliers_boxplot")),
             tabPanel("Outliers Table", dataTableOutput("outliers_table"))
             
             )
           )
         )
  )

