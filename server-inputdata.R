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
                    features <- datasetInput()
                    covariates <- covariatesInput()
                    
                    ## Datatable to show
                    
                    if(!is.null(covariates)){
                      covariates <- covariates %>% dplyr::select(-1)
                      prepared_data <- bind_cols(target, covariates, features)
                    } 
                    else{
                      prepared_data <- bind_cols(target, features)
                    }
                    
                    ## Selected rows
                    
                    if(!is.null(input$targetbox_rows_selected)){
                      prepared_data <- prepared_data[input$targetbox_rows_selected ,]
                    } 

                    ## MSnSet Class
                    
                    if(!is.null(covariates)){

                      target <- prepared_data[,c (1, 2:(ncol(covariates) + 2))]
                      features <- prepared_data[, c((ncol(covariates) + 3):ncol(prepared_data))]

                      data <- POMA::PomaMSnSetClass(target, features)

                      prepared_data <- prepared_data[, c(1:2, (3 + ncol(covariates)):ncol(prepared_data))]
                    }
                    else {

                      target <- prepared_data %>% dplyr::select(1:2)
                      features <- prepared_data %>% dplyr::select(-1, -2)

                      data <- POMA::PomaMSnSetClass(target, features)
                    }
                    
                    ##
                    
                    return(list(prepared_data = prepared_data, data = data))
                  })
                })
                    
                    
#################

output$targetbox <- DT::renderDataTable({
  datatable(targetInput(), class = 'cell-border stripe', rownames = FALSE, options = list(scrollX = TRUE))
  })

##

output$contents <- DT::renderDataTable({
  datatable(datasetInput(), class = 'cell-border stripe', rownames = FALSE, options = list(scrollX = TRUE))
  })

##

observeEvent(input$upload_data, ({
  updateCollapse(session,id =  "input_collapse_panel", open="prepared_panel",
                 style = list("prepared_panel" = "success",
                              "target_panel"="primary"))
}))

##

observeEvent(targetInput(),({
  updateCollapse(session,id =  "input_collapse_panel", open="target_panel",
                 style = list("prepared_panel" = "default",
                              "target_panel"="success"))
}))

##

output$submited <- DT::renderDataTable({
  
  mytable <- prepareData()$prepared_data
  
  DT::datatable(mytable, class = 'cell-border stripe', rownames = FALSE, options = list(scrollX = TRUE))
  
  })

##

output$covariates <- DT::renderDataTable({
  datatable(covariatesInput(), class = 'cell-border stripe', rownames = FALSE, options = list(scrollX = TRUE))
  })

##

output$report <- downloadHandler(
  
  filename = "POMA_EDA_report.pdf",
  content = function(file) {

    tempReport <- file.path(tempdir(), "POMA_EDA_report.Rmd")
    file.copy("POMA_EDA_report.Rmd", tempReport, overwrite = TRUE)

    params <- list(n = prepareData()$data)

    rmarkdown::render(tempReport, output_file = file,
                      params = params,
                      envir = new.env(parent = globalenv())
    )
    
  }
)

