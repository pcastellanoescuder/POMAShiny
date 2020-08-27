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
           inputId = "cluster_card",
           title = "Cluster analysis",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           
           selectizeInput("mds_method", "Method:", choices = c("euclidean", "maximum", "manhattan", "canberra", "minkowski")),
           
           numericInput("n_clusters", "Number of clusters", value = 3),
       
           prettySwitch("show_clust", "Show clusters", fill = TRUE, status = "primary", value = TRUE),
           
           prettySwitch("labels_clust", "Show labels", fill = TRUE, status = "primary") %>% helper(type = "markdown",
                                                                                                   title = "Cluster analysis helper",
                                                                                                   content = "cluster",
                                                                                                   icon = "question",
                                                                                                   colour = "green"),
           
           conditionalPanel("input.labels_clust",
                            
                            prettySwitch("show_group", "Show group", fill = TRUE, status = "primary")
                            
                            )
           )
         ),
  
  column(width = 9,
         
         bs4TabCard(
           side = "right",
           width = 12,
           id = "clus_tab_card",
           title = "Clusters",
           status = "success",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
             
           bs4TabPanel(tabName = "MDS Plot", plotlyOutput("cluster_plot")),
           bs4TabPanel(tabName = "Cluster Table", dataTableOutput("cluster_table"))
           
           )
         )
  )

