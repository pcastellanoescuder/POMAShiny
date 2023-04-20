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

DataExists2 <- reactive({
  if(is.null(ImputedData()$imputed_table)){
    return(NULL)
  }
  if(!is.null(ImputedData())){
    data <- ImputedData()$imputed_table
    return(data)
  }
})

NormData <- 
  eventReactive(input$norm_data,
                ignoreNULL = TRUE, {
                  withProgress(message = "Normalizing data, please wait",{
                    
                    if(is.null(DataExists2())){
                      return(NULL)
                    }
                    else {
                      
                      imputed <- ImputedData()$imputed
                      
                      normalized <- POMA::PomaNorm(imputed,
                                                   sample_norm = input$sample_norm,
                                                   method = input$normalization_method, 
                                                   round = 3)
                      
                      norm_table <- SummarizedExperiment::colData(normalized) %>%
                        as.data.frame() %>% 
                        tibble::rownames_to_column("ID") %>%
                        dplyr::select(1:2) %>%
                        dplyr::bind_cols(as.data.frame(t(SummarizedExperiment::assay(normalized))))
                      
                      return(list(normalized = normalized, norm_table = norm_table))
                      
                    }

                    })
                  })

## OUTPUT - IMPUTED DATA ------------------------
output$input_normalized <- renderDataTable({
  
  datatable(DataExists2(),
            class = 'cell-border stripe', rownames = FALSE, options = list(scrollX = TRUE))
  
})

## OUTPUT - NORMALIZED DATA ------------------------
output$normalized <- DT::renderDataTable({
  
  if (!is.null(NormData()$norm_table)) {
    norm_table <- NormData()$norm_table %>% 
      as.data.frame() %>% 
      dplyr::mutate_if(is.numeric, ~ signif(., digits = 3))
  } else {
    norm_table <- NULL
  }
  
  DT::datatable(norm_table,
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_normalized")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_normalized")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_normalized"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(norm_table)
                ))
})

## OUTPUT - RAW BOXPLOT ------------------------
output$norm_plot1 <- renderPlotly({

  imputed <- ImputedData()$imputed
  ggplotly(POMA::PomaBoxplots(imputed, jitter = input$jitNorm) + 
             theme(legend.title = element_blank(),
                   axis.title.y = element_blank())) %>% 
    plotly::config(
      toImageButtonOptions = list(format = "png"),
      displaylogo = FALSE,
      collaborate = FALSE,
      modeBarButtonsToRemove = c(
        "sendDataToCloud", "zoom2d", "select2d",
        "lasso2d", "autoScale2d", "hoverClosestCartesian", "hoverCompareCartesian"
    )
  )
})

## OUTPUT - NORMALIZED BOXPLOT ------------------------
output$norm_plot2 <- renderPlotly({

  normalized <- NormData()$normalized
  ggplotly(POMA::PomaBoxplots(normalized, jitter = input$jitNorm) + 
             theme(legend.title = element_blank(),
                   axis.title.y = element_blank())) %>% 
    plotly::config(
      toImageButtonOptions = list(format = "png"),
      displaylogo = FALSE,
      collaborate = FALSE,
      modeBarButtonsToRemove = c(
        "sendDataToCloud", "zoom2d", "select2d",
        "lasso2d", "autoScale2d", "hoverClosestCartesian", "hoverCompareCartesian"
    )
  )
})

