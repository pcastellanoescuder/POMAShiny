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

Rank_Prod <- 
  eventReactive(input$rank_prod,
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    data <- ImputedData()$imputed
                    
                    validate(need(length(levels(as.factor(as.data.frame(SummarizedExperiment::colData(data))[,1]))) == 2, "Only two groups allowed."))
                    
                    if(input$paired_RP){
                      
                      rank_prod_res <- POMA::PomaRankProd(data,
                                                          logged = input$logged_RP,
                                                          paired = 1,
                                                          cutoff = input$cutoff_RP,
                                                          method = input$method_RP)
                    } else {

                      rank_prod_res <- POMA::PomaRankProd(data,
                                                          logged = input$logged_RP,
                                                          paired = NA,
                                                          cutoff = input$cutoff_RP,
                                                          method = input$method_RP)
                    }
                    
                    return(rank_prod_res)

                  })
                })

##

output$upregulated <- DT::renderDataTable({

  if(!is.null(Rank_Prod())){
    
    DT::datatable(Rank_Prod()$up_regulated,
                  filter = 'none',extensions = 'Buttons',
                  escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                  options = list(
                    scrollX = TRUE,
                    dom = 'Bfrtip',
                    buttons = 
                      list("copy", "print", list(
                        extend="collection",
                        buttons=list(list(extend="csv",
                                          filename=paste0(Sys.Date(), "POMA_rank_prod_upregulated")),
                                     list(extend="excel",
                                          filename=paste0(Sys.Date(), "POMA_rank_prod_upregulated")),
                                     list(extend="pdf",
                                          filename=paste0(Sys.Date(), "POMA_rank_prod_upregulated"))),
                        text="Dowload")),
                    order=list(list(2, "desc")),
                    pageLength = nrow(Rank_Prod()$up_regulated)))
    }
  })

##

output$downregulated <- DT::renderDataTable({
  
  if(!is.null(Rank_Prod())){
    
    DT::datatable(Rank_Prod()$down_regulated,
                  filter = 'none',extensions = 'Buttons',
                  escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                  options = list(
                    scrollX = TRUE,
                    dom = 'Bfrtip',
                    buttons = 
                      list("copy", "print", list(
                        extend="collection",
                        buttons=list(list(extend="csv",
                                          filename=paste0(Sys.Date(), "POMA_rank_prod_downregulated")),
                                     list(extend="excel",
                                          filename=paste0(Sys.Date(), "POMA_rank_prod_downregulated")),
                                     list(extend="pdf",
                                          filename=paste0(Sys.Date(), "POMA_rank_prod_downregulated"))),
                        text="Dowload")),
                    order=list(list(2, "desc")),
                    pageLength = nrow(Rank_Prod()$down_regulated)))
    }
  })

##

output$rank_prod_plot_up <- renderPlotly({
  plotly::ggplotly(
    ggplot() + annotate("text", x = 0.5, y = 0.5, label = "Rank Product plots are not available\nin the current POMA version.") + theme_void()
  )
})

##

output$rank_prod_plot_down <- renderPlotly({
  plotly::ggplotly(
    ggplot() + annotate("text", x = 0.5, y = 0.5, label = "Rank Product plots are not available\nin the current POMA version.") + theme_void()
  )
})

