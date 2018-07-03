
Multivariate_plot <- 
  eventReactive(input$plot_multivariate,
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    to_plot_data<-NormData()
                    to_plot_data$Group<-as.factor(to_plot_data$Group)
                    df<-as.matrix(to_plot_data[,c(3:ncol(to_plot_data))])
                    
                    if (input$mult_plot == "pca"){
   
                      pca.res <- prcomp(df)
                      eig<-pca.res$sdev^2/sum(pca.res$sdev^2);round(eig,2)
                      
                      screeplot <- qplot(c(1:nrow(df)), eig) + 
                        geom_line() + 
                        xlab("Principal Component") + 
                        ylab("Percentage of Variance Explained") +
                        ggtitle("Scree Plot") +
                        ylim(0, 1) +
                        theme(axis.text=element_text(size=12),
                              axis.title=element_text(size=14),
                              plot.title = element_text(size=22)) 
                      
                      ####
                      
                      X <- as.matrix(df)
                      Y <- as.factor(to_plot_data$Group) 
                      pca.res2<-pca(X, ncomp = 10, center = T, scale = F)  
                      scores2 <- plotIndiv(pca.res2, group = Y, legend = TRUE, 
                                       title = 'PCA Score plot',
                                       ind.names = FALSE,
                                       size.title = 18, size.xlabel = 15,
                                       size.ylabel = 15, size.axis = 12, size.legend = 15,
                                       size.legend.title = 15,
                                       comp=c(1,2), ellipse = FALSE, style = "ggplot2")
                      
                      ####
                      
                      my_biplot<-autoplot(pca.res2, label = T, shape = FALSE,
                                          loadings = TRUE, loadings.label = TRUE,label.size = 4, 
                                          label.repel = TRUE,
                                          main = "Biplot") +
                        xlab("PC1") +
                        ylab("PC2") +
                        
                        theme(axis.text=element_text(size=12),
                              axis.title=element_text(size=14),
                              plot.title = element_text(size=22))
                      
                      ####
                      
                      results_mult<-list(screeplot=screeplot,scores2=scores2,my_biplot=my_biplot)
                      return(results_mult)
                    }
                    
                    else if (input$mult_plot == "plsda"){
                      
                      X <- as.matrix(df)
                      Y <- as.factor(to_plot_data$Group)             
                      
                      plsda.res <- plsda(X, Y, ncomp = 10)
                      
                      plsda <- plotIndiv(plsda.res, group = Y, legend = TRUE, 
                                         title = 'PLS-DA Score plot',
                                         ind.names = FALSE,
                                         size.title = 18, size.xlabel = 15,
                                         size.ylabel = 15, size.axis = 12, size.legend = 15,
                                         size.legend.title = 15,
                                         comp=c(1,2), ellipse = TRUE)
                      #####
                      
                      set.seed(69)
                      perf.plsda <- perf(plsda.res, validation = "Mfold", folds = 5, 
                                         progressBar = FALSE, auc = TRUE, nrepeat = 10) 
                      
                      #perf.plsda.srbct$error.rate  # error rates
                      
                      errors_plsda<-plot(perf.plsda, col = color.mixo(1:3), sd = TRUE, 
                                         legend.position = "vertical")
                      
                      errors_plsda <- recordPlot()
                      
                      plot.new()
                      
                      ####
                      
                      auc_plsda <- auroc(plsda.res, roc.comp = 1)
                      
                      auc_plsda <- recordPlot()
                      
                      plot.new()
                      
                      ####
                      
                      results_mult2<-list(plsda=plsda, errors_plsda=errors_plsda,auc_plsda=auc_plsda)
                      return(results_mult2)
                    }
                    
                    else if (input$mult_plot == "splsda"){
                      
                      X <- as.matrix(df)
                      Y <- as.factor(to_plot_data$Group)             
                      
                      # grid of possible keepX values that will be tested for each component
                      list.keepX <- c(1:10)
                      
                      tune.splsda <- tune.splsda(X, Y, ncomp = 6, validation = 'Mfold', folds = 5, 
                                                 progressBar = FALSE, dist = 'max.dist', measure = "BER",
                                                 test.keepX = list.keepX, nrepeat = 10, cpus = 4)
                      
                      error <- tune.splsda$error.rate 
                      
                      ncomp <- tune.splsda$choice.ncomp$ncomp # optimal number of components based on t-tests
                      #ncomp
                      
                      select.keepX <- tune.splsda$choice.keepX[1:ncomp]  # optimal number of variables to select
                      #select.keepX
                      
                      
                      bal_error_rate<-plot(tune.splsda, col = color.jet(6))
                      bal_error_rate <- recordPlot()
                      
                      plot.new()
                      
                      ####
                      
                      if (ncomp == 1){
                        ncompX<-2
                      }else{
                        ncompX<-ncomp
                      }
                      
                      res.splsda <- splsda(X, Y, ncomp = ncompX, keepX = select.keepX) 
                      
                      splsda<-plotIndiv(res.splsda, comp = c(1,2),
                                        group = Y, ind.names = FALSE, 
                                        ellipse = TRUE, legend = TRUE,
                                        title = 'sPLS-DA, comp 1 & 2',size.title = 18, size.xlabel = 15,
                                        size.ylabel = 15, size.axis = 12, size.legend = 15,
                                        size.legend.title = 15)
                      
                      splsda <- recordPlot()
                      
                      plot.new()
                      
                      ####
                      
                      auc.splsda <- auroc(res.splsda, roc.comp = ncomp)
                      
                      auc.splsda <- recordPlot()
                      
                      plot.new()
                      
                      results_mult3<-list(splsda=splsda, bal_error_rate=bal_error_rate,auc.splsda=auc.splsda)
                      return(results_mult3)
                    }

                  })
                })


################# PCA

output$pca2D <- renderPlot({
  Multivariate_plot()$scores2
})

output$ScreePlot <- renderPlot({
  Multivariate_plot()$screeplot
  })

output$Biplot <- renderPlot({
  Multivariate_plot()$my_biplot
})

################# PLSDA

output$plsda2D <- renderPlot({
  Multivariate_plot()$plsda
})

output$plsda_errors <- renderPlot({
  Multivariate_plot()$errors_plsda
})

output$auc_plsdaOutput <- renderPlot({
  Multivariate_plot()$auc_plsda
})

################# sPLSDA

output$splsda2D <- renderPlot({
  Multivariate_plot()$splsda
})

output$BalancedError <- renderPlot({
  Multivariate_plot()$bal_error_rate
})

output$auc_splsdaOutput <- renderPlot({
  Multivariate_plot()$auc.splsda
})

