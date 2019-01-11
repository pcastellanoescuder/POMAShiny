
sidebarPanel(
  textInput("from", "From:", value="from@gmail.com"),
  textInput("to", "To:", value="to@gmail.com"),
  textInput("subject", "Subject:", value=""),
  actionButton("send", "Send mail")
)

mainPanel(    
  aceEditor("message", value="write message here")
)
