shinyServer(
  function(input, output) {
    
    fit <- reactive({
      x <- c(input$x1, input$x2, input$x3)
      y <- c(input$y1, input$y2, input$y3)
      fit <- lm(y ~ x, data.frame(x, y))
    })

    output$p <- renderPlot({
      x <- c(input$x1, input$x2, input$x3)
      y <- c(input$y1, input$y2, input$y3)
      plot(data.frame(x, y))
      abline(fit())
    })
    
    output$f <- renderPrint({
      summary(fit())
    })
    
    pre <- reactive({
      predict(fit(), newdata=data.frame(x=input$x))
    })
    
    output$y <- renderText({ 
      paste("Predicted Y = ", pre())
    })
    
  }
)