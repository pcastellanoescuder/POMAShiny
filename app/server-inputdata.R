# This file is part of POMAShiny.

# POMAShiny is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# POMAShiny is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with POMAShiny. If not, see <https://www.gnu.org/licenses/>.

observe_helpers(help_dir = "help_mds")

#### TARGET

targetInput <- reactive({
  
  if(input$example_data == "yes") {
    
    if(input$example_dataset == "st000284"){
      target <- as.data.frame(SummarizedExperiment::colData(st000284)) %>% rownames_to_column("ID") %>% dplyr::rename(Group = 2)
    } else{
      target <- as.data.frame(SummarizedExperiment::colData(st000336)) %>% rownames_to_column("ID") %>% dplyr::rename(Group = 2)
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
        
        validate(need(sum(apply(target, 2, function(x){sum(is.na(x), na.rm = TRUE)})) == 0, "Missing values not allowed in target file."))
        
        return(target)
        }
      }
  })

#### FEATURES

datasetInput <- reactive({

  if (input$example_data == "yes") {
    if(input$example_dataset == "st000284"){
      features <- t(SummarizedExperiment::assay(st000284))
    } else{
      features <- t(SummarizedExperiment::assay(st000336))
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

#### COMBINATION FILE

combInput <- reactive({
  
  infile <- input$combine_data
  
  if (is.null(infile)){
    return(NULL)
  }
  
  else {
    combine_data <- read_csv(infile$datapath)
    
    validate(need(sum(apply(combine_data, 2, function(x){sum(is.na(x), na.rm = TRUE)})) == 0, "Missing values not allowed in grouping file."))
    validate(need(ncol(combine_data) == 3, "Grouping file must be a CSV with three columns (feature, grouping factor and new feature name)."))
    
    combine_data <- combine_data %>% 
      dplyr::rename(feature = 1, grp = 2, new_feat = 3)
    
    return(combine_data)
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
                    
                    validate(need(sum(apply(features, 2, function(x){sum(x < 0, na.rm = TRUE)})) == 0, "Negative values not allowed."))
                    
                    ## Selected rows
                    
                    if(!is.null(input$targetbox_rows_selected)){
                      prepared_data <- prepared_data[input$targetbox_rows_selected ,]
                    } 

                    ## SummarizedExperiment Object
                    
                    target <- prepared_data[, c(1:col_tar)]
                    features <- prepared_data[, -c(1:col_tar)]
                    
                    data <- POMA::PomaCreateObject(metadata = target, features = features)
                    
                    if(input$combine_feat & input$example_data == "umd") {
                      
                      comb_data <- combInput()
                      
                      validate(need(!is.null(comb_data), "Please upload a grouping file."))
                      
                      grp <- as.factor(comb_data$grp)
                      nms <- unique(comb_data$new_feat)

                      feature_matrix <- t(SummarizedExperiment::assay(data))
                      agg_fun <- match.fun(input$method_comb)
                      combined <- sapply(unique(as.character(grp)), function(g) {
                        cols <- which(grp == g)
                        if (length(cols) == 1) return(feature_matrix[, cols])
                        apply(feature_matrix[, cols, drop = FALSE], 1, agg_fun, na.rm = TRUE)
                      })
                      colnames(combined) <- nms

                      cv_data <- sapply(unique(as.character(grp)), function(g) {
                        cols <- which(grp == g)
                        if (length(cols) <= 1) return(rep(NA, nrow(feature_matrix)))
                        apply(feature_matrix[, cols, drop = FALSE], 1, function(x) sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE) * 100)
                      })
                      colnames(cv_data) <- nms
                      cv_data <- as.data.frame(cv_data) %>%
                        mutate(ID = rownames(as.data.frame(SummarizedExperiment::colData(data)))) %>%
                        select(ID, everything()) %>%
                        select_if(~ sum(!is.na(.)) > 0)

                      metadata_df <- as.data.frame(SummarizedExperiment::colData(data)) %>%
                        rownames_to_column("sample_id")
                      data <- POMA::PomaCreateObject(metadata = metadata_df, features = as.data.frame(combined))
                      
                    }
                    
                    ## Table
                    
                    prepared_data <- as.data.frame(SummarizedExperiment::colData(data)) %>%
                      rownames_to_column("ID") %>%
                      select(1,2) %>%
                      bind_cols(as.data.frame(t(SummarizedExperiment::assay(data))))
                    
                    ##
                    
                    if(!input$combine_feat | input$example_data == "yes") {
                      cv_data <- NULL
                    }
                    
                    return(list(prepared_data = prepared_data, data = data, cv_data = cv_data))
                    
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

output$cv_combined <- DT::renderDataTable({
  
  if(is.null(prepareData()$cv_data)) {
    return(NULL)
  }
  else {
    
    DT::datatable(prepareData()$cv_data,
                  filter = 'none', extensions = 'Buttons',
                  escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                  options = list(
                    scrollX = TRUE,
                    dom = 'Bfrtip',
                    buttons = 
                      list("copy", "print", list(
                        extend="collection",
                        buttons=list(list(extend="csv",
                                          filename=paste0(Sys.Date(), "POMA_combined_features_CV")),
                                     list(extend="excel",
                                          filename=paste0(Sys.Date(), "POMA_combined_features_CV")),
                                     list(extend="pdf",
                                          filename=paste0(Sys.Date(), "POMA_combined_features_CV"))),
                        text="Dowload")),
                    order=list(list(2, "desc")),
                    pageLength = nrow(prepareData()$cv_data)))
    }
  })

##

observeEvent(input$upload_data, {
  output$report_button <- renderUI({
    downloadButton("report", "Exploratory report", style="color: #fff; background-color: #00b300; border-color: #009900")
  })
})

##

observeEvent(input$upload_data, {
  output$space <- renderUI({
    br()
  })
})

##

output$report <- downloadHandler(
  
  filename = paste0(Sys.Date(), "_POMA_EDA_report.pdf"),
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

