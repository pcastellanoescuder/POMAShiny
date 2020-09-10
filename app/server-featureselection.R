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

Selection_plot <- 
  eventReactive(input$feat_selection_action,
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    data <- Outliers()$data
                    
                    validate(need(length(levels(as.factor(Biobase::pData(data)[,1]))) == 2, "Only two groups allowed."))
                    
                    if(input$lasso_test == 0){
                      lasso_test <- NULL
                    } else{
                      lasso_test <- input$lasso_test
                    }
                      
                    if (input$feat_selection == "lasso"){
                      
                      results_lasso <- POMA::PomaLasso(data, alpha = 1, nfolds = input$nfolds_lasso, ntest = lasso_test)
                      
                      return(results_lasso)
                    }
                    
                    else if (input$feat_selection == "ridge"){
                      
                      results_ridge <- POMA::PomaLasso(data, alpha = 0, nfolds = input$nfolds_lasso, ntest = lasso_test)

                      return(results_ridge)
 
                    }
                    
                    else if (input$feat_selection == "elasticnet"){
                      
                      results_elasticnet <- POMA::PomaLasso(data, alpha = input$alpha_sel, nfolds = input$nfolds_lasso, ntest = lasso_test)
                      
                      return(results_elasticnet)
                      
                    }

                  })
                })


#### LASSO

output$lasso_plot <- renderPlotly({
  ggplotly(Selection_plot()$coefficientPlot) %>% plotly::config(
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

output$cvglmnet_lasso <- renderPlotly({
  ggplotly(Selection_plot()$cvLassoPlot) %>% plotly::config(
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

output$selected_lasso <- DT::renderDataTable({
  
  sel_table <- Selection_plot()$coefficients

  DT::datatable(sel_table, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_lasso")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_lasso")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_lasso"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(sel_table)))
})

##

output$cm_lasso <- DT::renderDataTable({
  
  validate(need(input$lasso_test != 0, "Only when test partition is bigger than zero."))
  
  overall <- Selection_plot()$confusionMatrix$overall %>% as.data.frame() %>% rownames_to_column("metric") %>% dplyr::rename(value = 2)
  by_class <- Selection_plot()$confusionMatrix$byClass %>% as.data.frame() %>% rownames_to_column("metric") %>% dplyr::rename(value = 2)
  metrics <- rbind(overall, by_class) %>% mutate(value = round(value, 4))
  
  DT::datatable(metrics, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_lasso_prediction_metrics")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_lasso_prediction_metrics")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_lasso_prediction_metrics"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(metrics)))
})


#### RIDGE

output$ridge_plot <- renderPlotly({
  ggplotly(Selection_plot()$coefficientPlot) %>% plotly::config(
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

output$cvglmnet_ridge <- renderPlotly({
  ggplotly(Selection_plot()$cvLassoPlot) %>% plotly::config(
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

output$selected_ridge <- DT::renderDataTable({
  
  sel_table2 <- Selection_plot()$coefficients
  
  DT::datatable(sel_table2, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_ridge")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_ridge")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_ridge"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(sel_table2)))
  
})

##

output$cm_ridge <- DT::renderDataTable({
  
  validate(need(input$lasso_test != 0, "Only when test partition is bigger than zero."))
  
  overall <- Selection_plot()$confusionMatrix$overall %>% as.data.frame() %>% rownames_to_column("metric") %>% dplyr::rename(value = 2)
  by_class <- Selection_plot()$confusionMatrix$byClass %>% as.data.frame() %>% rownames_to_column("metric") %>% dplyr::rename(value = 2)
  metrics <- rbind(overall, by_class) %>% mutate(value = round(value, 4))
  
  DT::datatable(metrics, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_ridge_prediction_metrics")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_ridge_prediction_metrics")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_ridge_prediction_metrics"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(metrics)))
})

#### ELSATICNET

output$elasticnet_plot <- renderPlotly({
  ggplotly(Selection_plot()$coefficientPlot) %>% plotly::config(
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

output$cvglmnet_elasticnet <- renderPlotly({
  ggplotly(Selection_plot()$cvLassoPlot) %>% plotly::config(
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

output$selected_elasticnet <- DT::renderDataTable({
  
  sel_table2 <- Selection_plot()$coefficients
  
  DT::datatable(sel_table2, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_elasticnet")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_elasticnet")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_elasticnet"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(sel_table2)))
  })

##

output$cm_elasticnet <- DT::renderDataTable({
  
  validate(need(input$lasso_test != 0, "Only when test partition is bigger than zero."))
  
  overall <- Selection_plot()$confusionMatrix$overall %>% as.data.frame() %>% rownames_to_column("metric") %>% dplyr::rename(value = 2)
  by_class <- Selection_plot()$confusionMatrix$byClass %>% as.data.frame() %>% rownames_to_column("metric") %>% dplyr::rename(value = 2)
  metrics <- rbind(overall, by_class) %>% mutate(value = round(value, 4))
  
  DT::datatable(metrics, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_elasticnet_prediction_metrics")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_elasticnet_prediction_metrics")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_elasticnet_prediction_metrics"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(metrics)))
})

