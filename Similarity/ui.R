shinyUI(fluidPage(
  titlePanel("Similarity score between two strings"),
  fluidRow(
    
    column(3,
           textInput("a",
                        label = h3("A"),
                        value = "Hello world")),
    
    column(3,
           textInput("b",
                        label = h3("B"),
                        value = "Hello world again"))
    ),

  mainPanel(
    helpText("Similarity between 1 (the same) and 0 (totally different)"),
    tags$hr(),
    textOutput("levenshtein"),
    helpText("1 - ", a("Levenshtein distance", href="https://en.wikipedia.org/wiki/Levenshtein_distance"), " / characters of the longer string"),
    textOutput("cosine"),
    helpText(a("Cosine similarity", href="https://en.wikipedia.org/wiki/Cosine_similarity"), "calculated by word"),
    tags$hr(),
    helpText("View", a("source code on GitHub", href="https://github.com/boltomli/MyShinyApps"))
  )
))