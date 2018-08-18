EnrichInput <- reactive({ 
  
  example<-read.csv("llibreria_arreglada.csv",header=T,sep=",")
  inFileE <- input$file1
  if (!is.null(inFileE)){
    
    data_enrich<-read.csv(inFileE$datapath, header=input$header, 
                     sep=input$sep, quote=input$quote,row.names=1) 		
    
  }
  
  switch(input$dataset,
         "example" = example,
         "upload" = data_enrich
  )	


 #   datalibrary<- as.data.frame(read.csv("llibreria_arreglada.csv", sep=","))
  #  data_merge <- merge(dades_p, datalibrary, by.x="row.names", by.y="ID", all.y = T)
   # y <- colnames(data_merge)
    #updateSelectInput(session, "value_food", choices=y, selected=y[length(y)-2])
    #print(data_merge)}
})

Enrich_analisis <- eventReactive(input$play_test_enrich, 
                                 ignoreNULL = TRUE,{
                                   withProgress(message = "Analysing data, please wait",{
                                    dades_p<-Univ_analisis()$p
                                    datalibrary<-EnrichInput()
                                     
                                     #holamagali$fac<- as.factor(holamagali$fac)
                                 data_merge <- merge(dades_p, datalibrary, by.x="row.names", by.y=colnames(datalibrary)[1],all.y = T)
                                       #1.To determine the significant metabolites in each subpathway
                                   if (input$select_method=="before_FDR"){
                                     met_sign <- subset(data_merge, P.Value<0.05)
                                     } 
                                 else if (input$select_method=="after_FDR") {
                                   met_sign <- subset(data_merge, adj.P.Val<0.05) }
                                       
                                      numsig_class <- as.data.frame(as.array(summary(met_sign$class)))
                                       
                                       colnames(numsig_class) <- "B" #n detected/pathway
                                       #2. To determine the metabolites that there are in each subpathway
                                       num_class <- as.data.frame(as.array(summary(data_merge$class))) 
                                       colnames(num_class) <- "A" #n total/pathway
                                       
                                       #3. To sum the significant metabolites
                                       C <- nrow(met_sign) #n of significant
                                       
                                       #4. Create the enrichment table
                                       
                                       all <- merge(numsig_class, num_class, by="row.names")
                                       
                                       all$R <- all$B/all$A #ratio detected/total per pathway
                                       all$C <- rep(C) #n significants
                                       all$D <- rep(nrow(data_merge)) #n total identified
                                       all$R2 <- all$C/all$D #ratio signiticants/total identified
                                       all$E <- all$R/all$R2 #enrichment (ratio BA/ratioCD)
                                       
                                       all <- all[order(-all$E),]
                                       
                                       colnames(all) <- c("Class compounds", "Significant", "Detected", "Ratio Sign/Detect", "All Sign", "All Detect", "All Ratio", "Enrichment")
                                       
                                       #5. Calculate p value of enrichment
                                       
                                       all$p <- rep(" ", length(nrow(all)))
                                       
                                       for (i in 1:nrow(all)){
                                         all[i,2:ncol(all)] <- as.numeric(all[i,2:ncol(all)])
                                         all[i,9] <- phyper(all[i,2]-1,all[i,3],all[i,6]-all[i,3] ,all[i,5], lower.tail = FALSE)
                                       }
                                       
                                       all <- all[order(as.numeric(all$p)),]
                                       
                                       all$p <- round(as.numeric(all$p), digits=10)
                                       
                                       all <- as.data.frame(all)
                                       
                                       
                                       #6. adjusted by fdr
                                       
                                       all$FDR <- all$p
                                       all$FDR <- p.adjust(all$FDR, method="fdr")
                                       all <- as.data.frame(all)
                                       
                                  #################
                                       
                                       barplot_plot <-  ggplot(all, aes(y=Enrichment, x=reorder(ID,-p), fill=all$p))+ 
                                         geom_bar(stat="identity")+
                                         coord_flip(ylim=c(0:25))+
                                         scale_y_continuous()+
                                         labs(x = "Pathways", y = "Significant/Detected" )+
                                         scale_fill_continuous(low = "grey30", high = "grey89")+ 
                                         geom_text(aes(label=paste(all$"Class compounds")),size=4, hjust=0)+ 
                                         theme(axis.text= element_text(colour="black" ),legend.position="none", panel.background = element_blank(), axis.line = element_line(colour = "black"),axis.text.y = element_text(size=18,colour = "black"),axis.text.x = element_text(size=18,colour = "black"), axis.title = element_text(size = 14))                                       
                                       
                                       final <- list(all=all, barplot_plot=barplot_plot)
                                       return(final)
                                       
                                   }) # tanco withProgress
                                 })






output$matriu_enrich <- DT::renderDataTable({
  
  DT::datatable(Enrich_analisis()$all)
})


output$bar_plot <- renderPlot({
  Enrich_analisis()$barplot_plot}, width=800, height=800)


