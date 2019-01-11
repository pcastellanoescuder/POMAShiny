
observe({
  if(is.null(input$send) || input$send==0) return(NULL)
  from <- isolate(input$from)
  to <- isolate(input$to)
  subject <- isolate(input$subject)
  msg <- isolate(input$message)
  sendmail(from, to, subject, msg)
})