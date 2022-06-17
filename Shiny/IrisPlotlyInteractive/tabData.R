library(shiny)

# ID fuer den Namespace des Data-Tabs
IDDATA <- "data"

uiData <- function(id = IDDATA) {
  ns <- NS(id)
  tagList(fluidPage(fluidRow(
    column(
      12,
      align = "center",
      HTML(
        '<center><img src="https://upload.wikimedia.org/wikipedia/commons/5/5e/Logo_of_Hochschule_Kaiserslautern.png" height= "100" width= "200"></center>'
      ),
      titlePanel("Iris"),
      br(),
      p("Beschreibung Datensatz"),
      br(),
      tableOutput(ns("table")),
      HTML(
        '<center><img src="https://www.oreilly.com/library/view/python-artificial-intelligence/9781789539462/assets/462dc4fa-fd62-4539-8599-ac80a441382c.png" height= "353" width= "469"></center>'
      ),
      textOutput(ns("text"))
    )
  )))
}

serverData <- function(id = IDDATA) {
  moduleServer(id, function(input, output, session) {
    output$table <- renderTable(head(iris))
    t <- as.character(unique(iris$Species))
    output$text <- renderText(t)
  })
}
