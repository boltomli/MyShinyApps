library(pinyin)
library(shiny)

ui <- fluidPage(
    
    titlePanel("Hanzi to Pinyin, Wubi..."),

    sidebarLayout(

        sidebarPanel(

            selectInput("dict_input", "Choose a way to load custom dictionary:",
                        choices = c("Default", "Fetch", "Upload")),
            
            uiOutput("dict_selector"),
            helpText("The dict for py() to load. By default the internal quanpin will be used"),

            textInput("text", "text to convert:", "输入文本"),

            textInput("sep", "separator to separate text:", ""),

            tags$hr(),
            helpText("View", a("source code on GitHub", href="https://github.com/boltomli/MyShinyApps", target="_blank")),

        ),
        
        mainPanel(

            textOutput("convert_result"),

        )
    )
)

server <- function(input, output) {
    dict_path <- reactiveVal("_")
    
    dict_input <- reactive({
        switch(input$dict_input,
               "Default" = "default",
               "Fetch" = "fetch-url",
               "Upload" = "upload")
    })

    dict_tone <- reactive({
        switch(input$dict_tone,
               "标准全拼" = "quanpin",
               "数字声调" = "tone",
               "没有声调" = "toneless")
    })
    
    dict_data <- reactive({
        req(dict_path())
        if (dict_path() == "_") {
            req(dict_tone())
            pydic(method = dict_tone())
        } else {
            load_dic(dict_path())
        }
    })

    output$dict_selector <- renderUI({
        dict_input_method <- dict_input()
        if (dict_input_method == "fetch-url") {
          list(
            textInput("file1", "Enter URL", value = config::get("dict_example")),
            actionButton("fetch-url", "Fetch")
          )
        } else if (dict_input_method == "upload") {
            fileInput("file_upload", "Upload")
        } else if (dict_input_method == "default") {
            selectInput("dict_tone", "Choose a way to show tone:",
                        choices = c("标准全拼", "数字声调", "没有声调"))
        }
    })
    
    # handle default
    observe({
        req(input$dict_tone)
        dict_path("_")
    })
    
    # handle upload
    observe({
        req(input$file_upload)
        upload_file <- input$file_upload
        dict_path(upload_file$datapath[[1]])
    })
    
    # handle fetch-url
    observeEvent(input[["fetch-url"]], {
        req(input$file1)
        tryCatch({
            # Fetch image from URL
            temp_fetch_url <- fs::file_temp('custom', ext = ".dict")
            downloader::download(input$file1, temp_fetch_url)
            
            dict_path(temp_fetch_url)
        }, error = function(e){
            # usually, you would not expose this to the user
            # without a little sanitization
            showNotification(as.character(safeError(e)), type = "warning")
        })  
    })
    
    output$convert_result <- renderText({
        req(dict_data())
        py(input$text, sep = input$sep, dic = dict_data())
    })

}

shinyApp(ui = ui, server = server)
