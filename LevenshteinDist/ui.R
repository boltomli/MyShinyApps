shinyUI(fluidPage(
  titlePanel("Similarity score between two strings - https://en.wikipedia.org/wiki/Levenshtein_distance"),
  fluidRow(
    
    column(3,
           textInput("a",
                        label = h3("A"),
                        value = "Hello world!")),
    
    column(3,
           textInput("b",
                        label = h3("B"),
                        value = "Hello world again..."))
    ),

  mainPanel(
    h3(textOutput("result"))
  )
))