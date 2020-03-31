shinyServer(
  function(input, output) {
    library(textTinyR)
    library(stringr)

    str1 <- reactive({trimws(input$a)})
    
    str2 <- reactive({trimws(input$b)})
    
    output$levenshtein <- renderText({
      req(str1())
      req(str2())
      1 - levenshtein_distance(str1(), str2()) / max(str_length(c(str1(), str2())))
    })

    output$cosine <- renderText({
      req(str1())
      req(str2())
      cosine_distance(str1(), str2())
    })
  }
)