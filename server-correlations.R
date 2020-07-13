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
  if(!is.null(NormData()$norm_table)){
    
    data <- NormData()$norm_table %>% select(-1,-2)
    
    x <- colnames(data)
    
    y <- colnames(pData(NormData()$normalized)[1])
    
    updateSelectInput(session, "one", choices = x, selected = x[1])
    updateSelectInput(session, "two", choices = x, selected = x[2])
    
    updateSelectInput(session, "my_factor", choices = c("None", y), selected = "None")
  }
})

Createdata <- reactive({
  
  if(is.null(NormData()$norm_table)){
    return(NULL)
  } 
  else{
    
    data <- NormData()$norm_table
    
    code <- as.data.frame(data[, 1])
    data_subset1 <- as.data.frame(data[, colnames(data) == as.character(input$one)])
    data_subset2 <- as.data.frame(data[, colnames(data) == as.character(input$two)])
    
    if(input$my_factor != "None"){
      
      data_subset3 <- as.data.frame(data[, colnames(data) == as.character(input$my_factor)])
      data_subset <- bind_cols(code, data_subset1, data_subset2, data_subset3)
      colnames(data_subset) <- c("ID", "Variable1", "Variable2", "Factor")
      
    } else{
      
      data_subset <- bind_cols(code, data_subset1, data_subset2)
      colnames(data_subset) <- c("ID", "Variable1", "Variable2")
    }
    
    vals <- reactiveValues(keeprows = rep(TRUE, nrow(data_subset)))
    
    return(list(data_subset = data_subset, vals = vals))
    
  }
})

output$cor_plot <- renderPlot({
  
  data_subset <- Createdata()$data_subset
  vals <- Createdata()$vals
  
  keep <- data_subset[vals$keeprows, , drop = FALSE]
  exclude <- data_subset[!vals$keeprows, , drop = FALSE]
  
  if(input$my_factor != "None"){
    
    cors <- plyr::ddply(keep, c("Factor"), summarise, cor = round(cor(Variable1, Variable2, use = "complete.obs"), 2))

  }
  
  ggplot(keep) + 
    {if(input$my_factor == "None")geom_point(aes(x = Variable1, y = Variable2, label = ID), alpha = 0.75, size = 3)} +
    {if(input$my_factor != "None")geom_point(aes(x = Variable1, y = Variable2, color = Factor, shape = Factor, label = ID), alpha = 0.75, size = 3)} +
    
    geom_point(data = exclude, aes(x = Variable1, y = Variable2, label = ID), shape = 21, fill = NA, color = "black", alpha = 0.25, size = 3) +
    
    xlab(as.character(input$one)) + 
    ylab(as.character(input$two)) + 
    {if(!isTRUE(input$facet_factor))geom_text(aes(label = paste0("R = ", round(cor(keep$Variable1, keep$Variable2,
                                                                                   method = input$corr_method,
                                                                                   use = "complete.obs"), 2))),
                                              x = max(keep$Variable1, na.rm = TRUE),
                                              y = min(keep$Variable2, na.rm = TRUE),
                                              vjust = "inward", hjust = "inward", check_overlap = TRUE, size = 5)} +
    
    theme_bw() + 
    {if(isTRUE(input$smooth))geom_smooth(aes(x = Variable1, y = Variable2), method = lm, color = input$smooth_color, na.rm = TRUE)} +
    {if(isTRUE(input$facet_factor) & input$my_factor != "None")facet_wrap(~ Factor)} +
    {if(isTRUE(input$facet_factor) & input$my_factor != "None")geom_text(data = cors, aes(label = paste0("R = ", cor)),
                                                                                               x = max(keep$Variable1, na.rm = TRUE),
                                                                                               y = min(keep$Variable2, na.rm = TRUE),
                                                                                               vjust = "inward", hjust = "inward", check_overlap = TRUE, size = 5)} +
    {if(isTRUE(input$showL) & input$my_factor != "None")geom_label(aes(x = Variable1, y = Variable2, label = ID, color = Factor), size = 5, show.legend = F)} +
    {if(isTRUE(input$showL) & input$my_factor == "None")geom_label(aes(x = Variable1, y = Variable2, label = ID), size = 5, show.legend = F)} +
    theme(legend.position = "top",
          legend.text = element_text(size = 12),
          legend.title = element_text(size = 15),
          axis.text.x = element_text(size = 12),
          axis.text.y = element_text(size = 12),
          axis.title.x = element_text(size = 15),
          axis.title.y = element_text(size = 15)) 
  
})

##

# Toggle points that are clicked
observeEvent(input$plot1_click, {
  
  data_subset <- Createdata()$data_subset
  vals <- Createdata()$vals
  
  res <- nearPoints(data_subset, input$plot1_click, allRows = TRUE)
  
  vals$keeprows <- xor(vals$keeprows, res$selected_)
  
})

# Toggle points that are brushed, when button is clicked
observeEvent(input$exclude_toggle, {
  
  data_subset <- Createdata()$data_subset
  vals <- Createdata()$vals
  
  res <- brushedPoints(data_subset, input$plot1_brush, allRows = TRUE)
  
  vals$keeprows <- xor(vals$keeprows, res$selected_)
  
})

# Reset all points
observeEvent(input$exclude_reset, {
  
  data_subset <- Createdata()$data_subset
  vals <- Createdata()$vals
  
  vals$keeprows <- rep(TRUE, nrow(data_subset))
  
})

## CORRELOGRAM

output$corr_plot <- renderPlotly({
  
  c_data <- NormData()$normalized
  
  ggplotly(POMA::PomaCorr(c_data, low = "red", high = "blue", label_size = input$lab_correlogram)$corrplot)
  
})

## NETWORK

output$corr_net <- renderPlot({
  
  c_data <- NormData()$normalized
  
  POMA::PomaCorr(c_data, coeff = input$cor_coeff)$graph
  
})

