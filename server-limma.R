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

observe({
  
  if(!is.null(Outliers())){
    
    groups_limma <- Biobase::pData(Outliers()$data)[1]
    
    contrasts <- levels(as.factor(groups_limma[,1]))
    combinations <- expand.grid(contrasts, contrasts)
    combinations <- combinations[!(combinations$Var1 == combinations$Var2),]
    combinations <- combinations[!duplicated(t(apply(combinations[c("Var1", "Var2")], 1, sort))), ]
    
    combinationNames <- c()
    
    for (i in 1:nrow(combinations)){
      combinationNames[i] <- paste0(combinations$Var1[i],"-",combinations$Var2[i])
    }
    
    updateSelectInput(session,"coef_limma", choices = combinationNames, selected = combinationNames[1])
    
  }
  
})
 
Limma <-
  eventReactive(input$play_limma,
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{

                    data <- Outliers()$data

                    if(ncol(Biobase::pData(data)) > 1){

                      limma_res <- POMA::PomaLimma(data, contrast = input$coef_limma, covariates = FALSE)
                      limma_res_cov <- POMA::PomaLimma(data, contrast = input$coef_limma, covariates = TRUE)
                      return(list(limma_res = limma_res, limma_res_cov = limma_res_cov))
                    }
                    else{

                      limma_res <- POMA::PomaLimma(data, contrast = input$coef_limma, covariates = FALSE)
                      return(list(limma_res = limma_res))
                    }

                  })
})

######

output$limma <- DT::renderDataTable({
  
  limma_res <- Limma()$limma_res %>%
    mutate(logFC = round(logFC, 3),
           AveExpr = round(AveExpr, 3),
           t = round(t, 3),
           B = round(B, 3))
  
  DT::datatable(limma_res,
               filter = 'top',extensions = 'Buttons',
               escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
               options = list(
                 scrollX = TRUE,
                 dom = 'Bfrtip',
                 buttons = 
                   list("copy", "print", list(
                     extend="collection",
                     buttons=list(list(extend="csv",
                                       filename=paste0(Sys.Date(), "POMA_limma")),
                                  list(extend="excel",
                                       filename=paste0(Sys.Date(), "POMA_limma")),
                                  list(extend="pdf",
                                       filename=paste0(Sys.Date(), "POMA_limma"))),
                     text="Dowload")),
                 order=list(list(2, "desc")),
                 pageLength = nrow(limma_res)))
})

##

output$limma_cov <- DT::renderDataTable({
  
  limma_res_cov <- Limma()$limma_res_cov %>%
    mutate(logFC = round(logFC, 3),
           AveExpr = round(AveExpr, 3),
           t = round(t, 3),
           B = round(B, 3))
  
  DT::datatable(limma_res_cov,
               filter = 'top',extensions = 'Buttons',
               escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
               options = list(
                 scrollX = TRUE,
                 dom = 'Bfrtip',
                 buttons = 
                   list("copy", "print", list(
                     extend="collection",
                     buttons=list(list(extend="csv",
                                       filename=paste0(Sys.Date(), "POMA_limma_covariates")),
                                  list(extend="excel",
                                       filename=paste0(Sys.Date(), "POMA_limma_covariates")),
                                  list(extend="pdf",
                                       filename=paste0(Sys.Date(), "POMA_limma_covariates"))),
                     text="Dowload")),
                 order=list(list(2, "desc")),
                 pageLength = nrow(limma_res_cov)))
})

##

output$limma_volcano <- renderPlotly({
  
  limma_res <- Limma()$limma_res 
  names <- featureNames(Outliers()$data)
  
  if (input$pval_limma == "raw") {
    df <- data.frame(pvalue = limma_res$P.Value, FC = limma_res$logFC, names = names)
  }
  else {
    df <- data.frame(pvalue = limma_res$adj.P.Val, FC = limma_res$logFC, names = names)
  }
  
  df <- mutate(df, threshold = as.factor(ifelse(df$pvalue >= input$pval_cutoff_limma, 
                                                yes = "none", no = ifelse(df$FC < input$log2FC_limma, 
                                                                          yes = ifelse(df$FC < -input$log2FC_limma, yes = "Down-regulated", 
                                                                                       no = "none"), no = "Up-regulated"))))
  
  volcanoP <- ggplot(data = df, aes(x = FC, y = -log10(pvalue), colour = threshold, label = names)) + 
    geom_point(size = 1.75) + 
    xlim(c(-(input$xlim_limma), input$xlim_limma)) + 
    xlab("log2 Fold Change") + 
    ylab("-log10 p-value") + 
    scale_y_continuous(trans = "log1p") +
    geom_vline(xintercept = -input$log2FC_limma, colour = "black", linetype = "dashed") + 
    geom_vline(xintercept = input$log2FC_limma, colour = "black", linetype = "dashed") + 
    geom_hline(yintercept = -log10(input$pval_cutoff_limma), colour = "black", linetype = "dashed") +
    theme(legend.position = "none") + 
    labs(color = "") + 
    theme_bw() + 
    scale_color_manual(values = c(`Down-regulated` = "#E64B35", `Up-regulated` = "#3182bd", none = "#636363"))
  
  ggplotly(volcanoP)
  
})

