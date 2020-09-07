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

Outliers <- reactive({
  
  if(is.null(NormData())){
    return(NULL)
    
  }
  else {
    
    if(input$remove_outliers){
      
      data <- NormData()$normalized
      
      data <- POMA::PomaOutliers(data, 
                                 do = "clean",
                                 method = input$outliers_method,
                                 type = input$outliers_type,
                                 coef = input$outlier_coef) 
      
      mytarget <- pData(data)[1] %>% 
        rownames_to_column("ID")
      norm_table <- bind_cols(mytarget, as.data.frame(round(t(exprs(data)), 3)))
    } 
    else {
      
      data <- NormData()$normalized
      
      mytarget <- pData(data)[1] %>% 
        rownames_to_column("ID")
      norm_table <- bind_cols(mytarget, as.data.frame(round(t(exprs(data)), 3)))
      
    }
    
    return(list(data = data, norm_table = norm_table))
  }
  
})
                  
##

output$polygon_plot <- renderPlot({
  
  data <- NormData()$normalized
  
  POMA::PomaOutliers(data,
                     do = "analyze",
                     method = input$outliers_method,
                     type = input$outliers_type,
                     coef = input$outlier_coef,
                     labels = input$labels_outliers)$polygon_plot + theme(text = element_text(size = 16),
                                                                          legend.position = "top",
                                                                          legend.title = element_blank())
  

})

##

output$outliers_boxplot <- renderPlot({
  
  data <- NormData()$normalized
  
  POMA::PomaOutliers(data,
                     do = "analyze",
                     method = input$outliers_method,
                     type = input$outliers_type,
                     coef = input$outlier_coef,
                     labels = input$labels_outliers)$distance_boxplot + theme(text = element_text(size = 16),
                                                                              legend.position = "top",
                                                                              legend.title = element_blank())

})

##

output$outliers_table <- renderDataTable({
  
  data <- NormData()$normalized
  
  out_tab <- POMA::PomaOutliers(data,
                                do = "analyze",
                                method = input$outliers_method,
                                type = input$outliers_type,
                                coef = input$outlier_coef)$outliers
  out_tab <- out_tab %>%
    mutate(distance_to_centroid = round(distance_to_centroid, 3),
           limit_distance = round(limit_distance, 3))
    
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
                  pageLength = nrow(out_tab)))
  
})

