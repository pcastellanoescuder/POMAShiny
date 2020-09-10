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

Multivariate_plot <- 
  eventReactive(input$plot_multivariate,
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    data <- Outliers()$data

                    if (input$mult_plot == "pca"){
                      
                      pca_res <- POMA::PomaMultivariate(data, 
                                                        method = "pca", 
                                                        components = input$num_comp1, 
                                                        scale = input$scale_pca, 
                                                        center = input$center_pca,
                                                        ellipse = input$ellipse1)
                      
                      return(pca_res)
                    }
                    
                    else if (input$mult_plot == "plsda"){
                      
                      plsda_res <- POMA::PomaMultivariate(data, 
                                                          method = "plsda", 
                                                          components = input$num_comp2, 
                                                          ellipse = input$ellipse2,
                                                          validation = input$validation_plsda,
                                                          folds = input$plsda_folds,
                                                          nrepeat = input$validation_plsda_rep)
                                             
                      return(plsda_res)
                    }
                    
                    else if (input$mult_plot == "splsda"){
                      
                      splsda_res <- POMA::PomaMultivariate(data, 
                                                           method = "splsda", 
                                                           components = input$num_comp3, 
                                                           ellipse = input$ellipse3,
                                                           validation = input$validation_splsda,
                                                           folds = input$splsda_folds,
                                                           nrepeat = input$validation_splsda_rep,
                                                           num_features = input$num_feat)
          
                      return(splsda_res)
                    }

                  })
                })


################# PCA

output$pca_scores_plot <- renderPlotly({
  ggplotly(Multivariate_plot()$scoresplot + theme(legend.title = element_blank()))  %>% plotly::config(
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

output$screeplot <- renderPlotly({
  ggplotly(Multivariate_plot()$screeplot) %>% plotly::config(
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

output$biplot <- renderPlotly({
  ggplotly(Multivariate_plot()$biplot + theme(legend.title = element_blank())) %>% plotly::config(
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

output$pca_scores <- DT::renderDataTable({
  
  pca_scores <- Multivariate_plot()$score_data
  
  DT::datatable(round(pca_scores, 3), 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_pca_scores")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_pca_scores")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_pca_scores"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(pca_scores)))
})

##

output$pcaEigen <- DT::renderDataTable({
  
  eigenvalues <- Multivariate_plot()$eigenvalues %>%
    mutate(Percent_Variance_Explained = round(Percent_Variance_Explained , 3))
  
  DT::datatable(eigenvalues, 
                class = 'cell-border stripe',
                rownames = FALSE, options = list(scrollX = TRUE))

})

################# PLSDA

output$plsda_scores_plot <- renderPlotly({
  ggplotly(Multivariate_plot()$scoresplot + theme(legend.title = element_blank())) %>% plotly::config(
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

output$plsda_errors_plot <- renderPlotly({
  ggplotly(Multivariate_plot()$errors_plsda_plot + theme(legend.title = element_blank())) %>% plotly::config(
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

output$overall_table <- DT::renderDataTable({

  overall_table <- Multivariate_plot()$errors_plsda
  overall_table <- overall_table %>% 
    pivot_wider(names_from = variable, values_from = value) %>% 
    column_to_rownames("Component") %>%
    select_at(vars(starts_with("overall"))) 
  
  DT::datatable(round(overall_table, 3),
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons =
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_plsda_overall_error")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_plsda_overall_error")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_plsda_overall_error"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(overall_table)))
})

##

output$ber_table <- DT::renderDataTable({

  ber_table <- Multivariate_plot()$errors_plsda
  ber_table <- ber_table %>% 
    pivot_wider(names_from = variable, values_from = value) %>% 
    column_to_rownames("Component") %>%
    select_at(vars(starts_with("BER"))) 
  
  DT::datatable(round(ber_table, 3),
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons =
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_plsda_ber_error")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_plsda_ber_error")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_plsda_ber_error"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(ber_table)))

})

##

output$vip_table <- DT::renderDataTable({
  
  plsda_vip_table <- Multivariate_plot()$plsda_vip_table %>%
    mutate_at(vars(-matches("feature")), ~ round(., 3))
  
  DT::datatable(plsda_vip_table, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_plsda_vip")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_plsda_vip")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_plsda_vip"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$plsda_vip_table)))
})

##

output$vip_plsda_plot <- renderPlotly({
  
  
  plsda_vip_top <- Multivariate_plot()$plsda_vip_table %>% 
    filter(comp1 >= input$vip) %>% 
    mutate(feature = factor(feature, levels = feature[order(comp1)]))
  
  vip_plsda_plot <- ggplot(plsda_vip_top, aes(x = feature, y = comp1, fill = NULL)) + 
    geom_bar(stat = "identity", fill = rep(c("lightblue"), nrow(plsda_vip_top))) + 
    coord_flip() + 
    ylab("VIP") + 
    xlab("") + 
    theme_bw()
  
  ggplotly(vip_plsda_plot) %>% plotly::config(
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

output$plsda_scores <- DT::renderDataTable({

  DT::datatable(round(Multivariate_plot()$score_data, 3), 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_plsda_scores")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_plsda_scores")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_plsda_scores"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$scores_plsda)))
})

################# sPLSDA

output$splsda_scores_plot <- renderPlotly({
  ggplotly(Multivariate_plot()$scoresplot + theme(legend.title = element_blank())) %>% plotly::config(
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

output$BalancedError <- renderPlotly({
  ggplotly(Multivariate_plot()$bal_error_rate + theme(legend.title = element_blank())) %>% plotly::config(
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

output$errors_splsda <- DT::renderDataTable({
  
  errors_splsda <- Multivariate_plot()$errors_splsda
  
  errors_splsda <- errors_splsda %>% 
    pivot_wider(names_from = variable, values_from = c(value, sd)) %>%
    mutate_at(vars(-matches("features")), ~ round(., 3))
  
  DT::datatable(errors_splsda, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_splsda_errors")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_splsda_errors")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_splsda_errors"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(errors_splsda)))
})

##

output$splsda_scores <- DT::renderDataTable({
  
  DT::datatable(round(Multivariate_plot()$score_data, 3), 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_splsda_scores")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_splsda_scores")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_splsda_scores"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$scores_splsda)))
})

##

output$splsda_selected_var <- DT::renderDataTable({
  
  selected_variables <- Multivariate_plot()$selected_variables %>%
    mutate(Value = round(Value, 3))
    
  DT::datatable(selected_variables, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_splsda_features")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_splsda_features")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_splsda_features"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$selected_variables)))
})

