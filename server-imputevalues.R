DataExists1<- reactive({
  if(is.null(prepareData())){
    return(NULL)
  }
  else{
    prepareData()
    }
})

Zeros_NA <- reactive({
  
  if (input$zeros_are_NA == "yes"){
    to_imp_data <- prepareData() #
    
    samples_groups<-to_imp_data[,1:2]
    to_imp_data<-to_imp_data[,3:length(to_imp_data)] 
    
    to_imp_data[to_imp_data == 0] <- NA #
    
    to_imp_data <- cbind(samples_groups,to_imp_data)
    
    return(to_imp_data)}
  
  else {
    to_imp_data <- prepareData()
    return(to_imp_data)
  }
})

ImputedData <- 
  eventReactive(input$process,
                ignoreNULL = TRUE, {
                  withProgress(message = "Imputing data, please wait",{
                    
                    to_imp_data <- Zeros_NA()
                    
                    #remove columns that only have NA values
                    to_imp_data <- to_imp_data[,apply(to_imp_data,2,function(x) !all(is.na(x)))] 
                      
                      
                    if (input$select_remove == "yes"){
                      
                      samples_groups<-to_imp_data[,1:2]
                      
                      count_NA <- aggregate(. ~ Group, data = to_imp_data[,2:length(to_imp_data)], 
                                            function(x) {100*(sum(is.na(x))/(sum(is.na(x))+sum(!is.na(x))))}, 
                                            na.action = NULL)
                      
                        
                      supress <- c(count_NA[1,] > (input$value_remove) | 
                                   count_NA[2,] > (input$value_remove))
                      
                      to_imp_data<-to_imp_data[,2:length(to_imp_data)][,!supress]
                      
                      to_imp_data$Group <- NULL
                      
                      #samples_groups<-to_imp_data[,1:2]
                      #to_imp_data <-to_imp_data[,c(3:ncol(to_imp_data))]
                      depurdata<- to_imp_data
                      
                      if (input$select_method == "none"){
                        depurdata[is.na(depurdata)] <- 0
                        depurdata<-cbind(samples_groups,depurdata)
                        return(depurdata)
                      }
                      
                      if (input$select_method == "half_min"){
                        depurdata<- apply(depurdata, 2, function(x) "[<-"(x, !x | is.na(x), 
                                                                  min(x[x >= 0], na.rm = TRUE) / 2))
      
                        depurdata<-cbind(samples_groups,depurdata)
                        return(depurdata)
                      }
                      
                      if (input$select_method == "median"){
                        depurdata<-apply(depurdata,2,function(x) {
                          if(is.numeric(x)) ifelse(is.na(x), median(x,na.rm=T),x) else x})
                        depurdata<-cbind(samples_groups,depurdata)
                        return(depurdata)
                      }
                      
                      if (input$select_method == "mean"){
                        depurdata<-apply(depurdata,2,function(x) {
                          if(is.numeric(x)) ifelse(is.na(x), mean(x,na.rm=T),x) else x})
                        depurdata<-cbind(samples_groups,depurdata)
                        return(depurdata)
                      }
                      
                      if (input$select_method == "min"){
                        depurdata<-apply(depurdata,2,function(x) {
                          if(is.numeric(x)) ifelse(is.na(x), min(x,na.rm=T),x) else x})
                        depurdata<-cbind(samples_groups,depurdata)
                        return(depurdata)
                      }
                      
                      if (input$select_method == "knn"){
                        
                        depurdata<-t(depurdata)
                        datai<-impute::impute.knn(as.matrix(depurdata))
                        depurdata<-t(datai$data)
                        depurdata<-cbind(samples_groups,depurdata)
                        return(depurdata)
                      }
                      
                      return(depurdata)
                    }
                    

                    if (input$select_remove == "no"){
                      
                      samples_groups<-to_imp_data[,1:2]
                      to_imp_data <-to_imp_data[,c(3:ncol(to_imp_data))]
                      depurdata<-to_imp_data
                      
                      if (input$select_method == "none"){
                        depurdata[is.na(depurdata)] <- 0
                        depurdata<-cbind(samples_groups,depurdata)
                        return(depurdata)
                      }
                      
                      if (input$select_method == "half_min"){
                        depurdata<- apply(depurdata, 2, function(x) "[<-"(x, !x | is.na(x), 
                                                                          min(x[x >= 0], na.rm = TRUE) / 2))
                        
                        depurdata<-cbind(samples_groups,depurdata)
                        return(depurdata)
                      }
                      
                      if (input$select_method == "median"){
                        depurdata<-apply(depurdata,2,function(x) {
                          if(is.numeric(x)) ifelse(is.na(x), median(x,na.rm=T),x) else x})
                        depurdata<-cbind(samples_groups,depurdata)
                        return(depurdata)
                      }
                      
                      if (input$select_method == "mean"){
                        depurdata<-apply(depurdata,2,function(x) {
                          if(is.numeric(x)) ifelse(is.na(x), mean(x,na.rm=T),x) else x})
                        depurdata<-cbind(samples_groups,depurdata)
                        return(depurdata)
                      }
                      
                      if (input$select_method == "min"){
                        depurdata<-apply(depurdata,2,function(x) {
                          if(is.numeric(x)) ifelse(is.na(x), min(x,na.rm=T),x) else x})
                        depurdata<-cbind(samples_groups,depurdata)
                        return(depurdata)
                      }
                      
                      if (input$select_method == "knn"){
                        
                        depurdata<-t(depurdata)
                        datai<-impute::impute.knn(as.matrix(depurdata))
                        depurdata<-t(datai$data)
                        depurdata<-cbind(samples_groups,depurdata)
                        return(depurdata)
                      }
                      
                      return(depurdata)
                    }
                    
                    
                    })
                  })

 
#################

output$raw <- renderDataTable({
  DataExists1()
  })

observeEvent(DataExists1(),({
  updateCollapse(session,id = "imp_collapse_panel", open="raw_panel",
                 style = list("impute_panel" = "default",
                              "raw_panel"="success"))
}))
  
observeEvent(input$process, ({
  updateCollapse(session,id =  "imp_collapse_panel", open="impute_panel",
                 style = list("impute_panel" = "success",
                              "raw_panel"="primary"))
}))


output$imputed <- DT::renderDataTable({
  imput_data_table<-ImputedData()
  imput_data_table[,3:ncol(imput_data_table)] <- round(imput_data_table[,3:ncol(imput_data_table)],3)
  
  DT::datatable(imput_data_table,
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="imputed"),
                                   list(extend="excel",
                                        filename="imputed"),
                                   list(extend="pdf",
                                        filename="imputed")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(imput_data_table)))
})

