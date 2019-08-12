library(shiny)
library(curl)

ui <- fluidPage(
  titlePanel("Add progress bar to GIF (by https://github.com/nwtgck/gif-progress)"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("inURL", "GIF URL", "https://github.com/nwtgck/ray-tracing-iow-rust/raw/develop/doc_assets/ray-tracing-animation.gif")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Original GIF", imageOutput("inAnimation")),
        tabPanel("GIF with progress bar", imageOutput("outAnimation"))
        )
      )
    )
  )

server <- function(input, output) {
  url <- reactive({input$inURL})
  output$inAnimation <- renderImage({
    curl_download(url(), 'infile.gif')
    
    # Return a list containing the filename
    list(src = "infile.gif",
         contentType = 'image/gif',
         alt = "original"
    )}, deleteFile = FALSE)
  output$outAnimation <- renderImage({
    system("cat infile.gif | ./gif-progress > outfile.gif")
    list(src = "outfile.gif",
         contentType = 'image/gif',
         alt = "with progress bar"
    )}, deleteFile = FALSE)
  }

shinyApp(ui, server)
