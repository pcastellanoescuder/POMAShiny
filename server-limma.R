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
  
  if(!is.null(NormData())){
    
    groups_limma <- Biobase::pData(NormData()$normalized)[,1]
    
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

                    data <- NormData()$normalized

                    if(!is.null(covariatesInput())){

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
  
  limma_res <- Limma()$limma_res
  
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
                                       filename="POMA_limma"),
                                  list(extend="excel",
                                       filename="POMA_limma"),
                                  list(extend="pdf",
                                       filename="POMA_limma")),
                     text="Dowload")),
                 order=list(list(2, "desc")),
                 pageLength = nrow(limma_res)))
})

##

output$limma_cov <- DT::renderDataTable({
  
  limma_res_cov <- Limma()$limma_res_cov
  
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
                                       filename="POMA_limma_covariates"),
                                  list(extend="excel",
                                       filename="POMA_limma_covariates"),
                                  list(extend="pdf",
                                       filename="POMA_limma_covariates")),
                     text="Dowload")),
                 order=list(list(2, "desc")),
                 pageLength = nrow(limma_res_cov)))
})

