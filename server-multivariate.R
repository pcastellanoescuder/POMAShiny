
Multivariate_plot <- 
  eventReactive(input$plot_multivariate,
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    to_plot_data<-NormData()
                    to_plot_data$Group<-as.factor(to_plot_data$Group)
                    df<-as.matrix(to_plot_data[,c(3:ncol(to_plot_data))])
                    
                    if (input$mult_plot == "pca"){
                      
                      X <- as.matrix(df)
                      Y <- as.factor(to_plot_data$Group) 
                      pca.res2<-pca(X, ncomp = input$num_comp, center = F, scale = F)  
                      #scores2 <- plotIndiv(pca.res2, group = Y, legend = TRUE, 
                      #                     title = "",
                      #                     ind.names = FALSE,
                      #                     size.title = .1, size.xlabel = 1.5,
                      #                     size.ylabel = 1.5, size.axis = 1.3, size.legend = 1.3,
                      #                     size.legend.title = 1.3,
                      #                     comp=c(1,2), ellipse = FALSE, style = "graphics")
                      
                      PCi<-data.frame(pca.res2$x,Groups=Y)
                      
                      scores2 <- ggplotly(ggplot(PCi,aes(x=PC1,y=PC2,col=Groups))+
                                            geom_point(size=3,alpha=0.5)+ #Size and alpha just for fun
                                            scale_color_manual(values = c("#FF1BB3","#A7FF5B","#99554D")) 
                                            + #your colors here
                                            theme_minimal())
                      
                      #scores2 <- recordPlot()
                      
                      #plot.new()
                      
                      ####
                      
                      eigenvalues<- data.frame(round(pca.res2$explained_variance*100,3))
                      colnames(eigenvalues)<-"% Variance Explained"
                      
                      eigenvalues$`Principal Component`<-rownames(eigenvalues)
                      #eigenvalues<- eigenvalues[order(-eigenvalues$`% Variance Explained`),]
                      
                      #barplot(eigenvalues[,1], names.arg = rownames(eigenvalues), 
                      #        xlab = "Principal Component",
                      #        ylab = "Percentage of Variance Explained",
                      #        col =c("steelblue","lightblue"))
                      #lines(x = 1:nrow(eigenvalues), 
                      #      eigenvalues[,1], 
                      #      type="b", pch=19, col = "red")
                      
                      #screeplot <- recordPlot()
        
                      screeplot <- ggplot(eigenvalues, aes(x=`Principal Component`, y=`% Variance Explained`, 
                                                           fill=NULL)) +
                        geom_bar(stat="identity", fill = rep(c("lightblue"),nrow(eigenvalues)))  + theme_minimal()
                      screeplot  <- ggplotly(screeplot)  
                      
                      #plot.new()
                      
                      eigenvalues$`Principal Component`<- NULL
                      
                      ####
                      
                      my_biplot <- biplot(pca.res2) 
                      
                      my_biplot <- recordPlot()
                      
                      plot.new()
                      
                      ####

                      comp_data<-data.frame(pca.res2$x)
                      rownames(comp_data) <- to_plot_data$ID
                      
                      results_mult<-list(screeplot=screeplot,scores2=scores2,my_biplot=my_biplot,
                                         comp_data = comp_data, eigenvalues = eigenvalues)
                      return(results_mult)
                    }
                    
                    else if (input$mult_plot == "plsda"){
                      
                      X <- as.matrix(df)
                      Y <- as.factor(to_plot_data$Group)             
                      
                      plsda.res <- plsda(X, Y, ncomp = input$num_comp2)
                      
                      #plsda <- plotIndiv(plsda.res, group = Y, legend = TRUE, 
                      #                   title = '',
                      #                   ind.names = FALSE,
                      #                   size.title = .1, size.xlabel = 1.5,
                      #                   size.ylabel = 1.5, size.axis = 1.3, size.legend = 1.3,
                      #                   size.legend.title = 1.3,
                      #                   comp=c(1,2), ellipse = TRUE, style = "graphics")
                      
                      #plsda <- recordPlot()
                      
                      #plot.new()
                      
                      PLSDAi<-data.frame(plsda.res$variates$X, Groups=Y)
                      colnames(PLSDAi)[1:2]<-c("X-Variate 1", "X-Variate 2")
                      
                      plsda <- ggplotly(ggplot(PLSDAi, aes(x=`X-Variate 1`,y=`X-Variate 2`,col=Groups))+
                                          geom_point(size=3,alpha=0.5)+ #Size and alpha just for fun
                                          scale_color_manual(values = c("#FF1BB3","#A7FF5B","#99554D")) 
                                        + #your colors here
                                          stat_ellipse(aes(x=`X-Variate 1`,y=`X-Variate 2`,col=Groups),
                                                       type = "norm")
                                        + theme_minimal())
                      
                      #####
                      
                      set.seed(69)
                      perf.plsda <- perf(plsda.res, validation = "Mfold", folds = 5, 
                                         progressBar = FALSE, auc = TRUE, nrepeat = 10) 
                      
                      overall<-as.data.frame(perf.plsda$error.rate[1])
                      ber<-as.data.frame(perf.plsda$error.rate[2])
                      
                      errors_plsda<-plot(perf.plsda, col = color.mixo(1:3), sd = TRUE, 
                                         legend.position = "vertical")
                      
                      errors_plsda <- recordPlot()
                      
                      plot.new()
                      
                      ####
                      
                      auc_plsda <- auroc(plsda.res, roc.comp = input$roc_comp1)
                      
                      auc_plsda <- recordPlot()
                      
                      plot.new()
                      
                      ####
                      
                      plsda.vip<-as.data.frame(vip(plsda.res))
                      
                      plsda.vip.top<- plsda.vip[plsda.vip$`comp 1`>input$vip,]
                      plsda.vip.top<-plsda.vip.top[order(plsda.vip.top[,1]),]
                      
                      #par(mar=c(5,6,4,2))
                      
                      #vip_plsda<- barplot(plsda.vip.top[,1],horiz = T,xlim = c(0,max(plsda.vip.top[,1])+0.2), 
                      #names.arg = rownames(plsda.vip.top),las=1,
                      #                    beside = F,col = c("steelblue","lightblue"), 
                      #                    font.main=4,cex.names = 0.7) # cutoff 1.5
                      
                      #vip_plsda <- recordPlot()
                      
                      #plot.new()
                      
                      plsda.vip.top$Variate<- rownames(plsda.vip.top)
                      colnames(plsda.vip.top)[1]<- "VIP"
                      
                      vip_plsda <- ggplotly(ggplot(plsda.vip.top, aes(x=Variate, y=VIP, 
                                                                      fill=NULL)) +
                                              geom_bar(stat="identity", fill = rep(c("lightblue"),
                                                                                   nrow(plsda.vip.top)))  
                                            + coord_flip() 
                                            + theme_minimal())
                  
                      plsda.vip.top<- plsda.vip[plsda.vip$`comp 1`>input$vip,]
                      plsda.vip.top<-plsda.vip.top[order(plsda.vip.top[,1]),]
                      
                      ####
                      
                      plsdaX <- data.frame(plsda.res$variates$X)
                      
                      ####
                      results_mult2<-list(plsda=plsda, errors_plsda=errors_plsda,auc_plsda=auc_plsda,overall=overall,ber=ber, 
                                          vip_plsda=vip_plsda, plsda.vip.top=plsda.vip.top,
                                          plsdaX=plsdaX)
                      return(results_mult2)
                    }
                    
                    else if (input$mult_plot == "splsda"){
                      
                      X <- as.matrix(df)
                      Y <- as.factor(to_plot_data$Group)             
                      
                      # grid of possible keepX values that will be tested for each component
                      list.keepX <- c(1:10)
                      
                      tune.splsda <- tune.splsda(X, Y, ncomp = input$num_comp3, validation = 'Mfold', folds = 5, 
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
                        ncompX<-ncomp}
                      
                      
                      res.splsda <- splsda(X, Y, ncomp = ncompX, keepX = select.keepX) 
                      
                      splsda<-plotIndiv(res.splsda, comp = c(1,2),
                                        group = Y, ind.names = FALSE, 
                                        ellipse = TRUE, legend = TRUE,
                                        title = '',size.title = .1, size.xlabel = 1.5,
                                        size.ylabel = 1.5, size.axis = 1.3, size.legend = 1.3,
                                        size.legend.title = 1.3, style = "graphics")
                      
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

output$pca2D <- renderPlotly({
  Multivariate_plot()$scores2
})

output$ScreePlot <- renderPlotly({
  Multivariate_plot()$screeplot
  })

output$Biplot <- renderPlot({
  Multivariate_plot()$my_biplot
})

output$pcaX <- DT::renderDataTable({
  pca.x1 <- Multivariate_plot()$comp_data
  DT::datatable(pca.x1)
})

output$pcaEigen <- DT::renderDataTable({
  pca.x2 <- Multivariate_plot()$eigenvalues
  DT::datatable(pca.x2)
})

################# PLSDA

output$plsda2D <- renderPlotly({
  Multivariate_plot()$plsda
})

output$plsda_errors <- renderPlot({
  Multivariate_plot()$errors_plsda
})

output$auc_plsdaOutput <- renderPlot({
  Multivariate_plot()$auc_plsda
})

output$overall_table <- DT::renderDataTable({
  DT::datatable(Multivariate_plot()$overall)
})

output$ber_table <- DT::renderDataTable({
  DT::datatable(Multivariate_plot()$ber)
})

output$vip_table <- DT::renderDataTable({
  DT::datatable(Multivariate_plot()$plsda.vip.top)
})

output$vip_plsdaOutput <- renderPlotly({
  Multivariate_plot()$vip_plsda
})

output$plsdaX1 <- DT::renderDataTable({
  DT::datatable(Multivariate_plot()$plsdaX)
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

