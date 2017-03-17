shinyUI(fluidPage(
  titlePanel("24 (or any number) resolver - thanks to http://rosettacode.org/wiki/24_game/Solve#R"),
  fluidRow(
    
    column(3,
           numericInput("a", 
                        label = h3("A"), 
                        value = 3)),
    
    column(3,
           numericInput("b", 
                        label = h3("B"), 
                        value = 3)),

    column(3, 
           numericInput("c", 
                        label = h3("C"), 
                        value = 7)),
    
    column(3, 
           numericInput("d", 
                        label = h3("D"), 
                        value = 7))   
  ),
  
  fluidRow(
    column(3, 
           numericInput("t", 
                        label = h3("Target"), 
                        value = 24))
  ),
  
  fluidRow(
    column(3, 
           textInput("o", 
                        label = h3("Operators"), 
                        value = "+-*/^"))
  ),
  
  mainPanel(
    h3(htmlOutput("result"))
  )
))