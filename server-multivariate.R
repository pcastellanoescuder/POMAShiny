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
                    
                    to_plot_data<-NormData()
                    to_plot_data$Group<-as.factor(to_plot_data$Group)
                    df<-as.matrix(to_plot_data[,c(3:ncol(to_plot_data))])
                    
                    if (input$mult_plot == "pca"){
                      
                      X <- as.matrix(df)
                      Y <- as.factor(to_plot_data$Group) 
                      pca.res2<-mixOmics::pca(X, ncomp = input$num_comp, 
                                              center = eval(parse(text = input$center)), 
                                              scale = eval(parse(text = input$scale)))  
                      
                      PCi<-data.frame(pca.res2$x,Groups=Y)
                      
                      scores2 <- ggplotly(ggplot(PCi,aes(x=PC1,y=PC2,col=Groups))+
                                            geom_point(size=3,alpha=0.5) + 
                                            xlab(paste0("PC1 (", round(100*(pca.res2$explained_variance)[1], 2), "%)")) +
                                            ylab(paste0("PC2 (", round(100*(pca.res2$explained_variance)[2], 2), "%)")) +
                                            scale_fill_viridis() + 
                                            theme_minimal())
                      
                      ####
                      
                      eigenvalues<- data.frame(round(pca.res2$explained_variance*100,4))
                      colnames(eigenvalues)<-"% Variance Explained"
                      
                      eigenvalues$`Principal Component`<-rownames(eigenvalues)
        
                      screeplot <- ggplot(eigenvalues, aes(x=`Principal Component`, y=`% Variance Explained`, fill=NULL)) +
                        geom_bar(stat="identity", fill = rep(c("lightblue"),nrow(eigenvalues))) + 
                        xlab("Principal Component") +
                        ylab("% Variance Explained") +
                        theme_minimal()
                      screeplot  <- ggplotly(screeplot)  

                      eigenvalues$`Principal Component`<- NULL
                      
                      ####

                      my_biplot <- ggplotly(ggbiplot::ggbiplot(pca.res2, scale = 1,
                                                      groups = Y, ellipse = F, circle = F, alpha = 0.5) +
                                             theme_minimal() +
                                             scale_fill_viridis(), width = 500)
                      
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
                                          geom_point(size=3,alpha=0.5) + 
                                          scale_fill_viridis() +
                                          xlab("Component 1") + 
                                          ylab("Component 2") +
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
                                 geom_point(size=3,alpha=0.5) + 
                                 scale_fill_viridis())
                      
                      ####
                      
                      auc_plsda <- auroc(plsda.res)
                      
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

                      list.keepX <- c(1:input$num_feat)
                      
                      tune.splsda <- tune.splsda(X, Y, ncomp = input$num_comp3, validation = 'Mfold', folds = 5, 
                                                 progressBar = FALSE, dist = 'max.dist', measure = "BER",
                                                 test.keepX = list.keepX, nrepeat = 10, cpus = 4)
                      
                      error <- tune.splsda$error.rate 
                      
                      ncomp <- tune.splsda$choice.ncomp$ncomp # optimal number of components based on t-tests
                      
                      select.keepX <- tune.splsda$choice.keepX[1:ncomp]  # optimal number of variables to select
                      
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
                                                   geom_point(size=3,alpha=0.5) + 
                                                   scale_fill_viridis() 
                                                 )
                      
                      ####
                      
                      if (ncomp == 1){
                        ncompX<-2
                      }else{
                        ncompX<-ncomp}
                      
                      
                      res.splsda <- splsda(X, Y, ncomp = ncompX, keepX = select.keepX) 
                      
                      SPLSDAi<-data.frame(res.splsda$variates$X, Groups=Y)
                      colnames(SPLSDAi)[1:2]<-c("Component 1", "Component 2")
                      
                      splsda <- ggplotly(ggplot(SPLSDAi, aes(x=`Component 1`,y=`Component 2`,col=Groups))+
                                           geom_point(size=3,alpha=0.5) + 
                                           scale_fill_viridis() +
                                           xlab("Component 1") + 
                                           ylab("Component 2") +
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
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
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
  DT::datatable(Multivariate_plot()$eigenvalues, class = 'cell-border stripe',
                rownames = TRUE)

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

  overall <- Multivariate_plot()$overall
  as.datatable(formattable(overall, list(overall.max.dist = color_tile("#F38620","white"),
                                         overall.centroids.dist = color_tile("#F38620","white"),
                                         overall.mahalanobis.dist = color_tile("#F38620","white"))), 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
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
  
  ber <- Multivariate_plot()$ber
  as.datatable(formattable(ber, list(BER.max.dist = color_tile("#F38620","white"),
                                     BER.centroids.dist = color_tile("#F38620","white"),
                                     BER.mahalanobis.dist = color_tile("#F38620","white"))), 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
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
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
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
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
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
  
  errors_splsda_out <- Multivariate_plot()$errors_splsda_out
  col_idx <- grep("features", names(errors_splsda_out))
  errors_splsda_out <- errors_splsda_out[, c(col_idx, (1:ncol(errors_splsda_out))[-col_idx])]
  
  DT::datatable(errors_splsda_out, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
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
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
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
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
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

