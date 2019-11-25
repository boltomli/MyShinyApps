shinyServer(
  function(input, output) {
    library(stringi)
    library(Unicode)

    Unihan_Readings <- read.delim("Unihan_Readings.txt", header=FALSE, comment.char="#", stringsAsFactors=FALSE, col.names = c("code", "key", "value"))

    lang_input <- reactive({
      switch (input$lang,
        "汉语（普通话 / Mandarin）" = "kMandarin",
        "汉语（粤语 / Cantonese）" = "kCantonese",
        "韩语（Korean / Hangul）" = "kKorean",
      )
    })

    pronunciations <- reactive({
      req(lang_input())
      zi <- trimws(input$zi)[[1]]
      zi <- substr(zi, start = nchar(zi), stop = nchar(zi))
      cp <- paste("U+", toupper(sprintf("%x", as.numeric(stri_enc_toutf32(zi)))), sep = "")
      strsplit(as.character(Unihan_Readings$value[which(Unihan_Readings$code == cp & Unihan_Readings$key == lang_input())]), " ")[[1]]
    })

    characters <- reactive({
      req(pronunciations())
      zi_same_p <- unlist(lapply(pronunciations(), function(x) {
        Unihan_Readings$code[which(grepl(as.character(x), Unihan_Readings$value, fixed = TRUE) & Unihan_Readings$key == lang_input())]}))
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
