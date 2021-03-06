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
  }
  else{
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
                    }
                    else{
                     
                      data <- prepareData()$data
                      
                      if(input$ZerosAsNA == "yes"){
                        ZerosAsNAX <- TRUE
                      } else {
                        ZerosAsNAX <- FALSE
                      }
                      
                      if(input$RemoveNA == "yes"){
                        RemoveNAX <- TRUE
                      } else {
                        RemoveNAX <- FALSE
                      }
                      
                      imputed <- POMA::PomaImpute(data, 
                                                  ZerosAsNA = ZerosAsNAX,
                                                  RemoveNA = RemoveNAX,
                                                  cutoff = input$cutoff_imp,
                                                  method = input$imputation_method)
                      
                      mytarget <- pData(imputed)[1] %>% rownames_to_column("ID")
                      imputed_table <- cbind(mytarget, as.data.frame(round(t(exprs(imputed)), 3)))
                      
                      return(list(imputed = imputed, imputed_table = imputed_table))
                      
                    }
                    
                    })
                  })

#################

output$raw <- renderDataTable({
  
  datatable(DataExists(), class = 'cell-border stripe', rownames = FALSE, options = list(scrollX = TRUE))
  
  })

##

output$imputed <- DT::renderDataTable({
  
  imputed_table <- ImputedData()$imputed_table
  
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

