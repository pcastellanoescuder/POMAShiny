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

## TARGET ------------------------
targetInput <- reactive({
  
  if (input$example_data == "yes") {
    
    if (input$example_dataset == "st000284") {
      target <- SummarizedExperiment::colData(st000284) %>% 
        dplyr::as_tibble() %>% 
        tibble::rownames_to_column("ID") %>% 
        dplyr::rename(Group = 2)
    } else {
      target <- SummarizedExperiment::colData(st000336) %>% 
        dplyr::as_tibble() %>% 
        tibble::rownames_to_column("ID") %>% 
        dplyr::rename(Group = 2) 
    } 
    
    return(target)
  }
  
  else if (input$example_data == "user_data") {
    
    infile <- input$target
    
    if (is.null(infile)) {
      return(NULL)
    } 
    
    else {
      target <- readr::read_csv(infile$datapath) %>% 
          dplyr::rename(ID = 1, Group = 2)
        
      validate(need(
        sum(apply(target[, 1], 2, function(x){sum(is.na(x), na.rm = TRUE)})) == 0, 
        "Detected missing values in the ID column."))
      
      validate(need(
        sum(apply(target[, 2], 2, function(x){sum(is.na(x), na.rm = TRUE)})) == 0, 
        "Detected missing values in the group column."))
      
      return(target)
    }
  }
})

## FEATURES ------------------------
featuresInput <- reactive({
  
  if (input$example_data == "yes") {
    
    if (input$example_dataset == "st000284") {
      features <- t(SummarizedExperiment::assay(st000284))
    } else {
      features <- t(SummarizedExperiment::assay(st000336)) 
    }

    return(features)
  }
  
  else if (input$example_data == "user_data") {
    
    infile <- input$omicsdata
    
    if (is.null(infile)) {
      return(NULL)
    } 
    
    else {
      features <- readr::read_csv(infile$datapath)
      return(features)
    }
  }
})

## COMBINE FEATURES ------------------------
# combInput <- reactive({
#   
#   infile <- input$combine_data
#   
#   if (is.null(infile)){
#     return(NULL)
#   }
#   
#   else {
#     combine_data <- read_csv(infile$datapath)
#     
#     validate(need(sum(apply(combine_data, 2, function(x){sum(is.na(x), na.rm = TRUE)})) == 0, 
#                   "Missing values not allowed in grouping file."))
#     
#     validate(need(ncol(combine_data) == 3,
#                   "Grouping file must be a CSV with three columns (feature, grouping factor and new feature name)."))
#     
#     combine_data <- combine_data %>% 
#       dplyr::rename(feature = 1, grp = 2, new_feat = 3)
#     
#     return(combine_data)
#   }
# })

## FORMAT DATA ------------------------
prepareData <- 
  eventReactive(input$submit_data,
                ignoreNULL = TRUE, {
                  withProgress(message = "Preparing data, please wait", {
                    
                    target <- targetInput()
                    features <- featuresInput()
  
                    prepared_data <- cbind(target, features)
                    
                    validate(need(
                      sum(apply(features, 2, function(x){sum(x < 0, na.rm = TRUE)})) == 0,
                      "Detected negative values."))
                  
                    ## Select rows
                    if (!is.null(input$targetbox_rows_selected)) {
                      prepared_data <- prepared_data[input$targetbox_rows_selected ,]
                    } 
                    
                    target <- prepared_data[, c(1:ncol(target))]
                    features <- prepared_data[, -c(1:ncol(target))]
                    
                    poma_object <- POMA::PomaSummarizedExperiment(target, features)
                    
                    # if (input$combine_feat & input$example_data == "user_data") {
                    #   
                    #   comb_data <- combInput()
                    #   
                    #   validate(need(!is.null(comb_data), "Please upload a grouping file."))
                    #   
                    #   grp <- as.factor(comb_data$grp)
                    #   nms <- unique(comb_data$new_feat)
                    # 
                    #   data <- MSnbase::combineFeatures(data, groupBy = grp, method = input$method_comb)
                    #   featureNames(data) <- nms
                    #   
                    #   cv_data <- featureData(data)@data %>%
                    #     t() %>% 
                    #     as_tibble() %>%
                    #     select_if(~ sum(!is.na(.)) > 0) %>%
                    #     mutate(ID = rownames(SummarizedExperiment::colData(data))) %>%
                    #     select(ID, everything())
                    #   
                    # }
                    
                    prepared_data <- SummarizedExperiment::colData(poma_object) %>%
                      as.data.frame() %>% 
                      tibble::rownames_to_column("ID") %>%
                      dplyr::select(1:2) %>%
                      dplyr::bind_cols(as.data.frame(t(SummarizedExperiment::assay(poma_object))))
                    
                    if (!input$combine_feat | input$example_data == "yes") {
                      cv_data <- NULL
                    }
                    
                    return(list(prepared_data = prepared_data, 
                                poma_object = poma_object, 
                                cv_data = cv_data)
                           )
                    })
})

