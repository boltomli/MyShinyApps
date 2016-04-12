shinyServer(
  function(input, output) {
    library(RecordLinkage)
    score <- reactive({
      levenshteinSim(tolower(trimws(input$a)), tolower(trimws(input$b)))})
    
    output$result <- renderText(score())
  }
)