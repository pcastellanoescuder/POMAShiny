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
  
  data <- Outliers()$norm_table %>% select_if(is.numeric)
  x <- colnames(data)
  
  updateSelectizeInput(session, "sel_density", choices = x, selected = x[1:2])
  
})

##

output$densplot <- renderPlotly({
  
  to_density <- Outliers()$data
  
  if(input$group_dens){
    to_density <- POMA::PomaDensity(to_density, group = "samples")
  } else {
    to_density <- POMA::PomaDensity(to_density, group = "features", feature_name = input$sel_density) 
  }
  
  ggplotly(to_density + theme(legend.title = element_blank(),
                              axis.title.x = element_blank())) %>% plotly::config(
    toImageButtonOptions = list(format = "png"),
    displaylogo = FALSE,
    collaborate = FALSE,
    modeBarButtonsToRemove = c(
      "sendDataToCloud", "zoom2d", "pan2d", "select2d",
      "lasso2d", "autoScale2d", "hoverClosestCartesian", "hoverCompareCartesian"
    )
  )

})

