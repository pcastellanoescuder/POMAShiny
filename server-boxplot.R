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

observe({
  
  to_boxplot <- NormData()$norm_table
  names_boxplot <- colnames(to_boxplot)[3:ncol(to_boxplot)]
  
  updateSelectizeInput(session, "sel_boxplot", choices = names_boxplot, selected = names_boxplot[1:2])
  
})

BoxPlot <- reactive({
  
  to_boxplot <- NormData()$norm_table
 
  boxP <- to_boxplot %>% 
    dplyr::select(-ID) %>% 
    reshape2::melt() %>% 
    filter(variable %in% input$sel_boxplot) %>%
    ggplot(aes(variable, value, fill = Group)) + 
    geom_boxplot() + 
    ylab("Value") + 
    xlab("") +
    {if(input$jitter)geom_jitter()} +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  return(boxP)
  
})

##

output$boxPlotly <- renderPlotly({
  
  ggplotly(BoxPlot()) %>% layout(boxmode = "group")

})

