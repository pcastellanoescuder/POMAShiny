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
  DT::datatable(p2,
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_anova"),
                                   list(extend="excel",
                                        filename="POMA_anova"),
                                   list(extend="pdf",
                                        filename="POMA_anova")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Univ_analisis()$p2)))
})

output$matriu_anova_cov <- DT::renderDataTable({
  
  p3 <- Univ_analisis()$p3
  DT::datatable(p3,
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_anova_covariates"),
                                   list(extend="excel",
                                        filename="POMA_anova_covariates"),
                                   list(extend="pdf",
                                        filename="POMA_anova_covariates")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Univ_analisis()$p3)))
})

output$matriu2 <- DT::renderDataTable({

        p <- Univ_analisis()$p
                
        DT::datatable(p,
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_ttest"),
                                   list(extend="excel",
                                        filename="POMA_ttest"),
                                   list(extend="pdf",
                                        filename="POMA_ttest")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Univ_analisis()$p)))
})

###

output$matriu_mann <- DT::renderDataTable({
  
  non_param_mann <- Univ_analisis()$non_param_mann
    
  DT::datatable(non_param_mann, 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_mann_whitney"),
                                   list(extend="excel",
                                        filename="POMA_mann_whitney"),
                                   list(extend="pdf",
                                        filename="POMA_mann_whitney")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Univ_analisis()$non_param_mann)))
})

###

output$matriu_kruskal <- DT::renderDataTable({
  
  non_param_kru <- Univ_analisis()$non_param_kru
  
  DT::datatable(non_param_kru, 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_kruskal_wallis"),
                                   list(extend="excel",
                                        filename="POMA_kruskal_wallis"),
                                   list(extend="pdf",
                                        filename="POMA_kruskal_wallis")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Univ_analisis()$non_param_kru)))
})

