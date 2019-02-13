observe_helpers(help_dir = "help_mds")

Limma <- reactive({
  
  data_uni <- NormData()
  
  contrasts <- levels(as.factor(data_uni$Group))
  combinations <- expand.grid(contrasts, contrasts)
  combinations <- combinations[!(combinations$Var1 == combinations$Var2),]
  combinations <- combinations[order(combinations$Var1),]
  combinations <- combinations[c(1:(nrow(combinations)/2)),]
  
  com_names <- c()
  
  for (i in 1:nrow(combinations)){
    com_names[i] <- paste0(combinations$Var1[i],"-",combinations$Var2[i])
  }
  
  updateSelectInput(session,"coef_limma", choices = com_names, selected = com_names[1])
  
  return(com_names)

})

Univ_analisis <- 
  eventReactive(input$play_test, 
                               ignoreNULL = TRUE, {
                                 withProgress(message = "Please wait",{
                                   
                              data_uni <- NormData()
                              
                              ####
                              
                              if(!is.null(covariatesInput())){
                                covariate_uni <- covariatesInput()
                                colnames(covariate_uni)[1]<-"ID"
                              } else {
                                covariate_uni <- NULL
                                }

                              
                              if (input$univariate_test == "limma"){
                                
                                fac1 <- as.factor(data_uni$Group)
                                
                                #contrasts <- Limma()$contrasts
                                com_names <- Limma()
                                
                                my_coef_index <- which(com_names == input$coef_limma)
                                com_names <- com_names[my_coef_index]

                                initialmodel <- model.matrix( ~ 0 + fac1)
                                colnames(initialmodel) <- contrasts
                                
                                cont.matrix <- makeContrasts(as.character(com_names), 
                                                             levels = initialmodel)

                                trans_limma <- t(data_uni[,c(3:ncol(data_uni))]) 
                                model <- lmFit(trans_limma, initialmodel)
                                
                                model <- contrasts.fit(model, cont.matrix)
                                
                                modelstats <- eBayes(model)
                                res <- topTable(modelstats, number = ncol(data_uni) , 
                                                coef = 1,
                                                sort.by = "p")
                                
                                metabolite_name <- rownames(res)
                                logFC <- round(res$logFC,3)
                                AveExpr <- round(res$AveExpr,3)
                                t <- round(res$t,3)
                                B <- round(res$B,3)
                                P.Value <- res$P.Value
                                adj.P.Val <- res$adj.P.Val
                                
                                res <- as.data.frame(cbind(logFC, AveExpr, t, B, P.Value, adj.P.Val))
                                
                                rownames(res) <- metabolite_name

                                ####
                                
                                if(!is.null(covariate_uni)){
                                
                              
                                form <- as.formula(noquote(paste("~ 0 + fac1 + ", paste(colnames(covariate_uni)[2:length(covariate_uni)], 
                                                                                    collapse = " + ", sep=""), sep = "")))
                                
                                initialmodel2 <- model.matrix(form , covariate_uni)
                                trans_limma2 <- t(data_uni[,c(3:ncol(data_uni))]) 
                                model2 <- lmFit(trans_limma2, initialmodel2)
                                modelstats2 <- eBayes(model2)
                                res2 <- topTable(modelstats2, number= ncol(data_uni) , coef = 1,
                                                 sort.by = "p")
                                
                                metabolite_name2 <- rownames(res2)
                                logFC_cov <- round(res2$logFC,3)
                                AveExpr_cov <- round(res2$AveExpr,3)
                                t_cov <- round(res2$t,3)
                                B_cov <- round(res2$B,3)
                                P.Value_cov <- res2$P.Value
                                adj.P.Val_cov <- res2$adj.P.Val
                                
                                res2 <- as.data.frame(cbind(logFC = logFC_cov, AveExpr = AveExpr_cov, t = t_cov, 
                                              B = B_cov, P.Value = P.Value_cov, adj.P.Val = adj.P.Val_cov))
                                rownames(res2) <- metabolite_name2
                                  
                                } else {
                                  res2<- NULL
                                }
                                
                                table1<-list(res=res, res2=res2)
                                return(table1)
                                }
                              
                              else if (input$univariate_test == "ttest"){

                                Group <- data_uni$Group
                                
                                if (input$paired == "FALSE"){
                                  
                                 stat <- function(x){t.test(x ~ Group, na.rm=TRUE, alternative=c("two.sided"),
                                                           var.equal = eval(parse(text = input$variance)))$p.value}
                                }
                                else{
                                  stat <- function(x){t.test(x ~ Group, na.rm=TRUE, alternative=c("two.sided"),
                                                             var.equal = eval(parse(text = input$variance)),
                                                             paired = TRUE)$p.value}
                                }
                                
                                stat_G2 <- function(x){t.test(x ~ Group, na.rm=TRUE, alternative=c("two.sided"),
                                                              var.equal = eval(parse(text = input$variance)))$estimate[[2]]}
                                stat_G1 <- function(x){t.test(x ~ Group, na.rm=TRUE, alternative=c("two.sided"),
                                                              var.equal = eval(parse(text = input$variance)))$estimate[[1]]}
                                
                                
                                p <- as.data.frame(apply(FUN=stat, MARGIN = 2, X = data_uni[,c(3:ncol(data_uni))] ))
                                colnames(p) <- c("P.Value")
                                p$adj.P.Val <- p.adjust(p$P.Value, method = "fdr")
                                G2 <- round(as.data.frame(apply(FUN=stat_G2, MARGIN = 2, X = data_uni[,c(3:ncol(data_uni))] )),3)
                                colnames(G2) <- c("Mean G2")
                                G1 <- round(as.data.frame(apply(FUN=stat_G1, MARGIN = 2, X = data_uni[,c(3:ncol(data_uni))] )),3)
                                colnames(G1) <- c("Mean G1")
                                FC <- round(data.frame(G2/G1),3)
                                colnames(FC) <- c("FC (Ratio)")
                                DM <- round(data.frame(G1-G2),3)
                                colnames(DM) <- c("Difference of Means")
                                
                                p <- cbind(G1,G2, FC, DM, p)
                
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
                                
                                non_param_mann <- as.data.frame(apply(data_uni[,3:ncol(data_uni)],2,
                                                                      function(x){wilcox.test(x ~ as.factor(Group),
                                                                                              paired = eval(parse(text = input$paired2)))$p.value}))
                                
                                colnames(non_param_mann) <- c("P.Value")
                                non_param_mann$adj.P.Val <- p.adjust(non_param_mann$P.Value, method = "fdr")
                                
                                means <- data_uni %>%
                                  group_by(Group) %>%
                                  summarise_at(vars(names(data_uni[3:ncol(data_uni)])), mean)
                                
                                rownames(means) <- means$Group
                                means$Group <- NULL
                                means <- as.data.frame(t(means))
                                colnames(means) <- c("Mean G1", "Mean G2") 
                                means$FC <- as.numeric(round(means$`Mean G2`/means$`Mean G1`,3))
                                means$DM <- as.numeric(round(means$`Mean G1`- means$`Mean G2`,3))
                                
                                colnames(means)[3:4] <- c("FC (Ratio)",  "Difference of Means")
                                
                                non_param_mann <- merge(round(means,3), non_param_mann, by = "row.names")
                                
                                rownames(non_param_mann) <- non_param_mann$Row.names
                                non_param_mann$Row.names <- NULL
                                
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
  
  res <- Univ_analisis()$res
  as.datatable(formattable(res, list(P.Value = color_tile("#90AFC5","white"),
                                                adj.P.Val = color_tile("#90AFC5","white"))), 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
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
                  pageLength = nrow(Univ_analisis()$res)))
})


output$matriu_cov <- DT::renderDataTable({
  
  res2 <- Univ_analisis()$res2
  as.datatable(formattable(res2, list(P.Value = color_tile("#90AFC5","white"),
                                     adj.P.Val = color_tile("#90AFC5","white"))), 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
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
                  pageLength = nrow(Univ_analisis()$res2)))
})


output$matriu_anova <- DT::renderDataTable({
  
  p2 <- Univ_analisis()$p2
  as.datatable(formattable(p2, list(P.Value = color_tile("#90AFC5","white"),
                                     adj.P.Val = color_tile("#90AFC5","white"))), 
                 filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
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
                  pageLength = nrow(Univ_analisis()$p2)))
})


