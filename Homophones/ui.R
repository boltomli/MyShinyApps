shinyUI(fluidPage(
  titlePanel("同音字 - 读音来自 https://www.unicode.org/charts/unihan.html，遵守 http://www.unicode.org/copyright.html"),
  fluidRow(
    column(3,
           textInput("zi",
                     label = h3("输入单个汉字"),
                     value = "好"
                     ))
  ),
  mainPanel(
    h2("Yue"),
    h3(htmlOutput("pronunciationC")),
    h3(htmlOutput("resultC")),
    h2("Hangul"),
    h3(htmlOutput("pronunciationK")),
    h3(htmlOutput("resultK"))
  )
))