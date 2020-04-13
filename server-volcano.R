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

output$vocalnoPlot <- renderPlotly({
  
  data_volcano <- ImputedData()$imputed
  
  POMA::PomaVolcano(data_volcano,
                    pval = input$pval,
                    pval_cutoff = input$pval_cutoff,
                    log2FC = input$log2FC,
                    xlim = input$xlim,
                    paired = input$paired_vol,
                    var_equal = input$var_equal_vol,
                    labels = FALSE,
                    interactive = TRUE)
})

