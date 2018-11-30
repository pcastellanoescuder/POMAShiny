observe_helpers(help_dir = "help_mds")

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
                      pca.res2<-mixOmics::pca(X, ncomp = input$num_comp, center = F, scale = F)  
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
                                            scale_color_manual(values = c("#FF1BB3","#A7FF5B","#99554D","blue","darkgoldenrod2","gray9")) 
                                            + #your colors here
                                            theme_minimal())
                      
                      #scores2 <- recordPlot()
                      
                      #plot.new()
                      
                      ####
                      
                      eigenvalues<- data.frame(round(pca.res2$explained_variance*100,4))
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
                      
                      #my_biplot <- biplot(pca.res2) 
                      
                      my_biplot <- ggplotly(ggbiplot::ggbiplot(pca.res2, scale = 1,
                                                      groups = Y, ellipse = F, circle = F) 
                                            + theme_minimal() 
                                            + geom_point(size=1.5,alpha=0.1) 
                                            + scale_color_manual(values = c("#FF1BB3","#A7FF5B","#99554D","blue","darkgoldenrod2","gray9")))
                      
                      #plot.new()
                      
                      ####

                      comp_data<-round(data.frame(pca.res2$x),4)
                      rownames(comp_data) <- make.names(to_plot_data$ID,unique = TRUE)
                      rownames(comp_data)<-gsub("X","",rownames(comp_data))
                      
                      results_mult<-list(screeplot=screeplot,scores2=scores2,my_biplot=my_biplot,
                                         comp_data = comp_data, eigenvalues = eigenvalues)
                      return(results_mult)
                    }
                    
                    else if (input$mult_plot == "plsda"){
                      
                      X <- as.matrix(df)
                      Y <- as.factor(to_plot_data$Group)             
                      
                      plsda.res <- plsda(X, Y, ncomp = input$num_comp2)
                      
                      
                      PLSDAi<-data.frame(plsda.res$variates$X, Groups=Y)
                      colnames(PLSDAi)[1:2]<-c("Component 1", "Component 2")
                      
                      plsda <- ggplotly(ggplot(PLSDAi, aes(x=`Component 1`,y=`Component 2`,col=Groups))+
                                          geom_point(size=3,alpha=0.5)+ #Size and alpha just for fun
                                          scale_color_manual(values = c("#FF1BB3","#A7FF5B","#99554D","blue","darkgoldenrod2","gray9")) 
                                        + #your colors here
                                          stat_ellipse(aes(x=`Component 1`,y=`Component 2`,col=Groups),
                                                       type = "norm")
                                        + theme_minimal())
                      
                      #####
                      
                      set.seed(69)
                      perf.plsda <- perf(plsda.res, validation = "Mfold", folds = 5, 
                                         progressBar = FALSE, auc = TRUE, nrepeat = 10) 
                      
                      overall<-round(as.data.frame(perf.plsda$error.rate[1]),4)
                      ber<-round(as.data.frame(perf.plsda$error.rate[2]),4)
                      
                      ber$Component<-rownames(ber)
                      overall$Component<-rownames(overall)
                      
                      errors_plsda1<-melt(ber, id.vars=c("Component"))
                      errors_plsda2<-melt(overall, id.vars=c("Component"))
                      
                      errors_plsda<-rbind(errors_plsda1,errors_plsda2)
                      
                      errors_plsda<-ggplotly(ggplot(data=errors_plsda, aes(x=Component, y=value, group=variable)) +
                                 geom_line(aes(color=variable)) +
                                 geom_point(aes(color=variable)) + 
                                 theme_minimal() +
                                 geom_point(size=3,alpha=0.5) + #Size and alpha just for fun
                                 scale_color_manual(values = c("#FF1BB3","#A7FF5B","#99554D","blue","darkgoldenrod2","gray9")))
                      
                      
                      ####
                      
                      auc_plsda <- auroc(plsda.res, roc.comp = input$roc_comp1)
                      
                      auc_plsda <- recordPlot()
                      
                      plot.new()
                      
                      ####
                      
                      plsda.vip<-as.data.frame(vip(plsda.res))
                      
                      plsda.vip.top<- plsda.vip[plsda.vip$`comp 1`>input$vip,]
                      plsda.vip.top<-plsda.vip.top[order(plsda.vip.top[,1]),]
                      
                      
                      plsda.vip.top$Variate<- rownames(plsda.vip.top)
                      colnames(plsda.vip.top)[1]<- "VIP"
                      
                      vip_plsda <- ggplotly(ggplot(plsda.vip.top, aes(x=Variate, y=VIP, 
                                                                      fill=NULL)) +
                                              geom_bar(stat="identity", fill = rep(c("lightblue"),
                                                                                   nrow(plsda.vip.top)))  
                                            + coord_flip() 
                                            + theme_minimal())
                  
                      plsda.vip.top <- plsda.vip[plsda.vip$`comp 1`>input$vip,]
                      plsda.vip.top <- round(plsda.vip.top[order(plsda.vip.top[,1]),],4)
                      
                      ####
                      
                      plsdaX <- round(data.frame(plsda.res$variates$X),4)
                      
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
                      list.keepX <- c(1:input$num_feat)
                      
                      tune.splsda <- tune.splsda(X, Y, ncomp = input$num_comp3, validation = 'Mfold', folds = 5, 
                                                 progressBar = FALSE, dist = 'max.dist', measure = "BER",
                                                 test.keepX = list.keepX, nrepeat = 10, cpus = 4)
                      
                      error <- tune.splsda$error.rate 
                      
                      ncomp <- tune.splsda$choice.ncomp$ncomp # optimal number of components based on t-tests
                      #ncomp
                      
                      select.keepX <- tune.splsda$choice.keepX[1:ncomp]  # optimal number of variables to select
                      #select.keepX
                      
                      errors_splsda_out<-round(as.data.frame(tune.splsda$error.rate),4)
                      errors_splsda_out$features<-rownames(errors_splsda_out)
                      errors_splsda1<-melt(errors_splsda_out, id.vars=c("features"))
                      
                      
                      errors_sd<-as.data.frame(tune.splsda$error.rate.sd)
                      errors_sd$features_sd<-rownames(errors_sd)
                      errors_sd <- melt(errors_sd, id.vars=c("features_sd"))
                      
                      errors_splsda <- cbind(errors_splsda1,sd = errors_sd[,3])
                      
                      bal_error_rate <- ggplotly(ggplot(data=errors_splsda, aes(x=features, y=value, group=variable)) +
                                                   geom_line(aes(color=variable)) +
                                                   geom_point(aes(color=variable)) + 
                                                   geom_errorbar(aes(ymin=value-sd, ymax=value+sd), width=.1) + 
                                                   theme_minimal() +
                                                   geom_point(size=3,alpha=0.5) + #Size and alpha just for fun
                                                   scale_color_manual(values = c("#FF1BB3","#A7FF5B","#99554D","blue","darkgoldenrod2","gray9")))
                      
                      ####
                      
                      if (ncomp == 1){
                        ncompX<-2
                      }else{
                        ncompX<-ncomp}
                      
                      
                      res.splsda <- splsda(X, Y, ncomp = ncompX, keepX = select.keepX) 
                      
                      SPLSDAi<-data.frame(res.splsda$variates$X, Groups=Y)
                      colnames(SPLSDAi)[1:2]<-c("Component 1", "Component 2")
                      
                      splsda <- ggplotly(ggplot(SPLSDAi, aes(x=`Component 1`,y=`Component 2`,col=Groups))+
                                           geom_point(size=3,alpha=0.5)+ #Size and alpha just for fun
                                           scale_color_manual(values = c("#FF1BB3","#A7FF5B","#99554D","blue","darkgoldenrod2","gray9")) 
                                         + #your colors here
                                           stat_ellipse(aes(x=`Component 1`,y=`Component 2`,col=Groups),
                                                        type = "norm")
                                         + theme_minimal())
                      
                      splsdaX <- round(data.frame(res.splsda$variates$X),4)
                      
                      selected_variables <- selectVar(res.splsda, comp = 1)
                      selected_variables <- round(selected_variables$value,4)
                      selected_variables <- data.frame(Feature = rownames(selected_variables), Value = selected_variables$value.var)
                                                       
                      ####
                      
                      auc.splsda <- auroc(res.splsda, roc.comp = ncompX)
                      
                      auc.splsda <- recordPlot()
                      
                      plot.new()
                      
                      results_mult3<-list(splsda=splsda, bal_error_rate=bal_error_rate,
                                          auc.splsda=auc.splsda, splsdaX=splsdaX, errors_splsda_out=errors_splsda_out,
                                          selected_variables=selected_variables)
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

output$Biplot <- renderPlotly({
  Multivariate_plot()$my_biplot
})

output$pcaX <- DT::renderDataTable({
  
  pca01 <- Multivariate_plot()$comp_data
  
  DT::datatable(pca01, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="pca_scores"),
                                   list(extend="excel",
                                        filename="pca_scores"),
                                   list(extend="pdf",
                                        filename="pca_scores")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(pca01)))
})

