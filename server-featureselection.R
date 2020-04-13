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

Selection_plot <- 
  eventReactive(input$feat_selection_action,
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    data <- NormData()$normalized
                    
                    if (input$feat_selection == "lasso"){
                      
                      results_lasso <- POMA::PomaLasso(data, method = "lasso", nfolds = input$nfolds_lasso)
                      
                      return(results_lasso)
                    }
                    
                    else if (input$feat_selection == "ridge"){
                      
                      results_ridge <- POMA::PomaLasso(data, method = "ridge", nfolds = input$nfolds_lasso)

                      return(results_ridge)
 
                    }

                  })
                })


################# LASSO

output$lasso_plot <- renderPlotly({
  Selection_plot()$coefficientPlot
})

##

output$cvglmnet_lasso <- renderPlotly({
  Selection_plot()$cvLassoPlot
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
                                        filename="POMA_lasso"),
                                   list(extend="excel",
                                        filename="POMA_lasso"),
                                   list(extend="pdf",
                                        filename="POMA_lasso")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(sel_table)))
})

################# RIDGE

output$ridge_plot <- renderPlotly({
  Selection_plot()$coefficientPlot
})

##

output$cvglmnet_ridge <- renderPlotly({
  Selection_plot()$cvLassoPlot
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
                                        filename="POMA_ridge"),
                                   list(extend="excel",
                                        filename="POMA_ridge"),
                                   list(extend="pdf",
                                        filename="POMA_ridge")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(sel_table2)))
  
})

