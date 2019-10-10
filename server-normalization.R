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

DataExists2<- reactive({
  if(is.null(ImputedData())){
    return(NULL)
  }
  if(!is.null(ImputedData())){
    ImputedData()
  }
})

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
                      not_norm_data <- round(to_norm_data,3)
                      not_norm_data<-cbind(samples_groups,not_norm_data)
                      return (not_norm_data)
                      print(not_norm_data)
                    }
                    
                    
                    else if (input$normalization_type == "auto_scaling"){
                      auto_scaling_data <- round(apply(to_norm_data,2,function(x) (x-mean(x,na.rm=T))/sd(x,na.rm=T)),3)
                      auto_scaling_data<-cbind(samples_groups,auto_scaling_data)
                      return (auto_scaling_data)
                      print(auto_scaling_data)
                    }
    
                    
                    else if (input$normalization_type == "level_scaling"){
                      level_scaling_data <- round(apply(to_norm_data,2,function(x) (x-mean(x,na.rm=T))/mean(x,na.rm=T)),3)
                      level_scaling_data<-cbind(samples_groups,level_scaling_data)
                      return (level_scaling_data)
                      print(level_scaling_data)
                    }
                    

                    else if (input$normalization_type == "log_scaling"){
                      log_scaling_data <- round(apply(to_norm_data,2,function(x) (log10(x+1)-mean(log10(x+1),na.rm=T))/sd(log10(x+1),na.rm=T)),3)
                      log_scaling_data <-cbind(samples_groups,log_scaling_data)
                      return (log_scaling_data)
                      print(log_scaling_data)
                    } 
                    
                    else if (input$normalization_type == "log_transformation"){
                      log_transformation_data <- round(apply(to_norm_data,2,function(x) (log10(x+1))),3)
                      log_transformation_data<-cbind(samples_groups,log_transformation_data)
                      return (log_transformation_data)
                      print(log_transformation_data)
                    } 
                    
                    else if (input$normalization_type == "vast_scaling"){
                      vast_scaling_data <- round(apply(to_norm_data,2,function(x) ((x-mean(x,na.rm=T))/sd(x,na.rm=T))*(mean(x,na.rm=T)/sd(x,na.rm=T))),3)
                      vast_scaling_data<-cbind(samples_groups,vast_scaling_data)
                      return (vast_scaling_data)
                      print(vast_scaling_data)
                    }
                    

                    else if (input$normalization_type == "log_pareto"){
                      log_pareto_data <- round(apply(to_norm_data,2,function(x) (log10(x+1)-mean(log10(x+1),na.rm=T))/sqrt(sd(log10(x+1),na.rm=T))),3)
                      log_pareto_data<-cbind(samples_groups,log_pareto_data)
                      return (log_pareto_data)
                      print(log_pareto_data)
                    }

                    })
                  })

 
#################

output$input_normalized <- renderDataTable({
  datatable(DataExists2(), class = 'cell-border stripe', rownames = FALSE)
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

  DT::datatable(normtable,
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="normalized"),
                                   list(extend="excel",
                                        filename="normalized"),
                                   list(extend="pdf",
                                        filename="normalized")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(normtable)))
})

output$norm_plot1 <- renderPlot({
  
  prevdata <- DataExists2()
  prevdata$ID <- as.factor(as.character(prevdata$ID))
  
  prevdata %>%
    reshape2::melt() %>%
    group_by(ID) %>%
    ggplot(aes(ID, value, color = Group)) +
    geom_boxplot() +
    geom_jitter() +
    theme_minimal() +
    xlab("Subjects") +
    theme(text = element_text(size=15))
  
})

output$norm_plot2 <- renderPlot({
  
  normtable <- NormData()
  normtable$ID <- as.factor(as.character(normtable$ID))
  
  normtable %>%
    reshape2::melt() %>%
    group_by(ID) %>%
    ggplot(aes(ID, value, color = Group)) +
    geom_boxplot() +
    geom_jitter() +
    theme_minimal() +
    xlab("Subjects") +
    theme(text = element_text(size=15))
  
})

