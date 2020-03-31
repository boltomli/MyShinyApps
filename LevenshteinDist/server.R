shinyServer(
  function(input, output) {
    library(textTinyR)
    library(stringr)
    score <- reactive({
      str1 <- trimws(input$a)
      str2 <- trimws(input$b)
      1 - levenshtein_distance(str1, str2) / max(str_length(c(str1, str2)))
    })
    
    output$result <- renderText(score())
  }
)