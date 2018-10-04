
datasetInput <- reactive({

  if (input$example_data == "yes") {
    data <- read_csv("ST000284/MET_CRC_ST000284.csv")
    x <- colnames(data)
    updateSelectInput(session,"samples",choices = x, selected = x[1])
    updateSelectInput(session,"groups",choices = x, selected = x[2])
    updateSelectInput(session,"metF",choices = x, selected = x[3])
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
    updateSelectInput(session,"samples",choices = x2, selected = x2[1])
    updateSelectInput(session,"groups",choices = x2, selected = x2[2])
    updateSelectInput(session,"metF",choices = x2, selected = x2[3])
    updateSelectInput(session,"metL",choices = x2, selected = x2[length(x2)])
    print(data2)}
  }
})

covariatesInput <- reactive({

  if (input$example_data == "yes") {
    target1 <- read_csv("ST000284/COV_CRC_ST000284.csv")
    xt1 <- colnames(target1)
    updateSelectInput(session,"samples",choices = xt1, selected = xt1[1])
    updateSelectInput(session,"covF",choices = xt1, selected = xt1[2])
    updateSelectInput(session,"covL",choices = xt1, selected = xt1[length(xt1)])
    print(target1)
  }
  
  else if (input$example_data == "umd") {
    
    inFile <- input$target
    
    if(is.null(inFile)){
      return(NULL)
    }
    
    else {
      target <- as.data.frame(read.csv(inFile$datapath, input$header))
      xt <- colnames(target)
      updateSelectInput(session,"samples",choices = xt, selected = xt[1])
      updateSelectInput(session,"covF",choices = xt, selected = xt[2])
      updateSelectInput(session,"covL",choices = xt, selected = xt[length(xt)])
      print(target)}
  }
  
})

#################

prepareData <- 
  eventReactive(input$upload_data,
                ignoreNULL = TRUE, {
                  withProgress(message = "Preparing data, please wait",{
                    
                    alldata <- datasetInput()
                    
                    Sample = as.character(input$samples)
                    Group = as.character(input$groups)
                    met_F = as.character(input$metF)
                    met_L = as.character(input$metL)
                    
                    ###
                    
                    names <- as.data.frame(alldata[,colnames(alldata) == Sample])
                    x.names<-"ID";colnames(names)<-x.names
                    
                    groups <- as.data.frame(alldata[,colnames(alldata) == Group])
                    x.groups<-"Group";colnames(groups)<-x.groups

                    met1 <- as.numeric(which(colnames(alldata) == met_F))
                    met_last <- as.numeric(which(colnames(alldata) == met_L))
                    metabolites <- as.data.frame(alldata[,c(met1:met_last)])
                    x.metabolites<-c(colnames(alldata[met1:met_last]));colnames(metabolites)<-x.metabolites
   
                    #final data
                    prepared_data <- cbind(names,
                                           groups,
                                           metabolites)

                    print(prepared_data)
                  })
                })
                    
                    
#################
                  
output$contents <- DT::renderDataTable(datasetInput())

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
  DT::datatable(mytable)
  })

##

output$covariates<- DT::renderDataTable(covariatesInput())

