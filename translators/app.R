library(shiny)
library(reticulate)

source_python('translate.py')

ui <- fluidPage(
    
    titlePanel("Translators"),

    sidebarLayout(

        sidebarPanel(

            uiOutput("providers"),
            tags$hr(),
            helpText("View", a("source code on GitHub", href="https://github.com/boltomli/MyShinyApps", target="_blank")),

        ),
        
        mainPanel(

            #textInput("text"),

        )
    )
)

server <- function(input, output, session) {
    
    output$providers <- renderUI({
        checkboxGroupInput("provider", label = "Provider", choices = list_providers())
    })

}

shinyApp(ui = ui, server = server)
