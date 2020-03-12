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

####

targetInput <- reactive({
  
  if (input$example_data == "yes") {
    target <- read_csv("data/target.csv")
    colnames(target) <- c("ID", "Group")
    return(target)
  }
  
  else if (input$example_data == "umd") {
    
    infile <- input$target
    
    if (is.null(infile)){
      return(NULL)
    }
    
    else {
      target <- read_csv(infile$datapath)
      colnames(target) <- c("ID", "Group")
      return(target)}
  }
})

####

datasetInput <- reactive({

  if (input$example_data == "yes") {
    data <- read_csv("data/features.csv")
    return(data)
  }
  
 else if (input$example_data == "umd") {

    infile <- input$metabolites
    
  if (is.null(infile)){
      return(NULL)
      }
  
  else {
    data2 <- read_csv(infile$datapath)
    return(data2)}
  }
})

####

covariatesInput <- reactive({

  if (input$example_data == "yes") {
    
    covariates <- read_csv("data/covariables.csv")
    return(covariates)
    
  }
  
  else if (input$example_data == "umd") {
    
    inFile <- input$covariates
    
    if(is.null(inFile)){
      return(NULL)
      
    }
    
    else {
      
      covariates <- read_csv(inFile$datapath)
      return(covariates)
      
      }
    }
  })

#################

prepareData <- 
  eventReactive(input$upload_data,
                ignoreNULL = TRUE, {
                  withProgress(message = "Preparing data, please wait",{
                    
                    target <- targetInput()
                    metabolites <- datasetInput()
                    
                    prepared_data <- cbind(target, metabolites)

                    return(prepared_data)
                  })
                })
                    
                    
#################

output$targetbox <- DT::renderDataTable(targetInput(), class = 'cell-border stripe', rownames = FALSE)

output$contents <- DT::renderDataTable(datasetInput(), class = 'cell-border stripe', rownames = FALSE)

##

observeEvent(input$upload_data, ({
  updateCollapse(session,id =  "input_collapse_panel", open="prepared_panel",
                 style = list("prepared_panel" = "success",
                              "data_panel"="primary"))
}))

##

observeEvent(datasetInput(),({
  updateCollapse(session,id =  "input_collapse_panel", open="data_panel",
                 style = list("prepared_panel" = "default",
                              "data_panel"="success"))
}))

##

output$submited <- DT::renderDataTable({
  mytable <- prepareData()
  DT::datatable(mytable, class = 'cell-border stripe', rownames = FALSE)
  })

##

output$covariates <- DT::renderDataTable(covariatesInput(), class = 'cell-border stripe', rownames = FALSE)

##

output$report <- downloadHandler(

  filename = "automatic_exploratory_report.html",
  content = function(file) {

    tempReport <- file.path(tempdir(), "automatic_exploratory_report.Rmd") 
    file.copy("automatic_exploratory_report.Rmd", tempReport, overwrite = TRUE) 
    
    params <- list(n = prepareData())

    rmarkdown::render(tempReport, output_file = file,
                      params = params,
                      envir = new.env(parent = globalenv())
    )
  }
)

