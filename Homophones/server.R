shinyServer(
  function(input, output) {
    library(stringi)
    library(Unicode)

    Unihan_Readings <- read.delim("raw/Unihan_Readings.txt", header=FALSE, comment.char="#", stringsAsFactors=FALSE, col.names = c("code", "key", "value"))
    types <- read.table("unihan_readings/types.csv", col.names = c("type"))

    output$lang_selector <- renderUI({
      selectInput("lang", "选择一个语言或方言：",
                  choices = types$type)
    })

    pronunciations <- reactive({
      zi <- trimws(input$zi)[[1]]
      zi <- substr(zi, start = nchar(zi), stop = nchar(zi))
      cp <- paste("U+", toupper(sprintf("%x", as.numeric(stri_enc_toutf32(zi)))), sep = "")
      split_by <- " "
      if (input$lang %in% c("kHanyuPinyin", "kTGHZ2013", "kXHC1983")) split_by <- "[ :,0-9\\.]"
      strsplit(as.character(Unihan_Readings$value[which(input$lang == Unihan_Readings$key & Unihan_Readings$code == cp)]), split_by)[[1]]
    })

    characters <- reactive({
      req(pronunciations())
      zi_same_p <- unlist(lapply(pronunciations(), function(x) {
        Unihan_Readings$code[which(input$lang == Unihan_Readings$key & sapply(strsplit(as.character(Unihan_Readings$value), "[ :,]"), function(x, y) y %in% x, x))]}))
      unlist(lapply(as.list(zi_same_p), function(x) {
        u_char_inspect(as.character(x))['Char']
      }))
    })
    
    output$pronunciation <- renderText({
      req(pronunciations())
      pronunciations()
    })

    output$result <- renderText({
      req(characters())
      characters()
    })
  }
)
