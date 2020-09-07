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

observe({
  
  data <- Outliers()$norm_table %>% select_if(is.numeric)
  x <- colnames(data)

  updateSelectInput(session, "feat_odds", choices = x, selected = NULL)
  
})

##

ODDS <- 
  eventReactive(input$play_odds, 
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    data <- Outliers()$data
                    
                    validate(need(length(levels(as.factor(Biobase::pData(data)[,1]))) == 2, "Only two groups allowed."))
                    
                    odds_res <- POMA::PomaOddsRatio(data, 
                                                    feature_name = input$feat_odds, 
                                                    showCI = input$CIodds,
                                                    covariates = input$covariatesOdds)
                    
                    return(odds_res)
                    
                    })
                  })

####

output$odds_table <- DT::renderDataTable({
  
  odds <- ODDS()$OddsRatioTable %>%
    mutate(OddsRatio = round(OddsRatio, 3),
           CILow = round(CILow, 3),
           CIHigh = round(CIHigh, 3))
    
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
                                       filename=paste0(Sys.Date(), "POMA_OddsRatio")),
                                  list(extend="excel",
                                       filename=paste0(Sys.Date(), "POMA_OddsRatio")),
                                  list(extend="pdf",
                                       filename=paste0(Sys.Date(), "POMA_OddsRatio"))),
                     text="Dowload")),
                 order=list(list(2, "desc")),
                 pageLength = nrow(odds)))
})

##

output$oddsPlot <- renderPlotly({
  ggplotly(ODDS()$OddsRatioPlot) %>% plotly::config(
    toImageButtonOptions = list(format = "png"),
    displaylogo = FALSE,
    collaborate = FALSE,
    modeBarButtonsToRemove = c(
      "sendDataToCloud", "zoom2d", "pan2d", "select2d",
      "lasso2d", "autoScale2d", "hoverClosestCartesian", "hoverCompareCartesian"
    )
  )
})

