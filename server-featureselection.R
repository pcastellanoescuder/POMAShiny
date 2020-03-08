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
                    
                    df<-NormData()
                    Y<-as.factor(df$Group)
                    X<-as.matrix(df[,3:ncol(df)])
                    
                    if (input$feat_selection == "lasso"){
                      
                      fit <- glmnet(X,Y,family="binomial")
                      lassoPlot <- ggplotly(autoplot(fit)  + theme_bw())
                      
                      ####
                      
                      cv_fit <- cv.glmnet(X,Y, family = "binomial")
                      
                      tidied_cv <- tidy(cv_fit)
                      glance_cv <- glance(cv_fit)
                      
                      cvlasso<-ggplotly(ggplot(tidied_cv, aes(lambda, estimate)) + geom_line(color = "blue") +
                        geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = .2) +
                        scale_x_log10() +
                        geom_vline(xintercept = glance_cv$lambda.min) +
                        geom_vline(xintercept = glance_cv$lambda.1se, lty = 2) +
                        theme_bw())
                      
                      
                      ####
                      
                      tmp_coeffs <- coef(cv_fit, s = "lambda.min")
                      final_coef<-data.frame(name = tmp_coeffs@Dimnames[[1]][tmp_coeffs@i + 1], coefficient = round(tmp_coeffs@x,4))
                      
                      ####
                      
                      results_sel<-list(lassoPlot=lassoPlot,cvlasso=cvlasso,final_coef=final_coef)
                      return(results_sel)
                    }
                    
                    else if (input$feat_selection == "ridge"){
                      
                      
                      fit2 <- glmnet(X,Y,family="binomial", alpha = 0)
                      ridgePlot <- ggplotly(autoplot(fit2)  + theme_bw())

                      ####
                      
                      cv_fit2 <- cv.glmnet(X,Y, family = "binomial", alpha = 0)
                      
                      tidied_cv2 <- tidy(cv_fit2)
                      glance_cv2 <- glance(cv_fit2)
                      
                      cvridge<-ggplotly(ggplot(tidied_cv2, aes(lambda, estimate)) + geom_line(color = "blue") +
                                          geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = .2) +
                                          scale_x_log10() +
                                          geom_vline(xintercept = glance_cv2$lambda.min) +
                                          geom_vline(xintercept = glance_cv2$lambda.1se, lty = 2) +
                                          theme_bw())
                      
                      ####
                      
                      tmp_coeffs2 <- coef(cv_fit2, s = "lambda.min")
                      final_coef2<-data.frame(name = tmp_coeffs2@Dimnames[[1]][tmp_coeffs2@i + 1], coefficient = round(tmp_coeffs2@x,4))
                      
                      ####
                      
                      results_sel2<-list(ridgePlot=ridgePlot,cvridge=cvridge,final_coef2=final_coef2)
                      return(results_sel2)
                    }

                  })
                })


################# LASSO

output$lasso_plot <- renderPlotly({
  Selection_plot()$lassoPlot
})

output$cvglmnet <- renderPlotly({
  Selection_plot()$cvlasso
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
  Selection_plot()$ridgePlot
})

output$cvglmnet2 <- renderPlotly({
  Selection_plot()$cvridge
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

