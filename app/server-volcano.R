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

output$vocalnoPlot <- renderPlotly({
  
  data_volcano <- ImputedData()$imputed
  
  validate(need(length(levels(as.factor(Biobase::pData(data_volcano)[,1]))) == 2, "Only two groups allowed."))
  
  POMA::PomaVolcano(data_volcano,
                    pval = input$pval,
                    pval_cutoff = input$pval_cutoff,
                    log2FC = input$log2FC,
                    xlim = input$xlim,
                    paired = input$paired_vol,
                    var_equal = input$var_equal_vol,
                    labels = FALSE,
                    interactive = TRUE) %>% plotly::config(
                      toImageButtonOptions = list(format = "png"),
                      displaylogo = FALSE,
                      collaborate = FALSE,
                      modeBarButtonsToRemove = c(
                        "sendDataToCloud", "zoom2d", "select2d",
                        "lasso2d", "autoScale2d", "hoverClosestCartesian", "hoverCompareCartesian"
                      )
                    )
})

