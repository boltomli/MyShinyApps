shinyServer(
  function(input, output) {
    library(stringi)
    library(DBI)
    library(RSQLite)
    library(rlang)

    con <- dbConnect(SQLite(), "unihan_readings.db")
    chars <- dbReadTable(con, "chars")
    types <- dbReadTable(con, "types")

    dicts <- reactive({
      d <- list()
      lapply(types$Type, function(x) {
        d[[x]] <<- dbReadTable(con, x)
      })
      d
    })

    output$lang_selector <- renderUI({
      selectInput("lang", "选择一个语言或方言：",
                  choices = types$Type)
    })

    pronunciations <- reactive({
      req(dicts())
      zi <- trimws(input$zi)[[1]]
      zi <- substr(zi, start = nchar(zi), stop = nchar(zi))
      cp <- chars[chars$Char == zi,]$Code
      if (!is_empty(cp)) {
        dict <- dicts()[[input$lang]]
        dict[dict$Code == cp,]$Value
      } else {
        paste0(zi, " is not a known character.")
      }
    })

    output$pronunciation <- renderText({
      req(pronunciations())
      pronunciations()
    })

    output$result <- renderText({
      req(pronunciations())
      dict <- dicts()[[input$lang]]
      zi_same_p <- unlist(lapply(pronunciations(), function(x) {
        dict[dict$Value == x,]$Code}))
      unlist(lapply(as.list(zi_same_p), function(x) {
        chars[chars$Code == x,]$Char
      }))
    })
  }
)
