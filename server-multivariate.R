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

Multivariate_plot <- 
  eventReactive(input$plot_multivariate,
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    data <- NormData()$normalized

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
  Multivariate_plot()$scoresplot
})

##

output$screeplot <- renderPlotly({
  Multivariate_plot()$screeplot
  })

##

output$biplot <- renderPlotly({
  Multivariate_plot()$biplot
})

##

output$pca_scores <- DT::renderDataTable({
  
  pca_scores <- Multivariate_plot()$score_data
  
  DT::datatable(pca_scores, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_pca_scores"),
                                   list(extend="excel",
                                        filename="POMA_pca_scores"),
                                   list(extend="pdf",
                                        filename="POMA_pca_scores")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(pca_scores)))
})

##

output$pcaEigen <- DT::renderDataTable({
  
  DT::datatable(Multivariate_plot()$eigenvalues, 
                class = 'cell-border stripe',
                rownames = FALSE, options = list(scrollX = TRUE))

})

################# PLSDA

output$plsda_scores_plot <- renderPlotly({
  Multivariate_plot()$scoresplot
})

##

output$plsda_errors_plot <- renderPlotly({
  Multivariate_plot()$errors_plsda_plot
})

##

output$overall_table <- DT::renderDataTable({

  overall_table <- Multivariate_plot()$errors_plsda
  overall_table <- overall_table %>% 
    pivot_wider(names_from = variable, values_from = value) %>% 
    column_to_rownames("Component") %>%
    select_at(vars(starts_with("overall"))) 
  
  DT::datatable(overall_table,
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons =
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_plsda_overall"),
                                   list(extend="excel",
                                        filename="POMA_plsda_overall"),
                                   list(extend="pdf",
                                        filename="POMA_plsda_overall")),
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
  
  DT::datatable(ber_table,
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons =
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_plsda_ber"),
                                   list(extend="excel",
                                        filename="POMA_plsda_ber"),
                                   list(extend="pdf",
                                        filename="POMA_plsda_ber")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(ber_table)))

})

##

output$vip_table <- DT::renderDataTable({
  
  DT::datatable(Multivariate_plot()$plsda_vip_table, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_plsda_vip"),
                                   list(extend="excel",
                                        filename="POMA_plsda_vip"),
                                   list(extend="pdf",
                                        filename="POMA_plsda_vip")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$plsda_vip_table)))
})

##

output$vip_plsda_plot <- renderPlotly({
  Multivariate_plot()$vip_plsda_plot
})

##

output$plsda_scores <- DT::renderDataTable({

  DT::datatable(Multivariate_plot()$score_data, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_plsda_scores"),
                                   list(extend="excel",
                                        filename="POMA_plsda_scores"),
                                   list(extend="pdf",
                                        filename="POMA_plsda_scores")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$scores_plsda)))
})

################# sPLSDA

output$splsda_scores_plot <- renderPlotly({
  Multivariate_plot()$scoresplot
})

##

output$BalancedError <- renderPlotly({
  Multivariate_plot()$bal_error_rate
})

##

output$errors_splsda <- DT::renderDataTable({
  
  errors_splsda <- Multivariate_plot()$errors_splsda
  
  errors_splsda <- errors_splsda %>% 
    pivot_wider(names_from = variable, values_from = c(value, sd))
  
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
                                        filename="POMA_splsda_errors"),
                                   list(extend="excel",
                                        filename="POMA_splsda_errors"),
                                   list(extend="pdf",
                                        filename="POMA_splsda_errors")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(errors_splsda)))
})

##

output$splsda_scores <- DT::renderDataTable({
  
  DT::datatable(Multivariate_plot()$score_data, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_splsda_scores"),
                                   list(extend="excel",
                                        filename="POMA_splsda_scores"),
                                   list(extend="pdf",
                                        filename="POMA_splsda_scores")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$scores_splsda)))
})

##

output$splsda_selected_var <- DT::renderDataTable({
  
  DT::datatable(Multivariate_plot()$selected_variables, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_splsda_features"),
                                   list(extend="excel",
                                        filename="POMA_splsda_features"),
                                   list(extend="pdf",
                                        filename="POMA_splsda_features")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$selected_variables)))
})

