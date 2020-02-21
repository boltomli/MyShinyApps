library(tuneR)
library(XML)
library(httr)
library(jsonlite)
library(shiny)

ui <- fluidPage(
    
    titlePanel("Say something and play it in reverse"),

    sidebarLayout(

        sidebarPanel(

            textInput("text", "text to convert:", "文本"),
            tags$hr(),
            helpText("View", a("source code on GitHub", href="https://github.com/boltomli/MyShinyApps", target="_blank")),

        ),
        
        mainPanel(

            uiOutput("funny_result"),

        )
    )
)

server <- function(input, output) {
    output$funny_result <- renderUI({
          text <- input$text

          ssml <- newXMLDoc()
          ns <- c(xml = "http://www.w3.org/2000/xmlns")
          speak <- newXMLNode("speak", namespace = ns)
          addAttributes(speak, "version" = "1.0", "xml:lang" = "zh-cn")
          voice <- newXMLNode("voice", namespace = ns)
          addAttributes(voice, "xml:lang" = "zh-cn", "xml:gender" = "Female", "name" = "Microsoft Server Speech Text to Speech Voice (zh-CN, HuihuiRUS)")
          textNode <- newXMLTextNode(text = text)
          addChildren(voice, textNode)
          addChildren(speak, voice)
          addChildren(ssml, speak)

          issueTokenUri <- config::get("token_url")
          key <- config::get("subscription_key")
          tokenResult <- POST(issueTokenUri,
                              add_headers("Ocp-Apim-Subscription-Key" = key),
                              body = "")
          token <- content(tokenResult, as = "text")

          ttsUri <- config::get("tts_url")
          synthesisResult <- POST(ttsUri,
                                  content_type("application/ssml+xml"),
                                  add_headers(
                                      "X-Microsoft-OutputFormat" = "riff-16khz-16bit-mono-pcm",
                                      "Authorization" = paste("Bearer ", token),
                                      "X-Search-AppId" = "07D3234E49CE426DAA29772419F436CA",
                                      "X-Search-ClientID" = "1ECFAE91408841A480F00935DC390960"
                                  ),
                                  body = toString.XMLNode(ssml))
          synthesis <- content(synthesisResult, as = "raw")
          pcmfile <- file("temp.wav", "wb")
          writeBin(con = pcmfile, object = synthesis)
          close(pcmfile)

          pcmObj <- readWave('temp.wav')
          pcmObj@left <- rev(pcmObj@left)
          writeWave(pcmObj, 'www/reversed.wav')
          tags$audio(src = 'reversed.wav', type ="audio/wav", controls = T, autoplay = F)
    })
}

shinyApp(ui = ui, server = server)
