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
                    
                    rf_data <- NormData()
                    rf_data <- rf_data[,2:ncol(rf_data)]

                    names <- data.frame(real_names = colnames(rf_data), new_names = NA)
                    
                    for (i in 1:nrow(names)){
                      names$new_names[i] <- paste0("X", i)
                    }
                    
                    colnames(rf_data) <- names$new_names
                    colnames(rf_data)[1] <- "Group"
                    
                    #training Sample with 1/3 observations
                    train <- sample(1:nrow(rf_data), round(dim(rf_data)[1]/3))
                    
                    RF_model <- randomForest(as.factor(Group) ~ . ,
                                             data = rf_data, 
                                             subset = train,
                                             ntree = input$rf_ntrees,
                                             mtry = input$rf_mtry, 
                                             nodesize = input$rf_nodesize)
                    
                    ntrees <- c(1:RF_model$ntree)
                    error <- RF_model$err.rate
                    
                    forest_data <- round(data.frame(ntrees,error),4)
                    
                    error_tree <- ggplotly(ggplot(forest_data, aes(ntrees, OOB)) + 
                                           geom_line() + 
                                           labs(y = "Out-Of-Bag Error Rate") +
                                           theme_minimal())
                    
                    ########

                    importancia_pred <- as.data.frame(importance(RF_model, scale = TRUE))
                    importancia_pred <- rownames_to_column(importancia_pred, var = "new_names")
                    importancia_pred <- merge(importancia_pred, names , by = "new_names")
                    importancia_pred1 <- importancia_pred[order(importancia_pred$MeanDecreaseGini, 
                                                               decreasing = TRUE),]
                    importancia_pred <- importancia_pred1[1:input$rf_numvar,]
                    
                    
                    Gini_plot <-ggplotly(ggplot(data = importancia_pred, 
                                    aes(x = reorder(real_names, MeanDecreaseGini),
                                                                 y = MeanDecreaseGini,
                                                                 fill = MeanDecreaseGini)) +
                               labs(x = "variable") +
                               geom_col() +
                               coord_flip() +
                               theme_minimal() +
                               theme(legend.position = "bottom"))
                    
                    importancia_pred1 <- importancia_pred1[,c(3,2)]
                    importancia_pred1$MeanDecreaseGini <- round(importancia_pred1$MeanDecreaseGini,4)
                    colnames(importancia_pred1)[1] <- "Variable"  
                    
                    conf_mat <- round(as.data.frame(RF_model$confusion),4)
                      
                    return(list(importancia_pred1 = importancia_pred1, 
                                error_tree = error_tree,
                                Gini_plot = Gini_plot,
                                forest_data = forest_data,
                                conf_mat = conf_mat))

                  })
                })


################# 

output$gini_table <- DT::renderDataTable({

  DT::datatable(Random_Forest()$importancia_pred1, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="gini_table_rf"),
                                   list(extend="excel",
                                        filename="gini_table_rf"),
                                   list(extend="pdf",
                                        filename="gini_table_rf")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Random_Forest()$importancia_pred1)))
})

output$oob_error <- renderPlotly({
  Random_Forest()$error_tree
})

output$Gini <- renderPlotly({
  Random_Forest()$Gini_plot
})

output$oob_error_table <- DT::renderDataTable({
  
  DT::datatable(Random_Forest()$forest_data, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="oob_error_rf"),
                                   list(extend="excel",
                                        filename="oob_error_rf"),
                                   list(extend="pdf",
                                        filename="oob_error_rf")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Random_Forest()$forest_data)))
})

output$confusion <- DT::renderDataTable({
  DT::datatable(Random_Forest()$conf_mat, class = 'cell-border stripe', rownames = TRUE)
})

