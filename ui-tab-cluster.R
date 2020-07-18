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
           
           selectizeInput("mds_method", "Method:", choices = c("euclidean", "maximum", "manhattan", "canberra", "minkowski")),
           
           numericInput("n_clusters", "Number of clusters", value = 3),
       
           prettySwitch("show_clust", "Show clusters", fill = TRUE, status = "primary"),
           
           prettySwitch("labels_clust", "Show labels", fill = TRUE, status = "primary"),
           
           conditionalPanel("input.labels_clust",
                            
                            prettySwitch("show_group", "Show group", fill = TRUE, status = "primary")
                            
                            )
           
           )
         ),
  
  column(width = 9,
         
         fluidPage(
           
           tabsetPanel(
             
             tabPanel("MDS Plot", plotlyOutput("cluster_plot")),
             tabPanel("Cluster Table", dataTableOutput("cluster_table"))
             
             )
           )
         )
  )

