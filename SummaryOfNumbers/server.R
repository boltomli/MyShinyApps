options(shiny.maxRequestSize = 30*1024^2)

shinyServer(function(input, output) {
  output$contents <- renderTable({
    inFile <- input$file
    
    if (is.null(inFile))
      return(NULL)
    
    summary(read.csv(inFile$datapath, header = input$header,
                     sep = input$sep, quote = input$quote, fileEncoding = input$enc))
  })
  
  output$plot <- renderPlot({
    inFile <- input$file
    
    if (is.null(inFile))
      return(NULL)
    
    plot(read.csv(inFile$datapath, header = input$header,
                     sep = input$sep, quote = input$quote, fileEncoding = input$enc))
  })
})
