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
                    
                    df <- NormData()
                    Y <- as.factor(df$Group)
                    X <- as.matrix(df[, 3:ncol(df)])
                    
                    if (input$feat_selection == "lasso"){
                      
                      cv_fit <- cv.glmnet(X, Y, family = "binomial", nfolds = input$nfolds_lasso)
                      
                      #### lambda
                      
                      tidied_cv <- broom::tidy(cv_fit)
                      glance_cv <- broom::glance(cv_fit)
                      
                      cvlasso <- ggplot(tidied_cv, aes(lambda, estimate)) +
                        geom_line(color = "blue") +
                        geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = 0.2) +
                        scale_x_log10() +
                        xlab("log10(Lambda)") +
                        ylab("Estimate") +
                        geom_vline(xintercept = glance_cv$lambda.min) +
                        geom_vline(xintercept = glance_cv$lambda.1se, lty = 2) +
                        theme_bw()
                      
                      tmp_coeffs <- coef(cv_fit, s = "lambda.min")
                      final_coef <- data.frame(name = tmp_coeffs@Dimnames[[1]][tmp_coeffs@i + 1], coefficient = tmp_coeffs@x)
                      
                      ####
                      
                      tidied_cv2 <- broom::tidy(cv_fit$glmnet.fit)
                      
                      coefficientplot <- ggplot(tidied_cv2, aes(lambda, estimate, color = term)) +
                        scale_x_log10() +
                        xlab("log10(Lambda)") +
                        ylab("Coefficients") +
                        geom_line() +
                        geom_vline(xintercept = glance_cv$lambda.min) +
                        geom_vline(xintercept = glance_cv$lambda.1se, lty = 2) +
                        theme_bw() +
                        theme(legend.position = "none")
                      
                      ####
                      
                      results_sel <- list(lassoPlot = coefficientplot, cvlasso = cvlasso, final_coef = final_coef)
                      return(results_sel)
                    }
                    
                    else if (input$feat_selection == "ridge"){
                      
                      cv_fit <- cv.glmnet(X, Y, family = "binomial", nfolds = input$nfolds_lasso, alpha = 0)
                      
                      #### 
                      
                      tidied_cv <- broom::tidy(cv_fit)
                      glance_cv <- broom::glance(cv_fit)
                      
                      cvridge <- ggplot(tidied_cv, aes(lambda, estimate)) +
                        geom_line(color = "blue") +
                        geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = 0.2) +
                        scale_x_log10() +
                        xlab("log10(Lambda)") +
                        ylab("Estimate") +
                        geom_vline(xintercept = glance_cv$lambda.min) +
                        geom_vline(xintercept = glance_cv$lambda.1se, lty = 2) +
                        theme_bw()
                      
                      tmp_coeffs <- coef(cv_fit, s = "lambda.min")
                      final_coef2 <- data.frame(name = tmp_coeffs@Dimnames[[1]][tmp_coeffs@i + 1], coefficient = tmp_coeffs@x)
                      
                      ####
                      
                      tidied_cv2 <- broom::tidy(cv_fit$glmnet.fit)
                      
                      coefficientplot2 <- ggplot(tidied_cv2, aes(lambda, estimate, color = term)) +
                        scale_x_log10() +
                        xlab("log10(Lambda)") +
                        ylab("Coefficients") +
                        geom_line() +
                        geom_vline(xintercept = glance_cv$lambda.min) +
                        geom_vline(xintercept = glance_cv$lambda.1se, lty = 2) +
                        theme_bw() +
                        theme(legend.position = "none")
                      
                      ####
                      
                      results_sel <- list(ridgePlot = coefficientplot2, cvridge = cvridge, final_coef2 = final_coef2)
                      return(results_sel)
 
                    }

                  })
                })


################# LASSO

output$lasso_plot <- renderPlotly({
  ggplotly(Selection_plot()$lassoPlot)
})

output$cvglmnet <- renderPlotly({
  ggplotly(Selection_plot()$cvlasso)
  })

output$table_selected <- DT::renderDataTable({
  
  sel_table<-Selection_plot()$final_coef

  DT::datatable(sel_table, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="lasso"),
                                   list(extend="excel",
                                        filename="lasso"),
                                   list(extend="pdf",
                                        filename="lasso")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(sel_table)))
})

################# RIDGE

output$ridge_plot <- renderPlotly({
  ggplotly(Selection_plot()$ridgePlot)
})

output$cvglmnet2 <- renderPlotly({
  ggplotly(Selection_plot()$cvridge)
})

output$table_selected2 <- DT::renderDataTable({
  sel_table2<-Selection_plot()$final_coef2
  DT::datatable(sel_table2, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="ridge"),
                                   list(extend="excel",
                                        filename="ridge"),
                                   list(extend="pdf",
                                        filename="ridge")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(sel_table2)))
  
})

