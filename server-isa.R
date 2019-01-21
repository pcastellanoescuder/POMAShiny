output$report2 <- downloadHandler(
  
  filename = "intelligent_report.html", 
  content = function(file){
    
    if(input$from == 'beginning'){
      
      if (length(levels(as.factor(prepareData()$Group))) == 2){
        
        tempReport <- file.path(tempdir(), "intelligent_report_2.Rmd") 
        file.copy("intelligent_report_2.Rmd", tempReport, overwrite = TRUE) 
        
        params <- list(n = prepareData(), pairedX = input$paired22) 
        
      }else{
        
        tempReport <- file.path(tempdir(), "intelligent_report_multiple.Rmd") 
        file.copy("intelligent_report_multiple.Rmd", tempReport, overwrite = TRUE) 
        
        params <- list(n = prepareData()) 
      }
      
    }else{
      
      if (length(levels(as.factor(NormData()$Group))) == 2){
        
        tempReport <- file.path(tempdir(), "intelligent_report_2_1.Rmd") 
        file.copy("intelligent_report_2_1.Rmd", tempReport, overwrite = TRUE) 
        
        params <- list(n = NormData(), pairedX = input$paired22) 
      }else{
        
        tempReport <- file.path(tempdir(), "intelligent_report_multiple_2.Rmd") 
        file.copy("intelligent_report_multiple_2.Rmd", tempReport, overwrite = TRUE) 
        
        params <- list(n = NormData()) 
        
      }
    }
    
    rmarkdown::render(tempReport, output_file = file,
                      params = params,
                      envir = new.env(parent = globalenv())
    )
  })

