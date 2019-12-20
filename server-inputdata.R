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

targetInput <- reactive({
  
  if (input$example_data == "yes") {
    target <- read_csv("ST000284/target.csv")
    colnames(target) <- c("ID", "Group")
    print(target)
  }
  
  else if (input$example_data == "umd") {
    
    infile <- input$target
    
    if (is.null(infile)){
      return(NULL)
    }
    
    else {
      target <- read_csv(infile$datapath, input$header)
      colnames(target) <- c("ID", "Group")
      print(target)}
  }
})

datasetInput <- reactive({

  if (input$example_data == "yes") {
    data <- read_csv("ST000284/MET_CRC_ST000284.csv")
    x <- colnames(data)
    updateSelectInput(session,"metF",choices = x, selected = x[1])
    updateSelectInput(session,"metL",choices = x, selected = x[length(x)])
    print(data)
  }
  
 else if (input$example_data == "umd") {

    infile <- input$metabolites
    
  if (is.null(infile)){
      return(NULL)
      }
  
  else {
    data2 <- read_csv(infile$datapath, input$header)
    x2 <- colnames(data2)
    updateSelectInput(session,"metF",choices = x2, selected = x2[1])
    updateSelectInput(session,"metL",choices = x2, selected = x2[length(x2)])
    print(data2)}
  }
})

covariatesInput <- reactive({

  if (input$example_data == "yes") {
    covariates1 <- read_csv("ST000284/COV_CRC_ST000284.csv")
    xt1 <- colnames(covariates1)
    updateSelectInput(session,"samples",choices = xt1, selected = xt1[1])
    updateSelectInput(session,"covF",choices = xt1, selected = xt1[2])
    updateSelectInput(session,"covL",choices = xt1, selected = xt1[length(xt1)])
    print(covariates1)
  }
  
  else if (input$example_data == "umd") {
    
    inFile <- input$covariates
    
    if(is.null(inFile)){
      return(NULL)
    }
    
    else {
      covariates <- read_csv(inFile$datapath, input$header)
      xt <- colnames(covariates)
      updateSelectInput(session,"samples",choices = xt, selected = xt[1])
      updateSelectInput(session,"covF",choices = xt, selected = xt[2])
      updateSelectInput(session,"covL",choices = xt, selected = xt[length(xt)])
      print(covariates)}
  }
  
})

#################

prepareData <- 
  eventReactive(input$upload_data,
                ignoreNULL = TRUE, {
                  withProgress(message = "Preparing data, please wait",{
                    
                    target <- targetInput()
                    metabolites <- datasetInput()
                    
                    met_F = as.character(input$metF)
                    met_L = as.character(input$metL)
                    
                    ###

                    met1 <- as.numeric(which(colnames(metabolites) == met_F))
                    met_last <- as.numeric(which(colnames(metabolites) == met_L))
                    metabolites <- as.data.frame(metabolites[,c(met1:met_last)])
                    
                    x.metabolites <- c(colnames(metabolites[met1:met_last]))
                    colnames(metabolites) <- x.metabolites
   
                    #final data
                    prepared_data <- cbind(target, metabolites)

                    print(prepared_data)
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

observeEvent(datasetInput(),({
  updateCollapse(session,id =  "input_collapse_panel", open="data_panel",
                 style = list("prepared_panel" = "default",
                              "data_panel"="success"))
})
)

##

output$submited <- DT::renderDataTable({
  mytable <- prepareData()
  DT::datatable(mytable, class = 'cell-border stripe', rownames = FALSE)
  })

##

output$covariates<- DT::renderDataTable(covariatesInput(), class = 'cell-border stripe', rownames = FALSE)

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

