shinyUI(fluidPage(
  titlePanel("同音字"),
  sidebarLayout(
    sidebarPanel(
       textInput("zi",
                 label = h3("输入单个汉字"),
                 value = "好"),
       uiOutput("lang_selector"),
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