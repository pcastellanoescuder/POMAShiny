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

DataExists2 <- reactive({
  if(is.null(ImputedData()$imputed_table)){
    return(NULL)
  }
  if(!is.null(ImputedData())){
    data <- ImputedData()$imputed_table
    return(data)
  }
})

##

NormData <- 
  eventReactive(input$norm_data,
                ignoreNULL = TRUE, {
                  withProgress(message = "Normalizing data, please wait",{
                    
                    if(is.null(DataExists2())){
                      return(NULL)
                    }
                    else{
                      
                      imputed <- ImputedData()$imputed
                      
                      normalized <- POMA::PomaNorm(imputed, method = input$normalization_method, round = 3)
                      
                      mytarget <- pData(normalized)[1] %>% rownames_to_column("ID")
                      norm_table <- cbind(mytarget, as.data.frame(round(t(exprs(normalized)), 3)))
                      
                      return(list(normalized = normalized, norm_table = norm_table))
                      
                    }

                    })
                  })

 
#################

output$input_normalized <- renderDataTable({
  datatable(DataExists2(), class = 'cell-border stripe', rownames = FALSE, options = list(scrollX = TRUE))
  })

##

output$normalized <- DT::renderDataTable({
  
  norm_table <- NormData()$norm_table

  DT::datatable(norm_table,
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = list(list(extend="csv",
                                      filename=paste0(Sys.Date(), "POMA_normalized")),
                                 list(extend="excel",
                                      filename=paste0(Sys.Date(), "POMA_normalized")),
                                 list(extend="pdf",
                                      filename=paste0(Sys.Date(), "POMA_normalized"))),
                  text="Dowload",
                  order=list(list(2, "desc")),
                  pageLength = nrow(norm_table)
                ))
  })

##

output$norm_plot1 <- renderPlotly({
  
  imputed <- ImputedData()$imputed
  ggplotly(POMA::PomaBoxplots(imputed, jitter = input$jitNorm) + theme(legend.title = element_blank()))
  
})

##

output$norm_plot2 <- renderPlotly({
  
  normalized <- NormData()$normalized
  ggplotly(POMA::PomaBoxplots(normalized, jitter = input$jitNorm) + theme(legend.title = element_blank()))
  
})