output$pcaEigen <- DT::renderDataTable({
  DT::datatable(Multivariate_plot()$eigenvalues)

})

################# PLSDA

output$plsda2D <- renderPlotly({
  Multivariate_plot()$plsda
})

output$plsda_errors <- renderPlotly({
  Multivariate_plot()$errors_plsda
})

output$auc_plsdaOutput <- renderPlot({
  Multivariate_plot()$auc_plsda
})

output$overall_table <- DT::renderDataTable({

  DT::datatable(Multivariate_plot()$overall, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="plsda_overall"),
                                   list(extend="excel",
                                        filename="plsda_overall"),
                                   list(extend="pdf",
                                        filename="plsda_overall")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$overall)))
})

output$ber_table <- DT::renderDataTable({
  
  DT::datatable(Multivariate_plot()$ber, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="plsda_ber"),
                                   list(extend="excel",
                                        filename="plsda_ber"),
                                   list(extend="pdf",
                                        filename="plsda_ber")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$ber)))
  
})

output$vip_table <- DT::renderDataTable({
  
  DT::datatable(Multivariate_plot()$plsda.vip.top, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="plsda_vip"),
                                   list(extend="excel",
                                        filename="plsda_vip"),
                                   list(extend="pdf",
                                        filename="plsda_vip")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$plsda.vip.top)))
})

