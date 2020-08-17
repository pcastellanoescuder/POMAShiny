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

output$cluster_plot <- renderPlotly({
  
  to_clust <- Outliers()$data
  to_clust <- POMA::PomaClust(to_clust, 
                              method = input$mds_method, 
                              k = input$n_clusters, 
                              show_clusters = input$show_clust, 
                              labels = input$labels_clust, 
                              show_group = input$show_group)$mds_plot
  
  ggplotly(to_clust)
  
})

##

output$cluster_table <- renderDataTable({
  
  to_clust <- Outliers()$data
  to_clust <- POMA::PomaClust(to_clust, 
                              method = input$mds_method, 
                              k = input$n_clusters, 
                              show_clusters = input$show_clust, 
                              labels = input$labels_clust, 
                              show_group = input$show_group)$mds_values
  
  to_clust <- to_clust %>%
    mutate(Dim1 = round(Dim1, 3),
           Dim2 = round(Dim2, 3)) %>%
    rename(cluster = clust)
  
  DT::datatable(to_clust, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_cluster")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_cluster")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_cluster"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(to_clust)))
  
})

