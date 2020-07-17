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

Outliers <- reactive({
  
  if(is.null(NormData())){
    return(NULL)
    
  }
  else {
    
    data <- NormData()$normalized
    
    if(input$remove_outliers){
      
      data <- POMA::PomaOutliers(data, 
                                 do = "clean",
                                 method = input$outliers_method,
                                 type = input$outliers_type,
                                 coef = input$outlier_coef) 
    }
    return(data)
  }
  
})
                  
##

output$polygon_plot <- renderPlotly({
  
  data <- NormData()$normalized
  
  p <- POMA::PomaOutliers(data,
                          do = "analyze",
                          method = input$outliers_method,
                          type = input$outliers_type,
                          coef = input$outlier_coef,
                          labels = input$labels_outliers)$polygon_plot
  
  if(input$labels_outliers){
    p
  } else {
    ggplotly(p)
  }

})

##

output$outliers_boxplot <- renderPlotly({
  
  data <- NormData()$normalized
  
  g <- POMA::PomaOutliers(data,
                          do = "analyze",
                          method = input$outliers_method,
                          type = input$outliers_type,
                          coef = input$outlier_coef,
                          labels = input$labels_outliers)$distance_boxplot
  
  if(input$labels_outliers){
    g
  } else {
    ggplotly(g)
  }
  
})

##

output$outliers_table <- renderDataTable({
  
  data <- NormData()$normalized
  
  out_tab <- POMA::PomaOutliers(data,
                                do = "analyze",
                                method = input$outliers_method,
                                type = input$outliers_type,
                                coef = input$outlier_coef)$outliers
  
  DT::datatable(out_tab, 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_outliers"),
                                   list(extend="excel",
                                        filename="POMA_outliers"),
                                   list(extend="pdf",
                                        filename="POMA_outliers")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(out_tab)))
  
})

