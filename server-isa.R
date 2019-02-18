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

output$report2 <- downloadHandler(
  
  filename = "automatic_statistical_report.html", 
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

