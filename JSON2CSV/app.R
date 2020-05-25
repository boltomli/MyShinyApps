library(shiny)
library(jsonlite)

ui <- fluidPage(
  
  titlePanel("JSON2CSV"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      fileInput("file_upload", "Upload JSON"),
      tags$hr(),
      downloadButton("csv_download", "Download CSV"),
      helpText("View", a("source code on GitHub", href="https://github.com/boltomli/MyShinyApps", target="_blank")),
      
    ),
    
    mainPanel(
      
      tableOutput("json_table"),
      tags$hr(),
      textOutput("json_text"),

    )
  )
)

server <- function(input, output, session) {
  
  json_path <- reactiveVal("sample.json")
  
  json_data <- reactive({
    req(json_path())
    fromJSON(json_path())
  })
  
  observe({
    req(input$file_upload)
    upload_file <- input$file_upload
    json_path(upload_file$datapath[[1]])
  })
  
  output$json_table <- renderTable({
    req(json_data())
    json_data()
  })

  output$json_text <- renderText({
    req(json_data())
    toJSON(json_data(), pretty = TRUE)
  })

  output$csv_download <- downloadHandler(
    filename = function() {
      paste0("www/", as.numeric(Sys.time()), ".csv")
    },
    content = function(file) {
      write.csv(json_data(), file)
  })

}

shinyApp(ui = ui, server = server)
