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
                              
                              if (input$univariate_test == "ttest"){

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
                                
                              
                            }) 
                          })

####

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

