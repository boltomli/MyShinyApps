shinyUI(fluidPage(
  titlePanel("Similarity score between two strings"),
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
    textOutput("result"),
    tags$hr(),
    helpText("Similarity between 1 (the same) and 0 (totally different) = 1 - ", a("Levenshtein distance", href="https://en.wikipedia.org/wiki/Levenshtein_distance")),
    helpText("View", a("source code on GitHub", href="https://github.com/boltomli/MyShinyApps"))
  )
))