observe_helpers(help_dir = "help_mds")

Univ_analisis <- 
  eventReactive(input$play_test, 
                               ignoreNULL = TRUE, {
                                 withProgress(message = "Please wait",{
                                   
                              data_uni <- NormData()
                              
                              if(!is.null(covariatesInput())){
                                covariate_uni <- covariatesInput()
                                colnames(covariate_uni)[1]<-"ID"
                              } else {
                                covariate_uni <- NULL
                                }

                              
                              if (input$univariate_test == "limma"){
                                
                                fac1 <- as.factor(data_uni$Group)
                                
                                initialmodel <- model.matrix( ~ fac1)
                                trans_limma <- t(data_uni[,c(3:ncol(data_uni))]) # transposo la data
                                model <- lmFit(trans_limma, initialmodel)
                                modelstats <- eBayes(model)
                                res <- topTable(modelstats, number = ncol(data_uni) , coef = 1, sort.by = "p")
                                res <- as.data.frame(res)
                                
                                ####
                                
                                if(!is.null(covariate_uni)){
                                
                              
                                form <- as.formula(noquote(paste("~ fac1 + ", paste(colnames(covariate_uni)[2:length(covariate_uni)], 
                                                                                    collapse = " + ",sep=""), sep = "")))
                                
                                initialmodel2 <- model.matrix(form , covariate_uni)
                                trans_limma2 <- t(data_uni[,c(3:ncol(data_uni))]) # transposo la data
                                model2 <- lmFit(trans_limma2, initialmodel2)
                                modelstats2 <- eBayes(model2)
                                res2 <- topTable(modelstats2, number= ncol(data_uni) , coef = 1, sort.by = "p")
                                res2 <- as.data.frame(res2)
                                  
                                } else {
                                  res2<- NULL
                                }
                                
                                table1<-list(res=res, res2=res2)
                                return(table1)
                                }
                              
                              else if (input$univariate_test == "ttest"){
                                
                                stat <- function(x){t.test(x ~ unlist(data_uni[,2]),na.rm=TRUE, alternative=c("two.sided"))$p.value}
                                stat_G2 <- function(x){t.test(x ~ unlist(data_uni[,2]),na.rm=TRUE, alternative=c("two.sided"))$estimate[[2]]}
                                stat_G1 <- function(x){t.test(x ~ unlist(data_uni[,2]),na.rm=TRUE, alternative=c("two.sided"))$estimate[[1]]}
                                
                                
                                p <- as.data.frame(apply(FUN=stat, MARGIN = 2, X = data_uni[,c(3:ncol(data_uni))] ))
                                colnames(p) <- c("P.Value")
                                p$adj.P.Val <- p.adjust(p$P.Value, method = "fdr")
                                G2 <- as.data.frame(apply(FUN=stat_G2, MARGIN = 2, X = data_uni[,c(3:ncol(data_uni))] ))
                                colnames(G2) <- c("Mean G2")
                                G1 <- as.data.frame(apply(FUN=stat_G1, MARGIN = 2, X = data_uni[,c(3:ncol(data_uni))] ))
                                colnames(G1) <- c("Mean G1")
                                FC <- G2/G1
                                colnames(FC) <- c("FC")
                                FC <- round(as.numeric(FC$FC),4)
                                
                                p <- cbind(G1,G2, FC, p)
                                
                                table2<-list(p=p)
                                return(table2)
                              }
                              
                              else if (input$univariate_test=="anova"){
                                
                                stat2 <- function(x){anova(aov(x ~ Group, data=data_uni))$"Pr(>F)"[1]}
                                p2 <- as.data.frame(apply(FUN=stat2, MARGIN = 2, X = data_uni[,c(3:ncol(data_uni))]))
                                colnames(p2) <- c("P.Value")
                                p2$adj.P.Val <- p.adjust(p2$P.Value, method = "fdr")

                               if(!is.null(covariate_uni)){
                                
                                 covariate_uni <- merge(data_uni, covariate_uni, by = "ID")
                            
                                 form2 <- noquote(paste("y ~",paste(colnames(covariate_uni)[c(2,(length(data_uni)+1):length(covariate_uni))], 
                                                                    collapse = " + ",sep="")))
                                 
                                 stat3 <- function(y){anova(aov(as.formula(form2), data = covariate_uni))$"Pr(>F)"[1]}
                                 p3 <- as.data.frame(apply(FUN=stat3, MARGIN = 2, X = covariate_uni[,3:length(data_uni)]))
                                 colnames(p3) <- c("P.Value")
                                 p3$adj.P.Val <- p.adjust(p3$P.Value, method = "fdr")
                                  
                                } else {
                                  p3 <- NULL
                                }
                                
                                table3 <- list(p2=p2, p3=p3)
                                return(table3)
                              }
                              
                              else if (input$univariate_test=="mann"){
                                
                                Group <- data_uni$Group
                                
                                non_param_mann <- as.data.frame(apply(data_uni[,3:ncol(data_uni)],2,function(x){wilcox.test(x ~ as.factor(Group))$p.value}))
                                
                                colnames(non_param_mann) <- c("P.Value")
                                non_param_mann$adj.P.Val <- p.adjust(non_param_mann$P.Value, method = "fdr")
                                
                                non_param_mann <- list(non_param_mann=non_param_mann)
                                return(non_param_mann)
                              }
                              
                              else if (input$univariate_test=="kruskal"){
                                
                                Group <- data_uni$Group
                                
                                non_param_kru <- as.data.frame(apply(data_uni[,3:ncol(data_uni)],2,function(x){kruskal.test(x ~ as.factor(Group))$p.value}))
                                
                                colnames(non_param_kru) <- c("P.Value")
                                non_param_kru$adj.P.Val <- p.adjust(non_param_kru$P.Value, method = "fdr")
                                
                                non_param_kru <- list(non_param_kru=non_param_kru)
                                return(non_param_kru)
                              }
                                
                              
                            }) # tanco withProgress
                          })

