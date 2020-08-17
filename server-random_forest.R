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

observe_helpers(help_dir = "help_mds")

Random_Forest <- 
  eventReactive(input$plot_rf,
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    data <- Outliers()$data
                    
                    rf_res <- POMA::PomaRandForest(data,
                                                   ntest = input$rf_test,
                                                   ntree = input$rf_ntrees,
                                                   mtry = input$rf_mtry,
                                                   nodesize = input$rf_nodesize,
                                                   nvar = input$rf_numvar)
                    return(rf_res)

                  })
                })

####

output$gini_table <- DT::renderDataTable({

  importance_pred <- Random_Forest()$importance_pred %>%
    mutate(MeanDecreaseGini = round(MeanDecreaseGini, 3))
    
  DT::datatable(importance_pred, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_gini")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_gini")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_gini"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Random_Forest()$importance_pred)))
})

##

output$oob_error <- renderPlotly({
  Random_Forest()$error_tree + xlab("Number of trees")
})

##

output$Gini <- renderPlotly({
  Random_Forest()$gini_plot
})

##

output$oob_error_table <- DT::renderDataTable({
  
  DT::datatable(round(Random_Forest()$forest_data, 3), 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_oob_error")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_oob_error")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_oob_error"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Random_Forest()$forest_data)))
})

##

output$confusion <- DT::renderDataTable({
  
  confusion_matrix <- Random_Forest()$confusion_matrix %>% 
    mutate(class.error = round(class.error, 3)) %>%
    dplyr::rename(class_error = class.error)
  
  DT::datatable(confusion_matrix, class = 'cell-border stripe', rownames = TRUE)
})

