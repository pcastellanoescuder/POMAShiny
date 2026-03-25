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

  validate(need(length(levels(as.factor(as.data.frame(SummarizedExperiment::colData(data_volcano))[,1]))) == 2, "Only two groups allowed."))

  ttest_res <- POMA::PomaUnivariate(data_volcano, method = "ttest",
                                     paired = input$paired_vol,
                                     var_equal = input$var_equal_vol)

  if (input$pval == "raw") {
    volcano_df <- data.frame(feature = ttest_res$feature, fc = ttest_res$fold_change, pvalue = ttest_res$pvalue)
  } else {
    volcano_df <- data.frame(feature = ttest_res$feature, fc = ttest_res$fold_change, pvalue = ttest_res$adj_pvalue)
  }

  volcano_plot <- POMA::PomaVolcano(volcano_df,
                                     pval_cutoff = input$pval_cutoff,
                                     log2fc_cutoff = input$log2FC,
                                     labels = FALSE)

  ggplotly(volcano_plot) %>% plotly::config(
    toImageButtonOptions = list(format = "png"),
    displaylogo = FALSE,
    collaborate = FALSE,
    modeBarButtonsToRemove = c(
      "sendDataToCloud", "zoom2d", "select2d",
      "lasso2d", "autoScale2d", "hoverClosestCartesian", "hoverCompareCartesian"
    )
  )
})