output$vip_plsdaOutput <- renderPlotly({
  Multivariate_plot()$vip_plsda
})

output$plsdaX1 <- DT::renderDataTable({

  DT::datatable(Multivariate_plot()$plsdaX, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="plsda_scores"),
                                   list(extend="excel",
                                        filename="plsda_scores"),
                                   list(extend="pdf",
                                        filename="plsda_scores")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$plsdaX)))
})

################# sPLSDA

output$splsda2D <- renderPlotly({
  Multivariate_plot()$splsda
})

output$BalancedError <- renderPlotly({
  Multivariate_plot()$bal_error_rate
})

output$auc_splsdaOutput <- renderPlot({
  Multivariate_plot()$auc.splsda
})

output$errors_splsda <- DT::renderDataTable({
  
  DT::datatable(Multivariate_plot()$errors_splsda_out, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="splsda_errors"),
                                   list(extend="excel",
                                        filename="splsda_errors"),
                                   list(extend="pdf",
                                        filename="splsda_errors")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$errors_splsda_out)))
})

output$splsdaX1 <- DT::renderDataTable({
  
  DT::datatable(Multivariate_plot()$splsdaX, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="splsda_scores"),
                                   list(extend="excel",
                                        filename="splsda_scores"),
                                   list(extend="pdf",
                                        filename="splsda_scores")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$splsdaX)))
})

output$selected_var <- DT::renderDataTable({
  
  DT::datatable(Multivariate_plot()$selected_variables, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="splsda_variables"),
                                   list(extend="excel",
                                        filename="splsda_variables"),
                                   list(extend="pdf",
                                        filename="splsda_variables")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Multivariate_plot()$selected_variables)))
})

