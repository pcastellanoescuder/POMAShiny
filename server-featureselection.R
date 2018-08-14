
Selection_plot <- 
  eventReactive(input$feat_selection_action,
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    to_plot_data<-NormData()
                    to_plot_data$Group<-as.factor(to_plot_data$Group)
                    df<-as.matrix(to_plot_data[,c(3:ncol(to_plot_data))])
                    
                    if (input$feat_selection == "lasso"){

                      X <- as.matrix(df)
                      Y <- as.factor(to_plot_data$Group) 
                      
                      par(mar=c(5,6,4,2))
                      
                      fit <- glmnet(X,Y,family="multinomial")
                      lassoPlot<-plot(fit, xvar="norm",cex.lab=1.3, cex.axis=1.2)
                      
                      lassoPlot <- recordPlot()
                      
                      plot.new()
                      
                      ####
                      
                      cvfit <- cv.glmnet(X,Y,family="multinomial")
                      cvlasso<-plot(cvfit,cex.lab=1.3, cex.axis=1.2)
                      
                      cvlasso <- recordPlot()
                      
                      plot.new()
                      
                      ####
                      
                      coefficients_l<-coef(cvfit, s= "lambda.min")[1]$`1`
                      coefficients_l<-as.data.frame(as.matrix(coefficients_l))
                      colnames(coefficients_l)<-"Coefficients"
                      coefficients_l$Names<-rownames(coefficients_l)
                      final_coef<-coefficients_l[coefficients_l$Coefficients != 0,]
                      rownames(final_coef)<-final_coef$Names;final_coef$Names<-NULL
                      
                      ####
                      
                      results_sel<-list(lassoPlot=lassoPlot,cvlasso=cvlasso,final_coef=final_coef)
                      return(results_sel)
                    }
                    
                    else if (input$feat_selection == "ridge"){
                      
                      X <- as.matrix(df)
                      Y <- as.factor(to_plot_data$Group) 
                      
                      par(mar=c(5,6,4,2))
                      
                      fit2 <- glmnet(X,Y,family="multinomial", alpha = 0)
                      ridgePlot<-plot(fit2, xvar="norm",cex.lab=1.3, cex.axis=1.2)
                      
                      ridgePlot <- recordPlot()
                      
                      plot.new()
                      
                      ####
                      
                      cvfit2 <- cv.glmnet(X,Y,family="multinomial",alpha=0)
                      cvridge<-plot(cvfit2,cex.lab=1.3, cex.axis=1.2)
                      
                      cvridge <- recordPlot()
                      
                      plot.new()
                      
                      ####
                      
                      coefficients_r<-coef(cvfit2, s= "lambda.min")[1]$`1`
                      coefficients_r<-as.data.frame(as.matrix(coefficients_r))
                      colnames(coefficients_r)<-"Coefficients"
                      coefficients_r$Names<-rownames(coefficients_r)
                      final_coef2<-coefficients_r[coefficients_r$Coefficients != 0,]
                      rownames(final_coef2)<-final_coef2$Names;final_coef2$Names<-NULL
                      
                      ####
                      
                      results_sel2<-list(ridgePlot=ridgePlot,cvridge=cvridge,final_coef2=final_coef2)
                      return(results_sel2)
                    }

                  })
                })


################# LASSO

output$lasso_plot <- renderPlot({
  Selection_plot()$lassoPlot
})

output$cvglmnet <- renderPlot({
  Selection_plot()$cvlasso
  })

output$table_selected <- DT::renderDataTable({
  sel_table<-Selection_plot()$final_coef
  DT::datatable(sel_table)
})

################# RIDGE

output$ridge_plot <- renderPlot({
  Selection_plot()$ridgePlot
})

output$cvglmnet2 <- renderPlot({
  Selection_plot()$cvridge
})

output$table_selected2 <- DT::renderDataTable({
  sel_table2<-Selection_plot()$final_coef2
  DT::datatable(sel_table2)
})

