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

DataExists <- reactive({
  if(is.null(prepareData()$prepared_data)){
    return(NULL)
  } else {
    data <- prepareData()$prepared_data
    return(data)
  }
})

ImputedData <- 
  eventReactive(input$process,
                ignoreNULL = TRUE, {
                  withProgress(message = "Imputing data, please wait",{
                    
                    if(is.null(DataExists())){
                      return(NULL)
                    } else{
                     
                      data <- prepareData()$poma_object
                      
                      imputed <- POMA::PomaImpute(data, 
                                                  ZerosAsNA = ifelse(input$ZerosAsNA == "yes", TRUE, FALSE),
                                                  RemoveNA = ifelse(input$RemoveNA == "yes", TRUE, FALSE),
                                                  cutoff = input$cutoff_imp,
                                                  method = input$imputation_method)
                      
                      imputed_table <- SummarizedExperiment::colData(imputed) %>%
                        as.data.frame() %>% 
                        tibble::rownames_to_column("ID") %>%
                        dplyr::select(1:2) %>%
                        dplyr::bind_cols(as.data.frame(t(SummarizedExperiment::assay(imputed))))
                      
                      return(list(imputed = imputed, imputed_table = imputed_table))
                      
                    }
                    
                    })
                  })

## OUTPUT - RAW DATA ------------------------
output$raw <- renderDataTable({
  
  datatable(DataExists(),
            class = 'cell-border stripe', rownames = FALSE, options = list(scrollX = TRUE))
  
})

## OUTPUT - IMPUTED DATA ------------------------
output$imputed <- DT::renderDataTable({
  
  if (!is.null(ImputedData()$imputed_table)) {
    imputed_table <- ImputedData()$imputed_table %>% 
      as.data.frame() %>% 
      dplyr::mutate_if(is.numeric, ~ signif(., digits = 3))
  } else {
    imputed_table <- NULL
  }
  
  DT::datatable(imputed_table,
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_imputed")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_imputed")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_imputed"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(imputed_table)
                  ))
})

