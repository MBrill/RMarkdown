library(shiny)
library(tidyverse)

# ID fuer den Namespace des Data-Tabs
IDDATA <- "data"

uiData <- function(id = IDDATA) {
  ns <- NS(id)
  tagList(fluidPage(
    fluidRow(
      column(3, algin = "left"),
      column(
        6,
        align = "center",
        HTML(
          '<center><img src="https://upload.wikimedia.org/wikipedia/commons/5/5e/Logo_of_Hochschule_Kaiserslautern.png" height= "100" width= "200"></center>'
        )
      ),
      column(3, align = "right")
    ),
    fluidRow(
      column(3, align = "left"),
      column(
        6,
        align = "center",
        titlePanel("Der Iris Datensatz"),

        # TODO add columns + size
        p(
          "Dieser Datensatz wurde von R.A. Fisher 1936 für das Paper
        \"The Use of Multiple Measurements in Taxonomic Problems\"
        verwendet und dient als einer der Standarddatensätze,
        die für Clusteranalyse bzw. Musteranalyse verwendet wird."
        ),

        p(
          "Enthalten sind 150 Beobachtungen von vier Attributen
          dreier Arten von Schwertlilien. Hierbei wurden jeweils
          die Längen und Breiten der Kelchblätter (Sepalum) und der
          Kronblätter (Petalum) in Zentimeter aufgelistet.
          Zudem wurde die entsprechende Spezies zu den Messwert angegeben."
        ),

        p(
          "Dieser Datensatz eignet sich für Klassifizierung,
          da eine Spezies aufgrund ihres Wertebereichs eindeutig
          identifiziert werden kann, während die anderen beiden nur
          schwer bzw. nicht, aufgrund der Messwerte, zu trennen sind."
        ),
        br()
      ),
      column(3, align = "right")
    ),
    fluidRow(
      column(3, align = "left"),
      column(
        6,
        align = "center",
        p(),
        actionButton(ns("updateTable"), "Tabelle aktualisieren", icon = icon("redo")),
        tableOutput(ns("table")),
        textOutput(ns("text")),
        HTML(
          '<center><img src="https://www.oreilly.com/library/view/python-artificial-intelligence/9781789539462/assets/462dc4fa-fd62-4539-8599-ac80a441382c.png" height= "353" width= "469"></center>'
        )
      ),
      column(3, align = "right")
    )
  ))
}

serverData <- function(id = IDDATA) {
  # Der Namespace für den Code des Servers wird mit der ID festgelegt.
  # Somit ist es nicht notwendig die entsprechenden Element mittels
  # NS(id, "<id_name>") anzusprechen.
  moduleServer(id, function(input, output, session) {
    # reactive observer
    observe({
      # Durch das Aufrufen von input$updateTable erstellt das reaktive
      # Objekt eine Abhaengigkeit. Sobald sich der Wert von
      # input$updateTable aendert, wird der folgende Code erneut ausgefuehrt.
      input$updateTable

      # Fuenf zufaellige Eintraege aus dem iris-Datensatz
      output$table <- renderTable(sample_n(iris, 5))
    })
    t <- as.character(unique(iris$Species))
    output$text <- renderText(t)
  })
}