output$matriu_anova_cov <- DT::renderDataTable({
  
  p3 <- Univ_analisis()$p3
  as.datatable(formattable(p3, list(P.Value = color_tile("#90AFC5","white"),
                                    adj.P.Val = color_tile("#90AFC5","white"))), 
                 filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
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
                  pageLength = nrow(Univ_analisis()$p3)))
})


output$matriu2 <- DT::renderDataTable({

                p <- Univ_analisis()$p
                
                as.datatable(formattable(p, list(P.Value = color_tile("#90AFC5","white"),
                                                              adj.P.Val = color_tile("#90AFC5","white"))), 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
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
                  pageLength = nrow(Univ_analisis()$p)))
})


###################################################
## VOLCANO PLOT ###################################
###################################################

plotdataInput<-reactive({

  to_volcano <- DataExists2()
  samples_groups <- to_volcano[,1:2]
  to_volcano1 <- to_volcano[,c(3:ncol(to_volcano))]
  to_volcano <- to_volcano1[,apply(to_volcano1,2,function(x) !all(x==0))] 
  to_volcano1 <- round(to_volcano1,3)
  to_volcano <-cbind(samples_groups,to_volcano1)
  
  Group2 <- to_volcano[,2]
  
  if (input$paired == "FALSE"){
    
  to_volcanostat <- function(x){t.test(x ~ Group2, na.rm=TRUE, alternative=c("two.sided"),
                                       var.equal = eval(parse(text = input$variance)))$p.value}
  }
  else{
    to_volcanostat <- function(x){t.test(x ~ Group2, na.rm=TRUE, alternative=c("two.sided"),
                                         var.equal = eval(parse(text = input$variance)),
                                         paired = TRUE)$p.value}
  }
  
  to_volcanostat_G2 <- function(x){t.test(x ~ Group2, na.rm=TRUE, alternative=c("two.sided"),
                                          var.equal = eval(parse(text = input$variance)))$estimate[[2]]}
  to_volcanostat_G1 <- function(x){t.test(x ~ Group2, na.rm=TRUE, alternative=c("two.sided"),
                                          var.equal = eval(parse(text = input$variance)))$estimate[[1]]}
  
  to_volcano <- as.data.frame(apply(FUN=to_volcanostat, MARGIN = 2, X = to_volcano1))
  colnames(to_volcano) <- c("P.Value")
  to_volcano$adj.P.Val <- p.adjust(to_volcano$P.Value, method = "fdr")
  to_volcanoG2 <- round(as.data.frame(apply(FUN=to_volcanostat_G2, MARGIN = 2, X = to_volcano1)),3)
  colnames(to_volcanoG2) <- c("Mean G2")
  to_volcanoG1 <- round(as.data.frame(apply(FUN=to_volcanostat_G1, MARGIN = 2, X = to_volcano1)),3)
  colnames(to_volcanoG1) <- c("Mean G1")
  to_volcanoFC <- round(data.frame(to_volcanoG2/to_volcanoG1),3)
  colnames(to_volcanoFC) <- c("FC")
  
  a <- cbind(to_volcanoG1,to_volcanoG2, to_volcanoFC, to_volcano)

  ####
  
  P.Value <- a[,4]
  FC<-a[,3]
  names <- rownames(a) 
  df <- data.frame(P.Value, FC, names) 
  
  df <- mutate(df,threshold = as.factor(ifelse(df$P.Value >= input$pcut, 
                                     yes = "none", 
                                     no = ifelse(df$FC < input$FCcut, 
                                                 yes = ifelse(log2(df$FC) < -log2(input$FCcut), 
                                                             yes = "Down-regulated",
                                                             no = "none"),
                                                 no = "Up-regulated"))))
                              })

