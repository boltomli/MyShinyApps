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
        "日语（Japanese / On）" = "kJapaneseOn",
      )
    })

    pronunciations <- reactive({
      req(lang_input())
      zi <- trimws(input$zi)[[1]]
      zi <- substr(zi, start = nchar(zi), stop = nchar(zi))
      cp <- paste("U+", toupper(sprintf("%x", as.numeric(stri_enc_toutf32(zi)))), sep = "")
      split_by <- " "
      if (lang_input() == "kHanyuPinyin") split_by <- "[ :,0-9\\.]"
      strsplit(as.character(Unihan_Readings$value[which(lang_input() == Unihan_Readings$key & Unihan_Readings$code == cp)]), split_by)[[1]]
    })

    characters <- reactive({
      req(pronunciations())
      zi_same_p <- unlist(lapply(pronunciations(), function(x) {
        Unihan_Readings$code[which(lang_input() == Unihan_Readings$key & sapply(strsplit(as.character(Unihan_Readings$value), "[ :,]"), function(x, y) y %in% x, x))]}))
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
