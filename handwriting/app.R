library(reticulate)
library(shiny)

source_python('ttf2webp.py')

ui <- fluidPage(
    
    titlePanel("Handwriting Text"),

    sidebarLayout(

        sidebarPanel(

            textInput("text", "Text to write:", "月是故乡明"),
            tags$hr(),
            helpText("View", a("source code on GitHub", href="https://github.com/boltomli/MyShinyApps", target="_blank")),

        ),
        
        mainPanel(

            imageOutput("text_handwriting_image"),
            tags$hr(),
            helpText("Handwriting style simulated with", a("handright", href="https://github.com/Gsllchb/Handright", target="_blank")),
            helpText("Embeded font 沐目体", a("MMT", href="https://github.com/Lruihao/MMT", target="_blank"), "for personal non-commercial use only")

        )
    )
)

server <- function(input, output, session) {
    
    output$text_handwriting_image <- renderImage({
        text <- input$text
        convert(text, "embed.ttf", "saved.webp")
        list(src = "saved.webp",
             contentType = "image/webp",
             alt = text)
    }, deleteFile = T)
}

shinyApp(ui = ui, server = server)
