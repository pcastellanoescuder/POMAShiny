# This file is part of POMAShiny.

# POMAShiny is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# POMAShiny is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with POMAShiny. If not, see <https://www.gnu.org/licenses/>.

observe_helpers(help_dir = "help_mds")

observe({
  
  if(!is.null(Outliers())){
    
    groups_limma <- SummarizedExperiment::colData(Outliers()$data)
    
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

Univ_analisis <- 
  eventReactive(input$play_uni,
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    data <- Outliers()$data
                    
                    if (input$univariate_test == "ttest"){
                      
                      validate(need(length(levels(as.factor(SummarizedExperiment::colData(data)[,1]))) == 2, 
                                    "Only two groups allowed."))
                      
                      param_ttest <- POMA::PomaUnivariate(data, method = "ttest", 
                                                          paired = input$paired_ttest, var_equal = input$var_ttest)
                      return(list(param_ttest = param_ttest))
                    }
                    
                    else if (input$univariate_test == "anova"){
                      
                      validate(need(length(levels(as.factor(SummarizedExperiment::colData(data)[,1]))) > 2, 
                                    "More than two groups required."))
                      
                      if(ncol(SummarizedExperiment::colData(data)) > 1){
                        
                        param_anova <- POMA::PomaUnivariate(data, method = "anova")
                        param_ancova <- POMA::PomaUnivariate(data, method = "anova", covariates = TRUE)
                        return(list(param_anova = param_anova, param_ancova = param_ancova))
                      }
                      else{
                        
                        param_anova <- POMA::PomaUnivariate(data, method = "anova")
                        return(list(param_anova = param_anova))
                      }

                    }
                    
                    else if (input$univariate_test == "limma"){
                      
                      if(ncol(SummarizedExperiment::colData(data)) > 1){
                        
                        limma_res <- POMA::PomaLimma(data, contrast = input$coef_limma, covariates = FALSE)
                        limma_res_cov <- POMA::PomaLimma(data, contrast = input$coef_limma, covariates = TRUE)
                        return(list(limma_res = limma_res, limma_res_cov = limma_res_cov))
                      }
                      else {
                        
                        limma_res <- POMA::PomaLimma(data, contrast = input$coef_limma, covariates = FALSE)
                        return(list(limma_res = limma_res))
                      }
                      
                    }
                    
                    else if (input$univariate_test == "mann"){
                      
                      validate(need(length(levels(as.factor(SummarizedExperiment::colData(data)[,1]))) == 2,
                                    "Only two groups allowed."))
                      
                      non_param_mann <- POMA::PomaUnivariate(data, method = "mann", paired = input$paired_mann)
                      return(list(non_param_mann = non_param_mann))
                      
                    }
                    
                    else if (input$univariate_test == "kruskal"){
                      
                      validate(need(length(levels(as.factor(SummarizedExperiment::colData(data)[,1]))) > 2, 
                                    "More than two groups required."))
                      
                      non_param_kru <- POMA::PomaUnivariate(data, method = "kruskal")
                      return(list(non_param_kru = non_param_kru))
                    }
                    })
                  })

## OUTPUT - ANOVA ------------------------
output$matriu_anova <- DT::renderDataTable({
  
  param_anova <- Univ_analisis()$param_anova %>% 
    dplyr::mutate_if(is.numeric, ~ signif(., digits = 3))
  
  DT::datatable(param_anova,
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_anova")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_anova")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_anova"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(param_anova)))
})

## OUTPUT - ANCOVA ------------------------
output$matriu_ancova <- DT::renderDataTable({
  
  param_ancova <- Univ_analisis()$param_ancova %>% 
    dplyr::mutate_if(is.numeric, ~ signif(., digits = 3))
  
  DT::datatable(param_ancova,
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_ancova")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_ancova")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_ancova"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(param_ancova)))
})

## OUTPUT - TTEST ------------------------
output$matriu_ttest <- DT::renderDataTable({

  param_ttest <- Univ_analisis()$param_ttest %>% 
    dplyr::mutate_if(is.numeric, ~ signif(., digits = 3))
                
  DT::datatable(param_ttest,
          filter = 'top',extensions = 'Buttons',
          escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
          options = list(
            scrollX = TRUE,
            dom = 'Bfrtip',
            buttons = 
              list("copy", "print", list(
                extend="collection",
                buttons=list(list(extend="csv",
                                  filename=paste0(Sys.Date(), "POMA_ttest")),
                             list(extend="excel",
                                  filename=paste0(Sys.Date(), "POMA_ttest")),
                             list(extend="pdf",
                                  filename=paste0(Sys.Date(), "POMA_ttest"))),
                text="Dowload")),
            order=list(list(2, "desc")),
            pageLength = nrow(param_ttest)))
})

## OUTPUT - MANN ------------------------
output$matriu_mann <- DT::renderDataTable({
  
  non_param_mann <- Univ_analisis()$non_param_mann %>% 
    dplyr::mutate_if(is.numeric, ~ signif(., digits = 3))
    
  DT::datatable(non_param_mann, 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_mann")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_mann")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_mann"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(non_param_mann)))
})

## OUTPUT - KRUSKAL ------------------------
output$matriu_kruskal <- DT::renderDataTable({
  
  non_param_kru <- Univ_analisis()$non_param_kru %>% 
    dplyr::mutate_if(is.numeric, ~ signif(., digits = 3))
  
  DT::datatable(non_param_kru, 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_kruskal")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_kruskal")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_kruskal"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(non_param_kru)))
})

## OUTPUT - LIMMA ------------------------
output$limma <- DT::renderDataTable({
  
  if(!is.null(Univ_analisis()$limma_res)){
    
    limma_res <- Univ_analisis()$limma_res %>%
      dplyr::mutate_if(is.numeric, ~ signif(., digits = 3))
    
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
  }
  
})

## OUTPUT - LIMMA COV ------------------------
output$limma_cov <- DT::renderDataTable({
  
  if(!is.null(Univ_analisis()$limma_res_cov)){
    
    limma_res_cov <- Univ_analisis()$limma_res_cov %>% 
      dplyr::mutate_if(is.numeric, ~ signif(., digits = 3))
    
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
    
  }

})

## OUTPUT - LIMMA VOLCANO ------------------------
output$limma_volcano <- renderPlotly({
  
  limma_res <- Univ_analisis()$limma_res %>% 
    dplyr::mutate_if(is.numeric, ~ signif(., digits = 3))
  
  names <- rownames(SummarizedExperiment::assay(Outliers()$data))
  
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
  
  ggplotly(volcanoP) %>% plotly::config(
    toImageButtonOptions = list(format = "png"),
    displaylogo = FALSE,
    collaborate = FALSE,
    modeBarButtonsToRemove = c(
      "sendDataToCloud", "zoom2d", "select2d",
      "lasso2d", "autoScale2d", "hoverClosestCartesian", "hoverCompareCartesian"
    )
  )
  
})