## OUTPUT - TARGET ------------------------
output$targetbox <- DT::renderDataTable({
  datatable(targetInput(), 
            class = 'cell-border stripe', 
            rownames = FALSE, 
            filter = "top", 
            extensions = 'Buttons', 
            options = list(scrollX = TRUE,
                           lengthMenu = list(c(10, 25, 50, 100, -1),
                                             c('10','25','50', '100', 'All'))
                           )
  )
})

## OUTPUT - FEATURES ------------------------
output$featuresbox <- DT::renderDataTable({
  
  features <- featuresInput() %>% 
    as.data.frame() %>% 
    dplyr::mutate_if(is.numeric, ~ signif(., digits = 3))
    
  datatable(features,
            class = 'cell-border stripe', 
            rownames = FALSE, 
            options = list(scrollX = TRUE)
            )
})

## OUTPUT - FORMAT DATA ------------------------
output$submited <- DT::renderDataTable({
  
  if (!is.null(prepareData()$prepared_data)) {
    prepared_data <- prepareData()$prepared_data %>% 
      as.data.frame() %>% 
      dplyr::mutate_if(is.numeric, ~ signif(., digits = 3)) 
  } else {
    prepared_data <- NULL
  }
  
  datatable(prepared_data, 
            class = 'cell-border stripe', 
            rownames = FALSE, 
            options = list(scrollX = TRUE)
            )
})

## OUTPUT - COMBINE FEATURES ------------------------
# output$cv_combined <- DT::renderDataTable({
#   
#   if(is.null(prepareData()$cv_data)) {
#     return(NULL)
#   }
#   else {
#     
#     DT::datatable(prepareData()$cv_data,
#                   filter = 'none', extensions = 'Buttons',
#                   escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
#                   options = list(
#                     scrollX = TRUE,
#                     dom = 'Bfrtip',
#                     buttons = 
#                       list("copy", "print", list(
#                         extend="collection",
#                         buttons=list(list(extend="csv",
#                                           filename=paste0(Sys.Date(), "POMA_combined_features_CV")),
#                                      list(extend="excel",
#                                           filename=paste0(Sys.Date(), "POMA_combined_features_CV")),
#                                      list(extend="pdf",
#                                           filename=paste0(Sys.Date(), "POMA_combined_features_CV"))),
#                         text="Dowload")),
#                     order=list(list(2, "desc")),
#                     pageLength = nrow(prepareData()$cv_data)))
#     }
#   })

## OUTPUT - REPORT ------------------------
observeEvent(input$submit_data, {
  output$report_button <- renderUI({
    downloadButton("report", "Exploratory report", 
                   style="color: #fff; background-color: #00b300; border-color: #009900")
  })
})

observeEvent(input$submit_data, {
  output$space <- renderUI({
    br()
  })
})

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

