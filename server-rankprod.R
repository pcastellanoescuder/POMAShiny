observe_helpers(help_dir = "help_mds")

Rank_Prod <- 
  eventReactive(input$rank_prod,
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    data <- NormData()
                    
                    data.cl <- as.numeric(as.factor(data$Group))
                    data.cl[data.cl == 1] <- 0
                    data.cl[data.cl == 2] <- 1
                    
                    class1 <- levels(as.factor(data$Group))[1]
                    class2 <- levels(as.factor(data$Group))[2]
                    
                    names <- make.names(data$ID, unique = TRUE)
                    
                    data <- data[,c(-1,-2)]
                    data <- t(data)
                    colnames(data) <- names
                    
                    RP <- RankProducts(data, data.cl, logged = input$param_rank_log, na.rm = TRUE, plot = FALSE, RandomPairs = eval(parse(text = input$paired3)),
                                       rand = 123, gene.names = rownames(data))
                    
                    top_rank <- topGene(RP, cutoff = input$cutoff, method = input$method, 
                                        logged = input$param_rank_log, logbase = input$param_rank_log_val,
                                        gene.names = rownames(data))
                    
                    one <- as.data.frame(top_rank$Table1)
                    two <- as.data.frame(top_rank$Table2)
                    
                    colnames(one)[3] <- paste0("FC: ", class1, "/", class2)
                    colnames(two)[3] <- paste0("FC: ", class1, "/", class2)
                    
                    one <- one[,-1]
                    two <- two[,-1]
                    
                    #### PLOT
                    
                    x <- RP
                    pfp = as.matrix(x$pfp)
                    
                    if (is.null(x$RPs)) {
                      RP1 = as.matrix(x$RSs)
                      rank = as.matrix(x$RSrank)
                    }
                    
                    if (!is.null(x$RPs)){
                      RP1 = as.matrix(x$RPs)
                      rank = as.matrix(x$RPrank)
                    }
                    
                    ind1 <- which(!is.na(RP1[, 1]))
                    ind2 <- which(!is.na(RP1[, 2]))
                    ind3 <- append(ind1, ind2)
                    ind3 <- unique(ind3)
                    RP.sort.upin2 = sort(RP1[ind1, 1], index.return = TRUE)
                    RP.sort.downin2 = sort(RP1[ind2, 2], index.return = TRUE)
                    pfp1 <- pfp[ind1, 1]
                    pfp2 <- pfp[ind2, 2]
                    rank1 <- rank[ind1, 1]
                    rank2 <- rank[ind2, 2]
                    
                    rp_plot <- data.frame(rank1 = rank1, rank2 = rank2, pfp1 = pfp1 ,  pfp2 = pfp2)
                    
                    plot1 <- ggplotly(ggplot(rp_plot, aes(x = rank1, y = pfp1)) +
                                        geom_point(size = 1.5, alpha=0.8) + 
                                        theme_minimal() +
                                        xlab("Number of identified metabolites") + 
                                        ylab("Estimated PFP"))
                    
                    plot2 <- ggplotly(ggplot(rp_plot, aes(x = rank2, y = pfp2)) +
                                        geom_point(size = 1.5, alpha=0.8) + 
                                        theme_minimal() +
                                        xlab("Number of identified metabolites") + 
                                        ylab("Estimated PFP"))
                    
                    
                    final.plot <- subplot(plot1, plot2, nrows = 2, shareX = TRUE, shareY = TRUE)
                    
                    final.plot <- final.plot %>%
                      layout(annotations = list(
                        list(x = 0.5 , y = 1.05, text = paste0("Identification of Up-regulated metabolites under class ", class2), 
                             showarrow = F, xref='paper', yref='paper'),
                        list(x = 0.5 , y = 0.5, text = paste0("Identification of Down-regulated metabolites under class ", class2), 
                             showarrow = F, xref='paper', yref='paper')))
                    
                    return(list(one = one, two = two, final.plot = final.plot))

                  })
                })


################# 

output$upregulated <- DT::renderDataTable({
  
  one <- Rank_Prod()$one

  as.datatable(formattable(one, list(P.value = color_tile("indianred2","white"),
                                     pfp = color_tile("indianred2","white"))), 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="rank_prod_upregulated"),
                                   list(extend="excel",
                                        filename="rank_prod_upregulated"),
                                   list(extend="pdf",
                                        filename="rank_prod_upregulated")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Rank_Prod()$one)))
})

output$downregulated <- DT::renderDataTable({

  two <- Rank_Prod()$two
  
  as.datatable(formattable(two, list(P.value = color_tile("indianred2","white"),
                                     pfp = color_tile("indianred2","white"))), 
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE,
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="rank_prod_downregulated"),
                                   list(extend="excel",
                                        filename="rank_prod_downregulated"),
                                   list(extend="pdf",
                                        filename="rank_prod_downregulated")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Rank_Prod()$two)))
})

output$rank_prod_plot <- renderPlotly({
  Rank_Prod()$final.plot
})

