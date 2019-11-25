shinyServer(
  function(input, output) {
    library(stringi)
    library(Unicode)
    load("kCantonese.rda")
    pronunciations <- reactive({
      zi <- trimws(input$zi)[[1]]
      zi <- substr(zi, start = nchar(zi), stop = nchar(zi))
      cp <- toupper(sprintf("%x", as.numeric(stri_enc_toutf32(zi))))
      strsplit(as.character(kCantonese[which(kCantonese$cp == cp), ]$kCantonese), " ")[[1]]
    })
    characters <- reactive({
      zi_same_p <- unlist(lapply(pronunciations(), function(x) {
        kCantonese[which(grepl(as.character(x), kCantonese$kCantonese, fixed = TRUE)), ]$cp}))
      unlist(lapply(as.list(zi_same_p), function(x) {
        u_char_inspect(as.character(x))['Char']
      }))
    })
    output$pronunciation <- renderText(pronunciations())
    output$result <- renderText(characters())
  }
)
