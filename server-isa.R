output$report2 <- downloadHandler(
  
  filename = "intelligent_report.pdf", 
  content = function(file) {
    
    if(input$from == 'beginning'){
      
    tempReport <- file.path(tempdir(), "intelligent_report.Rmd") 
    file.copy("intelligent_report.Rmd", tempReport, overwrite = TRUE) 
    
    # Set up parameters to pass to Rmd document
    
    params <- list(n = prepareData())
    
    } else{
      
      tempReport <- file.path(tempdir(), "intelligent_report2.Rmd") 
      file.copy("intelligent_report2.Rmd", tempReport, overwrite = TRUE) 
      
      params <- list(n = NormData())
      
    }

    rmarkdown::render(tempReport, output_file = file,
                      params = params,
                      envir = new.env(parent = globalenv())
    )
  }
)




