library(shiny)
library(reticulate)

source_python('translate.py')

ui <- fluidPage(
    
    titlePanel("Translators"),

    sidebarLayout(

        sidebarPanel(

            uiOutput("availableProviders"),
            tags$hr(),
            helpText("View", a("source code on GitHub", href="https://github.com/boltomli/MyShinyApps", target="_blank")),

        ),
        
        mainPanel(

            textAreaInput("text", "Text to translate", resize = "vertical"),
            tableOutput("translateWithSelectedProviders")

        )
    )
)

server <- function(input, output, session) {
    
    output$availableProviders <- renderUI({
        providers <- list_providers()
        checkboxGroupInput("providers", label = "Provider", choices = providers)
    })

    output$translateWithSelectedProviders <- renderTable({
        if (input$text != "") {
            providers <- input$providers
            translations <- sapply(providers, function(x) translate(input$text, x, use_cn_host=TRUE))
            result <- data.frame(providers, translations)
            colnames(result) <- c("Provider", "Translation")
            result
        }
    })

}

shinyApp(ui = ui, server = server)