####

output$matriu <- DT::renderDataTable({
  
  DT::datatable(Univ_analisis()$res,
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="limma"),
                                   list(extend="excel",
                                        filename="limma"),
                                   list(extend="pdf",
                                        filename="limma")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = 100))
})


output$matriu_cov <- DT::renderDataTable({
  
  DT::datatable(Univ_analisis()$res2, 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="limma_covariates"),
                                   list(extend="excel",
                                        filename="limma_covariates"),
                                   list(extend="pdf",
                                        filename="limma_covariates")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = 100))
})


output$matriu_anova <- DT::renderDataTable({
  
  DT::datatable(Univ_analisis()$p2, 
                 filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="anova"),
                                   list(extend="excel",
                                        filename="anova"),
                                   list(extend="pdf",
                                        filename="anova")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = 100))
})


output$matriu_anova_cov <- DT::renderDataTable({
  
  DT::datatable(Univ_analisis()$p3, 
                 filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="anova_covariates"),
                                   list(extend="excel",
                                        filename="anova_covariates"),
                                   list(extend="pdf",
                                        filename="anova_covariates")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = 100))
})


output$matriu2 <- DT::renderDataTable({
  DT::datatable(Univ_analisis()$p,
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="ttest"),
                                   list(extend="excel",
                                        filename="ttest"),
                                   list(extend="pdf",
                                        filename="ttest")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = 100))
})


###################################################
## VOLCANO PLOT ###################################
###################################################

plotdataInput<-reactive({
  a <- Univ_analisis()$p
  P.Value <- a[,4]
  FC<-a[,3]
  df <- data.frame(P.Value, FC)
  
  #df$gene <- rownames(a)
  
  #df$threshold<-as.factor(abs(df$FC) > input$FCcut & df$P.Value < input$pcut)
  #df
  # 
  
  df <- mutate(df,threshold = ifelse(df$P.Value >= input$pcut, 
                                     yes = "none", 
                                     no = ifelse(df$FC < input$FCcut, 
                                                 yes = "Down-regulated", 
                                                 no = ifelse(df$FC > input$FCcut,
                                                             yes = "Up-regulated",
                                                             no = "none"))))
  
})

# output upload dataset or example dataset  

