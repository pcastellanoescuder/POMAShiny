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

Limma <- 
  eventReactive(input$play_limma, 
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    data_limma <- NormData()
                    
                    ####
                    
                    if(!is.null(covariatesInput())){
                      covariate_limma <- covariatesInput()
                      colnames(covariate_limma)[1]<-"ID"
                    } else {
                      covariate_limma <- NULL
                    }
                    
  contrasts <- levels(as.factor(data_limma$Group))
  fac1 <- as.factor(data_limma$Group)

  initialmodel <- model.matrix( ~ 0 + fac1)
  colnames(initialmodel) <- contrasts

  cont.matrix <- limma::makeContrasts(contrasts = paste0(input$group1,"-",input$group2), 
                               levels = initialmodel)
  
  trans_limma <- t(data_limma[,c(3:ncol(data_limma))]) 
  model <- lmFit(trans_limma, initialmodel)
  
  model <- contrasts.fit(model, cont.matrix)
  
  modelstats <- eBayes(model)
  res <- topTable(modelstats, number = ncol(data_limma) , 
                  coef = paste0(input$group1,"-",input$group2), 
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
  
  if(!is.null(covariate_limma)){
    
    form <- as.formula(noquote(paste("~ 0 + fac1 + ", paste(colnames(covariate_limma)[2:length(covariate_limma)], 
                                                            collapse = " + ", sep=""), sep = "")))
    initialmodel2 <- model.matrix(form , covariate_limma)
    colnames(initialmodel2)[1:length(levels(fac1))] <- contrasts
    
    cont.matrix2 <- limma::makeContrasts(contrasts = paste0(input$group1,"-",input$group2), 
                                        levels = initialmodel2)
    
    trans_limma2 <- t(data_limma[,c(3:ncol(data_limma))]) 
    model2 <- lmFit(trans_limma2, initialmodel2)
    
    model2 <- contrasts.fit(model2, cont.matrix2)
    
    modelstats2 <- eBayes(model2)
    res2 <- topTable(modelstats2, number= ncol(data_limma) , coef = paste0(input$group1,"-",input$group2), 
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
                  })
})

######

output$matriu <- DT::renderDataTable({
  
  res <- Limma()$res
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
                 pageLength = nrow(Limma()$res)))
})

output$matriu_cov <- DT::renderDataTable({
  
  res2 <- Limma()$res2
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
                 pageLength = nrow(Limma()$res2)))
})

