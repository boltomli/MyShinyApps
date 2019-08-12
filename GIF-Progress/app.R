library(shiny)
library(curl)

ui <- basicPage(
  imageOutput("inAnimation"),
  imageOutput("outAnimation"))

server <- function(input, output) {
  output$inAnimation <- renderImage({
    curl_download('https://github.com/nwtgck/ray-tracing-iow-rust/raw/develop/doc_assets/ray-tracing-animation.gif', 'infile.gif')
    
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
