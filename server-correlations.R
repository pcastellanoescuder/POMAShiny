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

Selection <- 
  
  reactive({
    
    c.data <- NormData()
    x <- colnames(c.data)
    updateSelectInput(session,"one", choices = x[3:length(x)], selected = x[3])
    updateSelectInput(session,"two", choices = x[3:length(x)], selected = x[4])
    print(c.data)
  })


Correlation_plot <- 
  reactive({
                    
                    c.data <- NormData()
                    c.data <- c.data[,3:ncol(c.data)]
                    c.data <- as.matrix(round(cor(c.data), 3))
                    
                    ####
                    
                    c.data2 <- Selection()
                    
                    One <- as.character(input$one)
                    Two <- as.character(input$two)
                    
                    One.df <- as.data.frame(c.data2[,colnames(c.data2) == One])
                    
                    Two.df <- as.data.frame(c.data2[,colnames(c.data2) == Two])
                    
                    TOTAL <- cbind(One.df, Two.df)
                    colnames(TOTAL) <- c("Metabolite 1", "Metabolite 2")
                    
                    correlation_plot <- ggplotly(ggplot(TOTAL, aes(x = `Metabolite 1`, y = `Metabolite 2`)) + 
                                                   geom_point() +
                                                   xlab(One) + 
                                                   ylab(Two) + 
                                                   theme(legend.position="none") + 
                                                   theme_minimal())
                    
                    ####
                    
                    return(list(c.data = c.data, correlation_plot = correlation_plot,
                                One = One, Two = Two, TOTAL = TOTAL))


                })


################# 

output$corr_plot <- renderPlotly({
  
  c.data <- Correlation_plot()$c.data
  
  plot_ly(x=colnames(c.data), y=rownames(c.data), z = c.data, type = "heatmap", height = 700) 
  
})

output$cor_plot <- renderPlotly({
  Correlation_plot()$correlation_plot
})

output$text <- renderText({
  One <- Correlation_plot()$One
  Two <- Correlation_plot()$Two
  TOTAL <- Correlation_plot()$TOTAL
    
  paste0("The ",input$corr_method," correlation between ", One," and ", Two, " is ",
         round(cor(TOTAL$`Metabolite 1`, TOTAL$`Metabolite 2`, method = input$corr_method),3),
         " and p-value is ", 
         round(cor.test(TOTAL$`Metabolite 1`, TOTAL$`Metabolite 2`, 
                        method = input$corr_method)$p.value,3))
})

