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
           inputId = "outliers_card",
           title = "Outlier detection",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           prettySwitch("remove_outliers", "Remove outliers", fill = TRUE, status = "primary", value = TRUE),
           
           selectizeInput("outliers_method", "Method:", choices = c("euclidean", "maximum", "manhattan", "canberra", "minkowski")),
           
           selectizeInput("outliers_type", "Type:", choices = c("median", "centroid")),
           
           numericInput("outlier_coef", "Coefficient", value = 3),
           
           prettySwitch("labels_outliers", "Show labels", fill = TRUE, status = "primary") %>% helper(type = "markdown",
                                                                                                      title = "Outlier detection helper",
                                                                                                      content = "outliers",
                                                                                                      icon = "question",
                                                                                                      colour = "green")
           )
         ),
  
  column(width = 9,
         
         box(
           side = "right",
           width = 12,
           id = "out_tab_card",
           title = "Outliers",
           status = "success",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           tabBox(tabName = "Distances Polygon Plot", plotOutput("polygon_plot")),
           tabBox(tabName = "Distances Boxplot", plotOutput("outliers_boxplot")),
           tabBox(tabName = "Outliers Table", dataTableOutput("outliers_table"))
           
           )
         )
)