# output upload dataset or example dataset  

#plotfunction
getvocalnoPlot<-reactive({

  df<-plotdataInput()
  g <- ggplot(data=df, aes(x=log2(FC), y=-log10(P.Value), colour=threshold)) +
    geom_point( size=1.75) +
    xlim(c(-(input$xlmslider), input$xlmslider)) +
    xlab("log2 fold change") + ylab("-log10 p-value")+
    scale_y_continuous(trans = "log1p")+
    ggtitle("Comparisson: Group2/Group1") +
    geom_text(
      data = df[df$P.Value < input$pcut & (df$FC > input$FCcut | log2(df$FC) < -log2(input$FCcut)),],
      aes(x = log2(FC), y = -log10(P.Value)+0.12, label = names),
      hjust = 1,
      vjust = 2
    ) +
    geom_vline(xintercept = -log2(input$FCcut), colour = "black") + 
    geom_vline(xintercept = log2(input$FCcut), colour = "black") + 
    geom_hline(yintercept = -log10(input$pcut), colour = "black") 
  if(input$theme=="default"){
    g=g+theme(legend.position = "none")+ theme_minimal()+scale_color_manual(values = c("Down-regulated" = "#E64B35", 
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
  
  g <- ggplotly(g)
  return(g)
})

output$vocalnoPlot<-renderPlotly({
  getvocalnoPlot()

})


###

output$matriu_mann <- DT::renderDataTable({
  
  non_param_mann <- Univ_analisis()$non_param_mann
    
  as.datatable(formattable(non_param_mann, list(P.Value = color_tile("#90AFC5","white"),
                                               adj.P.Val = color_tile("#90AFC5","white"))), 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="mann_whitney"),
                                   list(extend="excel",
                                        filename="mann_whitney"),
                                   list(extend="pdf",
                                        filename="mann_whitney")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Univ_analisis()$non_param_mann)))
})

###

output$matriu_kruskal <- DT::renderDataTable({
  
  non_param_kru <- Univ_analisis()$non_param_kru
  
  as.datatable(formattable(non_param_kru, list(P.Value = color_tile("#90AFC5","white"),
                                               adj.P.Val = color_tile("#90AFC5","white"))), 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="kruskal_wallis"),
                                   list(extend="excel",
                                        filename="kruskal_wallis"),
                                   list(extend="pdf",
                                        filename="kruskal_wallis")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Univ_analisis()$non_param_kru)))
})

