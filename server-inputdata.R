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

#### TARGET

targetInput <- reactive({
  
  if(input$example_data == "yes") {
    if(input$example_dataset == "st000284"){
      target <- Biobase::pData(st000284) %>% rownames_to_column("ID") %>% dplyr::rename(Group = 2)
    } else{
      target <- Biobase::pData(st000336) %>% rownames_to_column("ID") %>% dplyr::rename(Group = 2) 
    }
    return(target)
    }
  
  else if (input$example_data == "umd") {
    
    infile <- input$target
    
    if (is.null(infile)){
      return(NULL)
    }
    
    else {
      target <- read_csv(infile$datapath)
      target <- target %>% dplyr::rename(ID = 1, Group = 2)
      return(target)
      }
  }
  
  })

#### FEATURES

datasetInput <- reactive({

  if (input$example_data == "yes") {
    if(input$example_dataset == "st000284"){
      features <- t(Biobase::exprs(st000284))
    } else{
      features <- t(Biobase::exprs(st000336)) 
    }
    return(features)
  }
  
 else if (input$example_data == "umd") {

    infile <- input$metabolites
    
  if (is.null(infile)){
      return(NULL)
      }
  
  else {
    features <- read_csv(infile$datapath)
    return(features)
  }
    }
  })

#### PREPARED DATA

prepareData <- 
  eventReactive(input$upload_data,
                ignoreNULL = TRUE, {
                  withProgress(message = "Preparing data, please wait",{
                    
                    target <- targetInput()
                    features <- datasetInput()
                    
                    col_tar <- ncol(target)
                    
                    ## Datatable to show
                    
                    prepared_data <- cbind(target, features)
                    
                    validate(need(sum(apply(features, 2, function(x){sum(x < 0, na.rm = TRUE)})) == 0, "Negative values detected in your data."))
                    
                    ## Selected rows
                    
                    if(!is.null(input$targetbox_rows_selected)){
                      prepared_data <- prepared_data[input$targetbox_rows_selected ,]
                    } 

                    ## MSnSet Class
                    
                    target <- prepared_data[, c(1:col_tar)]
                    features <- prepared_data[, -c(1:col_tar)]
                    
                    data <- POMA::PomaMSnSetClass(target, features)
                    
                    prepared_data <- cbind(target[, c(1:2)], round(features, 3))
                    
                    ##
                    
                    return(list(prepared_data = prepared_data, data = data))
                  })
                })
                    
                    
#################

output$targetbox <- DT::renderDataTable({
  datatable(targetInput(), 
            class = 'cell-border stripe', 
            rownames = FALSE, 
            filter = "top", 
            extensions = 'Buttons', 
            options = list(scrollX = TRUE,
                           lengthMenu = list(c(10, 25, 50, 100, -1), c('10','25','50', '100', 'All')))
  )
  })

##

output$contents <- DT::renderDataTable({
  datatable(round(datasetInput(), 3), class = 'cell-border stripe', rownames = FALSE, options = list(scrollX = TRUE))
  })

##

output$submited <- DT::renderDataTable({
  datatable(prepareData()$prepared_data, class = 'cell-border stripe', rownames = FALSE, options = list(scrollX = TRUE))
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

