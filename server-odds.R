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

observe({
  
  data <- NormData()$norm_table %>% select_if(is.numeric)
  x <- colnames(data)

  updateSelectInput(session, "feat_odds", choices = x, selected = NULL)
  
})

##

ODDS <- 
  eventReactive(input$play_odds, 
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    data <- NormData()$normalized

                    odds_res <- POMA::PomaOddsRatio(data, 
                                                    feature_name = input$feat_odds, 
                                                    showCI = input$CIodds,
                                                    covariates = input$covariatesOdds)
                    
                    return(odds_res)
                    
                    })
                  })

######

output$odds_table <- DT::renderDataTable({
  
  odds <- ODDS()$OddsRatioTable
    
  DT::datatable(odds,
               filter = 'none',extensions = 'Buttons',
               escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
               options = list(
                 scrollX = TRUE,
                 dom = 'Bfrtip',
                 buttons = 
                   list("copy", "print", list(
                     extend="collection",
                     buttons=list(list(extend="csv",
                                       filename="POMA_OddsRatio"),
                                  list(extend="excel",
                                       filename="POMA_OddsRatio"),
                                  list(extend="pdf",
                                       filename="POMA_OddsRatio")),
                     text="Dowload")),
                 order=list(list(2, "desc")),
                 pageLength = nrow(odds)))
})

##

output$oddsPlot <- renderPlotly({
  ODDS()$OddsRatioPlot
})

