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

observe_helpers(help_dir = "help_mds")

Clusters <- reactive({
  
  to_clust <- Outliers()$data
  to_clust <- POMA::PomaClust(to_clust, 
                              method = input$mds_method, 
                              k = input$n_clusters, 
                              k_max = input$k_max,
                              show_clusters = input$show_clust, 
                              labels = input$labels_clust, 
                              show_group = input$show_group)
  
  return(to_clust)
  
})

##

output$cluster_plot <- renderPlotly({

  to_clust <- Clusters()$mds_plot
  
  ggplotly(to_clust + theme(legend.title = element_blank())) %>% plotly::config(
    toImageButtonOptions = list(format = "png"),
    displaylogo = FALSE,
    collaborate = FALSE,
    modeBarButtonsToRemove = c(
      "sendDataToCloud", "zoom2d", "select2d",
      "lasso2d", "autoScale2d", "hoverClosestCartesian", "hoverCompareCartesian"
    )
  )
  
})

##

output$optimum_plot <- renderPlotly({

  optimum_plot <- Clusters()$optimum_cluster_plot
  
  ggplotly(optimum_plot + theme(legend.title = element_blank())) %>% plotly::config(
    toImageButtonOptions = list(format = "png"),
    displaylogo = FALSE,
    collaborate = FALSE,
    modeBarButtonsToRemove = c(
      "sendDataToCloud", "zoom2d", "select2d",
      "lasso2d", "autoScale2d", "hoverClosestCartesian", "hoverCompareCartesian"
    )
  )
  
})

##

output$cluster_table <- renderDataTable({
  
  to_clust <- Clusters()$mds_values
  
  to_clust <- to_clust %>%
    mutate(Dim1 = round(Dim1, 3),
           Dim2 = round(Dim2, 3)) %>%
    dplyr::rename(cluster = clust)
  
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

