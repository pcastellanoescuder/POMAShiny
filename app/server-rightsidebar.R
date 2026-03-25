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

RightSidebar <- reactive({
  if(is.null(prepareData()$data)){
    return(NULL)
  }
  else{
    data <- prepareData()$data
    return(data)
  }
})

## samples 

output$samples_num <- renderText({
  
  data <- RightSidebar()
  
  paste0("Samples: ", length(colnames(data)))
  
})

## features

output$features_num <- renderText({
  
  data <- RightSidebar()
  
  paste0("Features: ", length(rownames(data)))
  
})

## groups

output$groups_num <- renderText({
  
  data <- RightSidebar()
  
  paste0("Groups: ", length(table(as.data.frame(SummarizedExperiment::colData(data))[1])))
  
})

## covariates

output$covariates_num <- renderText({
  
  data <- RightSidebar()
  
  paste0("Covariates: ", ncol(SummarizedExperiment::colData(data)) - 1)
  
})

