shinyServer(
  function(input, output) {
    library(stringi)
    library(Unicode)

    Unihan_Readings <- read.delim("Unihan_Readings.txt", header=FALSE, comment.char="#", stringsAsFactors=FALSE, col.names = c("code", "key", "value"))

    pronunciationsC <- reactive({
      zi <- trimws(input$zi)[[1]]
      zi <- substr(zi, start = nchar(zi), stop = nchar(zi))
      cp <- paste("U+", toupper(sprintf("%x", as.numeric(stri_enc_toutf32(zi)))), sep = "")
      strsplit(as.character(Unihan_Readings$value[which(Unihan_Readings$code == cp & Unihan_Readings$key == "kCantonese")]), " ")[[1]]
    })

    charactersC <- reactive({
      zi_same_p <- unlist(lapply(pronunciationsC(), function(x) {
        Unihan_Readings$code[which(grepl(as.character(x), Unihan_Readings$value, fixed = TRUE) & Unihan_Readings$key == "kCantonese")]}))
      unlist(lapply(as.list(zi_same_p), function(x) {
        u_char_inspect(as.character(x))['Char']
      }))
    })

    output$pronunciationC <- renderText(pronunciationsC())
    output$resultC <- renderText(charactersC())
    pronunciationsK <- reactive({
      zi <- trimws(input$zi)[[1]]
      zi <- substr(zi, start = nchar(zi), stop = nchar(zi))
      cp <- paste("U+", toupper(sprintf("%x", as.numeric(stri_enc_toutf32(zi)))), sep = "")
      strsplit(as.character(Unihan_Readings$value[which(Unihan_Readings$code == cp & Unihan_Readings$key == "kKorean")]), " ")[[1]]
    })
    charactersK <- reactive({
      zi_same_p <- unlist(lapply(pronunciationsK(), function(x) {
        Unihan_Readings$code[which(grepl(as.character(x), Unihan_Readings$value, fixed = TRUE) & Unihan_Readings$key == "kKorean")]}))
      unlist(lapply(as.list(zi_same_p), function(x) {
        u_char_inspect(as.character(x))['Char']
      }))
    })
    output$pronunciationK <- renderText(pronunciationsK())
    output$resultK <- renderText(charactersK())
  }
)
