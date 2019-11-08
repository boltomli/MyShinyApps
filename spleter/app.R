library(magrittr)
library(reticulate)  # Used to call Python script
library(shiny)

source_python('separate.py')

ui <- fluidPage(
    
    titlePanel("Audio Separator"),

    sidebarLayout(

        sidebarPanel(

            selectInput("audio_input", "Choose a way to get audio:",
                        choices = c("Fetch", "Upload")),
            
            uiOutput("audio_selector"),
            helpText("The audio will be separated to vocals and accompaniment."),

            tags$hr(),
            helpText("View", a("source code on GitHub", href="https://github.com/boltomli/MyShinyApps", target="_blank")),

        ),
        
        mainPanel(

            tableOutput("audio_info"),

            tags$hr(),
            helpText("Accompaniment result:"),
            uiOutput("audio_accompaniment"),
            helpText("Press the ... and download if you wish.")

        )
    )
)

server <- function(input, output, session) {
    
    # the file on disk
    audio_path <- reactiveVal("audio_example.mp3")
    
    audio_prefix <- "tf_audio"
    
    audio_input <- reactive({
        switch(input$audio_input,
               "Fetch" = "fetch-url",
               "Upload" = "upload")
    })

    audio_data <- reactive({
        req(audio_path())
        # Call function from Python script
        load_audio(audio_path())
    })
        
    output$audio_selector <- renderUI({
        audio_input_method <- audio_input()
        if (audio_input_method == "fetch-url") {
          list(
            textInput("file1", "Enter URL", value = config::get("audio_example")),
            actionButton("fetch-url", "Fetch")
          )
        } else if (audio_input_method == "upload") {
          fileInput("file_upload", "Upload audio")
        }
    })
    
    # handle upload
    observe({
        req(input$file_upload)
        upload_file <- input$file_upload
        audio_path(upload_file$datapath[[1]])
    })
    
    # handle fetch-url
    observeEvent(input[["fetch-url"]], {
        req(input$file1)
        tryCatch({
            # Fetch image from URL
            temp_fetch_url <- fs::file_temp(audio_prefix, ext = ".audio")
            downloader::download(input$file1, temp_fetch_url)
            
            audio_path(temp_fetch_url)
        }, error = function(e){
            # usually, you would not expose this to the user
            # without a little sanitization
            showNotification(as.character(safeError(e)), type = "warning")
        })  
    })
    
    output$audio_info <- renderTable({
        req(audio_data())
        waveform <- audio_data()
        samplings <- waveform[1][[1]]
        channels <- dim(samplings)[2]
        sampling_rate <- as.integer(waveform[2])
        audio_length <- length(samplings) / channels / sampling_rate
        data.frame("Second"=audio_length, "Rate"=sampling_rate, "Channel"=channels)
    })

    output$audio_accompaniment <- renderUI({
        req(audio_data())
        waveform <- audio_data()
        samplings <- waveform[1][[1]]
        sampling_rate <- as.integer(waveform[2])
        separated <- separate(samplings)
        instrument <- "accompaniment"
        save_audio(audio_prefix, instrument, separated[[instrument]], sampling_rate)
        source <- paste(audio_prefix, instrument, sep = "/")
        tags$audio(id='audio_accompaniment',
                   controls = "controls",
                   tags$source(
                       src = markdown:::.b64EncodeFile(paste(source, ".wav", sep = "")),
                       type='audio/wav'))
    })
}

shinyApp(ui = ui, server = server)
