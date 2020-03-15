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

DataExists1 <- reactive({
  if(is.null(prepareData())){
    return(NULL)
  }
  else{
    prepareData()
    }
})

ImputedData <- 
  eventReactive(input$process,
                ignoreNULL = TRUE, {
                  withProgress(message = "Imputing data, please wait",{
                    
                    to_imp_data <- DataExists1()
                    samples_groups <- to_imp_data[,1:2]
                    colnames(samples_groups)[1:2] <- c("ID", "Group")
                    to_imp_data <- to_imp_data[,3:ncol(to_imp_data)]
                    
                    if (input$ZerosAsNA == TRUE){
                      to_imp_data[to_imp_data == 0] <- NA
                      to_imp_data <- data.frame(cbind(Group = samples_groups$Group, to_imp_data))
                      
                    } else {
                      to_imp_data <- data.frame(cbind(Group = samples_groups$Group, to_imp_data))
                    }
                    
                    if (input$RemoveNA == TRUE){
                      count_NA <- aggregate(. ~ Group, data = to_imp_data,
                                            function(x) {100*(sum(is.na(x))/(sum(is.na(x))+sum(!is.na(x))))},
                                            na.action = NULL)
                      count_NA$Group <- NULL
                      supress <- as.data.frame(lapply(count_NA, function(x) all(x > input$value_remove)))
                      supress <- unlist(supress)
                      depurdata <- to_imp_data[, 2:ncol(to_imp_data)][!supress]
                      depurdata <- sapply(depurdata, function(x) as.numeric(as.character(x)))
                      
                    } else {
                      
                      depurdata <- to_imp_data[, 2:ncol(to_imp_data)]
                      depurdata <- sapply(depurdata, function(x) as.numeric(as.character(x)))
                      
                    }
                    
                    if (input$select_method == "none"){
                      depurdata[is.na(depurdata)] <- 0
                    }
                    
                    else if (input$select_method == "half_min"){
                      depurdata <- apply(depurdata, 2, function(x) {
                        if(is.numeric(x)) ifelse(is.na(x), min(x, na.rm = T)/2, x) else x})
                    }
                    
                    else if (input$select_method == "median"){
                      depurdata <- apply(depurdata, 2, function(x) {
                        if(is.numeric(x)) ifelse(is.na(x), median(x,na.rm=T),x) else x})
                    }
                    
                    else if (input$select_method == "mean"){
                      depurdata <- apply(depurdata, 2, function(x) {
                        if(is.numeric(x)) ifelse(is.na(x), mean(x,na.rm=T),x) else x})
                    }
                    
                    else if (input$select_method == "min"){
                      depurdata <- apply(depurdata, 2, function(x) {
                        if(is.numeric(x)) ifelse(is.na(x), min(x,na.rm=T),x) else x})
                    }
                    
                    else if (input$select_method == "knn"){
                      depurdata <- t(depurdata)
                      datai <- impute::impute.knn(depurdata)
                      depurdata <- t(datai$data)
                    }
                    
                    final_impute <- cbind(samples_groups, depurdata)
                    return(final_impute)
                    
                    })
                  })

#################

output$raw <- renderDataTable({
  datatable(DataExists1(), class = 'cell-border stripe', rownames = FALSE)
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
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMA_imputed"),
                                   list(extend="excel",
                                        filename="POMA_imputed"),
                                   list(extend="pdf",
                                        filename="POMA_imputed")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(imput_data_table)))
})

