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

            tableOutput("selectedProviders")

        )
    )
)

server <- function(input, output, session) {
    
    output$availableProviders <- renderUI({
        checkboxGroupInput("providers", label = "Provider", choices = list_providers())
    })

    output$selectedProviders <- renderTable({
        input$providers
    }, colnames = F)

}

shinyApp(ui = ui, server = server)
