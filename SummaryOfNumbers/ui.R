shinyUI(fluidPage(
  titlePanel("Uploading file to analyze"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file', 'Choose file to upload',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv'
                )
      ),
      tags$hr(),
      checkboxInput('header', 'Header', FALSE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   '\t'),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   ''),
      radioButtons('enc', 'Encoding',
                   c('UTF-8'='UTF-8',
                     'Unicode (Windows)'='UCS-2LE'),
                   'UTF-8')
    ),
    mainPanel(
      tableOutput('contents'),
      plotOutput('plot')
    )
  )
))
