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
  
  paste0("Samples: ", length(Biobase::sampleNames(data)))
  
})

## features

output$features_num <- renderText({
  
  data <- RightSidebar()
  
  paste0("Features: ", length(Biobase::featureNames(data)))
  
})

## groups

output$groups_num <- renderText({
  
  data <- RightSidebar()
  
  paste0("Groups: ", length(table(Biobase::pData(data)[1])))
  
})

## covariates

output$covariates_num <- renderText({
  
  data <- RightSidebar()
  
  paste0("Covariates: ", ncol(Biobase::pData(data)) -1)
  
})

## sessionInfo

output$session_info <- renderPrint({
  
  capture.output(sessionInfo())
  
})

