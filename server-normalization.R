observe_helpers(help_dir = "help_mds")

DataExists2<- reactive({
  if(is.null(ImputedData())){
    return(NULL)
  }
  if(!is.null(ImputedData())){
    ImputedData()
  }
})

#ImputedData

NormData <- 
  eventReactive(input$norm_data,
                ignoreNULL = TRUE, {
                  withProgress(message = "Normalizing data, please wait",{
                    
                    to_norm_data<-DataExists2()
                    samples_groups<-to_norm_data[,1:2]
                    to_norm_data<-to_norm_data[,c(3:ncol(to_norm_data))]
                    
                    #remove columns that only have zeros
                    to_norm_data<-to_norm_data[,apply(to_norm_data,2,function(x) !all(x==0))] 
                    
                    if (input$normalization_type == "none"){
                      not_norm_data <- to_norm_data
                      not_norm_data<-cbind(samples_groups,not_norm_data)
                      return (not_norm_data)
                      print(not_norm_data)
                    }
                    
                    
                    else if (input$normalization_type == "auto_scaling"){
                      auto_scaling_data <- apply(to_norm_data,2,function(x) (x-mean(x,na.rm=T))/sd(x,na.rm=T))
                      auto_scaling_data<-cbind(samples_groups,auto_scaling_data)
                      return (auto_scaling_data)
                      print(auto_scaling_data)
                    }
    
                    
                    else if (input$normalization_type == "level_scaling"){
                      level_scaling_data <- apply(to_norm_data,2,function(x) (x-mean(x,na.rm=T))/mean(x,na.rm=T))
                      level_scaling_data<-cbind(samples_groups,level_scaling_data)
                      return (level_scaling_data)
                      print(level_scaling_data)
                    }
                    

                    else if (input$normalization_type == "log_scaling"){
                      log_scaling_data <- apply(to_norm_data,2,function(x) (log10(x+1)-mean(log10(x+1),na.rm=T))/sd(log10(x+1),na.rm=T))
                      log_scaling_data <-cbind(samples_groups,log_scaling_data)
                      return (log_scaling_data)
                      print(log_scaling_data)
                    } 
                    
                    else if (input$normalization_type == "log_transformation"){
                      log_transformation_data <- apply(to_norm_data,2,function(x) (log10(x+1)))
                      log_transformation_data<-cbind(samples_groups,log_transformation_data)
                      return (log_transformation_data)
                      print(log_transformation_data)
                    } 
                    
                    else if (input$normalization_type == "vast_scaling"){
                      vast_scaling_data <- apply(to_norm_data,2,function(x) ((x-mean(x,na.rm=T))/sd(x,na.rm=T))*(mean(x,na.rm=T)/sd(x,na.rm=T)))
                      vast_scaling_data<-cbind(samples_groups,vast_scaling_data)
                      return (vast_scaling_data)
                      print(vast_scaling_data)
                    }
                    

                    else if (input$normalization_type == "log_pareto"){
                      log_pareto_data <- apply(to_norm_data,2,function(x) (log10(x+1)-mean(log10(x+1),na.rm=T))/sqrt(sd(log10(x+1),na.rm=T)))
                      log_pareto_data<-cbind(samples_groups,log_pareto_data)
                      return (log_pareto_data)
                      print(log_pareto_data)
                    }
                    

                    #else if (input$normalization_type == "pareto_scaling"){
                    #  pareto_scaling_data <- apply(to_norm_data,2,function(x) (x-mean(x,na.rm=T))/sqrt(sd(x),na.rm=T))
                    #  pareto_scaling_data<-cbind(samples_groups,pareto_scaling_data)
                    #  return (pareto_scaling_data)
                    #  print(pareto_scaling_data)
                    #}

                    })
                  })

 
#################

output$input_normalized <- renderDataTable({
  DataExists2()
  })

observeEvent(DataExists2(),({
  updateCollapse(session,id =  "norm_collapse_panel", open="not_norm_panel",
                 style = list("norm_panel" = "default",
                              "not_norm_panel"="success"))
}))
  
observeEvent(input$norm_data, ({
  updateCollapse(session,id =  "norm_collapse_panel", open="norm_panel",
                 style = list("norm_panel" = "success",
                              "not_norm_panel"="primary"))
}))


output$normalized <- DT::renderDataTable({
  normtable <- NormData()
  DT::datatable(normtable)
})