#plotfunction
getvocalnoPlot<-reactive({
  df<-plotdataInput()
  g <- ggplot(data=df, aes(x=log2(FC), y=-log10(P.Value), colour=factor(threshold))) +
    geom_point( size=1.75) +
    #ylim(c(0, input$ylmslider)) + 
    xlim(c(-(input$xlmslider), input$xlmslider)) +
    xlab("log2 fold change") + ylab("-log10 p-value")+
    scale_y_continuous(trans = "log1p")+
    geom_vline(xintercept = -log2(input$FCcut), colour = "black") + 
    geom_vline(xintercept = log2(input$FCcut), colour = "black") + 
    geom_hline(yintercept = -log10(input$pcut), colour = "black") 
  if(input$theme=="default"){
    g=g+theme(legend.position = "none")+ theme_bw()+scale_color_manual(values = c("Down-regulated" = "#E64B35", 
                                                                                  "Up-regulated" = "#3182bd", 
                                                                                  "none" = "#636363"))
  }else if(input$theme=="Tufte"){
    g=g+geom_rangeframe() + theme_tufte()
  }else if(input$theme=="Economist"){
    g=g+ theme_economist()+ scale_colour_economist()
  }else if(input$theme=="Solarized"){
    g=g+ theme_solarized()+ scale_colour_solarized("blue")
  }else if(input$theme=="Stata"){
    g=g+ theme_stata() + scale_colour_stata()
  }else if(input$theme=="Excel 2003"){
    g=g+ theme_excel() + scale_colour_excel()
  }else if(input$theme=="Inverse Gray"){
    g=g+ theme_igray()
  }else if(input$theme=="Fivethirtyeight"){
    g=g+scale_color_fivethirtyeight()+ theme_fivethirtyeight()
  }else if(input$theme=="Tableau"){
    g=g+theme_igray()+ scale_colour_tableau()
  }else if(input$theme=="Stephen"){
    g=g+theme_few()+ scale_colour_few()
  }else if(input$theme=="Wall Street"){
    g=g+theme_wsj()+ scale_colour_wsj("colors6", "")
  }else if(input$theme=="GDocs"){non_param_mann
    g=g+theme_gdocs()+ scale_color_gdocs()
  }else if(input$theme=="Calc"){
    g=g+theme_calc()+ scale_color_calc()
  }else if(input$theme=="Pander"){
    g=g+theme_pander()+ scale_colour_pander()
  }else if(input$theme=="Highcharts"){
    g=g+theme_hc()+ scale_colour_hc()
  }
  return(g)
})

output$vocalnoPlot<-renderPlot({
  g<-getvocalnoPlot()
  print(g)  
},height=600,width="auto")


#download plot option    
output$downloadDataPNG <- downloadHandler(
  filename = function() {
    paste("output", Sys.time(), '.png', sep='')
  },
  
  content = function(file) {
    ggsave(file, getvocalnoPlot(),width = 10, height = 10, units = "in",pointsize=5.2)
  },
  contentType = 'image/png'
)


output$downloadDataPDF <- downloadHandler(
  filename = function() {
    paste("output", Sys.time(), '.pdf', sep='')
  },
  
  content = function(file) {
    ggsave(file, getvocalnoPlot(),width = 10, height = 10, units = "in",pointsize=5.2)
  },
  contentType = 'image/pdf'
)


output$downloadDataTIFF <- downloadHandler(
  filename = function() {
    paste("output", Sys.time(), '.tiff', sep='')
  },
  
  content = function(file) {
    ggsave(file, getvocalnoPlot(),width = 10, height = 10, units = "in",pointsize=5.2)
  },
  contentType = 'image/eps'
)

###

output$matriu_mann <- DT::renderDataTable({
  
  DT::datatable(Univ_analisis()$non_param_mann, 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="mann"),
                                   list(extend="excel",
                                        filename="mann"),
                                   list(extend="pdf",
                                        filename="mann")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = 100))
})

###

output$matriu_kruskal <- DT::renderDataTable({
  
  DT::datatable(Univ_analisis()$non_param_kru, 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="kruskal"),
                                   list(extend="excel",
                                        filename="kruskal"),
                                   list(extend="pdf",
                                        filename="kruskal")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = 100))
})

