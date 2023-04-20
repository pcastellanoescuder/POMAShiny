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

# Outliers <- reactive({
# 
#   if(is.null(NormData())){
#     return(NULL)
# 
#   }
#   else {
# 
#     if(input$remove_outliers){
# 
#       data <- NormData()$normalized
# 
#       data <- POMA::PomaOutliers(data,
#                                  do = "clean",
#                                  method = input$outliers_method,
#                                  type = input$outliers_type,
#                                  coef = input$outlier_coef)
# 
#       norm_table <- SummarizedExperiment::colData(data) %>%
#         as.data.frame() %>% 
#         tibble::rownames_to_column("ID") %>%
#         dplyr::select(1:2) %>%
#         dplyr::bind_cols(as.data.frame(t(SummarizedExperiment::assay(data))))
#     }
#     else {
# 
#       data <- NormData()$normalized
# 
#       norm_table <- SummarizedExperiment::colData(data) %>%
#         as.data.frame() %>% 
#         tibble::rownames_to_column("ID") %>%
#         dplyr::select(1:2) %>%
#         dplyr::bind_cols(as.data.frame(t(SummarizedExperiment::assay(data))))
# 
#     }
# 
#     return(list(data = data, norm_table = norm_table))
#   }
# 
# })
                  
##

OutliersAnalyze <- reactive({
  if(is.null(NormData()$normalized)){
    return(NULL)
  }
  if(!is.null(NormData())){
    data <- NormData()$normalized
    
    outliers_res <- POMA::PomaOutliers(data,
                                       do = "analyze",
                                       method = input$outliers_method,
                                       type = input$outliers_type,
                                       coef = input$outlier_coef,
                                       labels = input$labels_outliers)
    return(outliers_res)
  }
})

# output$polygon_plot <- renderPlot({
#   
#   OutliersAnalyze()$polygon_plot + 
#     theme(text = element_text(size = 16),
#           legend.position = "top",
#           legend.title = element_blank())
# 
# })

##

# output$outliers_boxplot <- renderPlot({
#   
#   OutliersAnalyze()$distance_boxplot + 
#     theme(text = element_text(size = 16),
#           legend.position = "top",
#           legend.title = element_blank())
#   
# })


##

output$outliers_table <- renderDataTable({
  
  out_tab <- OutliersAnalyze()$outliers %>% 
    dplyr::mutate_if(is.numeric, ~round(., 2))
    
  DT::datatable(out_tab,
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_outliers")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_outliers")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_outliers"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(out_tab))
                )
})

