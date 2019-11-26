shinyUI(fluidPage(
  titlePanel("同音字"),
  sidebarLayout(
    sidebarPanel(
       textInput("zi",
                 label = h3("输入单个汉字"),
                 value = "好"),
       selectInput("lang", "选择一个语言或方言：",
                   choices = c("韩语（Korean / Hangul）", "汉语（普通话 / Mandarin）", "汉语（粤语 / Cantonese）", "日语（Japanese / On）")),
     ),
    mainPanel(
      htmlOutput("pronunciation"),
      htmlOutput("result"),
      tags$hr(),
      helpText("读音来源", a("Unihan", href="https://www.unicode.org/charts/unihan.html", target="_blank")),
      helpText("遵守", a("Unicode terms of use", href="https://www.unicode.org/copyright.html", target="_blank")),
    ),
  ),
))