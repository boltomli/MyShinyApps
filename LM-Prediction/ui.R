shinyUI(fluidPage(
  titlePanel("Linear Regression"),
  fluidRow(
    
    column(3,
           numericInput("x1", 
                        label = h3("X1"), 
                        value = 1)),
    
    column(3,
           numericInput("y1", 
                        label = h3("Y1"), 
                        value = 1.1))
  ),
    
  fluidRow(
    column(3, 
           numericInput("x2", 
                        label = h3("X2"), 
                        value = 2.1)),
    
    column(3, 
           numericInput("y2", 
                        label = h3("Y2"), 
                        value = 2))   
  ),
  
  fluidRow(
    column(3, 
           numericInput("x3", 
                        label = h3("X3"), 
                        value = 3.1)),
    
    column(3, 
           numericInput("y3", 
                        label = h3("Y3"), 
                        value = 3.2))   
  ),
  
  fluidRow(
    column(3, 
           numericInput("x", 
                        label = h3("X"), 
                        value = 4))
  ),
  
  mainPanel(
    h3(textOutput("y")),
    textOutput("f"),
    plotOutput("p")
  )
))