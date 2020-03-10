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

PLOTVolcano <- reactive({
  
  to_volcano <- DataExists2()
  samples_groups <- to_volcano[, 1:2]
  colnames(samples_groups)[1:2] <- c("ID", "Group")
  Group <- samples_groups$Group
  to_volcano <- to_volcano[, c(3:ncol(to_volcano))]

  ####
  
  log2FC <- 2^(input$log2FC)
  
  #### ttest
  
  stat <- function(x) {
    t.test(x ~ Group, na.rm = TRUE, alternative = c("two.sided"), 
           var.equal = input$var_equalV, 
           paired = input$pairedV)$p.value
  }
  
  stat_G2 <- function(x) {
    t.test(x ~ Group, na.rm = TRUE, alternative = c("two.sided"), 
           var.equal = input$var_equalV)$estimate[[2]]
  }
  
  stat_G1 <- function(x) {
    t.test(x ~ Group, na.rm = TRUE, alternative = c("two.sided"), 
           var.equal = input$var_equalV)$estimate[[1]]
  }
  
  p <- data.frame(pvalue = apply(FUN = stat, MARGIN = 2, X = to_volcano))
  p <- p %>% 
    rownames_to_column("feature") %>% 
    as_tibble() %>% 
    mutate(pvalue_Adj = p.adjust(pvalue, method = "fdr")) %>% 
    column_to_rownames("feature")
  G2 <- round(data.frame(Mean_G2 = apply(FUN = stat_G2, 
                                         MARGIN = 2, X = to_volcano)), 3)
  G1 <- round(data.frame(Mean_G1 = apply(FUN = stat_G1, 
                                         MARGIN = 2, X = to_volcano)), 3)
  means <- cbind(G1, G2)
  means <- means %>% rownames_to_column("feature") %>% 
    mutate(Fold_Change_Ratio = as.numeric(round(Mean_G2/Mean_G1, 3)), 
           Difference_Of_Means = as.numeric(round(Mean_G1 - Mean_G2, 3))) %>% 
    column_to_rownames("feature")
  df <- cbind(means, p)
  
  ####
  
  names <- colnames(to_volcano)
  
  if(input$pvaltype == "raw"){
    df <- data.frame(pvalue = df$pvalue, FC = log2(df$Fold_Change_Ratio), names = names)
  }
  else{
    df <- data.frame(pvalue = df$pvalue_Adj, FC = log2(df$Fold_Change_Ratio), names = names)
  }
  
  df <- mutate(df, threshold = as.factor(ifelse(df$pvalue >= input$pval_cutoff,
                                                yes = "none",
                                                no = ifelse(df$FC < log2(log2FC),
                                                            yes = ifelse(df$FC < -log2(log2FC),
                                                                         yes = "Down-regulated",
                                                                         no = "none"),
                                                            no = "Up-regulated"))))
  
  volcanoP <- ggplot(data = df, aes(x = FC, y = -log10(pvalue), colour = threshold, label = names)) +
    geom_point(size=1.75) +
    xlim(c(-(input$xlim), input$xlim)) +
    xlab("log2 Fold Change") +
    ylab("-log10 p-value") +
    scale_y_continuous(trans = "log1p")+
    ggtitle(paste0("Comparisson: ", names(table(samples_groups$Group))[2], "/",
                   names(table(samples_groups$Group))[1])) +
    geom_vline(xintercept = -log2(log2FC), colour = "black", linetype = "dashed") +
    geom_vline(xintercept = log2(log2FC), colour = "black", linetype = "dashed") +
    geom_hline(yintercept = -log10(input$pval_cutoff), colour = "black", linetype = "dashed") +
    theme(legend.position = "none") +
    labs(color = "") +
    theme_bw() +
    scale_color_manual(values = c("Down-regulated" = "#E64B35", "Up-regulated" = "#3182bd", "none" = "#636363"))
  
    volcanoP <- plotly::ggplotly(volcanoP)
  
  return(volcanoP)
  
})

##

output$vocalnoPlot <- renderPlotly({
  
  PLOTVolcano()

})

