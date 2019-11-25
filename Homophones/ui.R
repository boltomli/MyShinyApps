shinyUI(fluidPage(
  titlePanel("粤语同音字 - 读音来自 http://www.unicode.org/charts/unihan.html"),
  fluidRow(
    column(3,
           textInput("zi",
                     label = h3("输入单个汉字"),
                     value = "好"
                     ))
  ),
  mainPanel(
    h3(htmlOutput("pronunciation")),
    h3(htmlOutput("result"))
  )
))