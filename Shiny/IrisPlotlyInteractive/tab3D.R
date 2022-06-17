# TODO Zusammenfassung

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(plotly)
library(purrr)
#library(tidyverse)

# ID fuer den Namespace des 3D-Tabs
ID3D <- "3d"
# Parameter fuer das Erstellen von UI-Elementen
vars <- list(
  # NamespaceID
  ID3D,
  # ID-Liste
  list("xaxis",
       "yaxis",
       "zaxis",
       "color"),
  # Label-Liste
  list("x-Achse",
       "y-Achse",
       "z-Achse",
       "Färbung"),
  # List mit den Default-Werten der UI-Elemente
  list("Sepal.Length",
       "Sepal.Width",
       "Petal.Length",
       "Species")
)
# Variable fuer eine Option bei der kein Parameter gewaehlt wird
noneFiller <- "None"
# Auswahlmoeglichkeiten fuer Dropdownmenues festlegen
# Hinzufuegen einer Option die immer verfuegbar ist: noneFiller
options <- c(noneFiller, colnames(iris))

disableButton <-reactiveVal(T)

# Erstellt die entsprechenden UI-Elemente
pickerInput3D <- function(namespaceID, id, label, selected){
  # Festlegen des Namespace.
  # ns <- NS(namespaceID)
  # Somit kann im weiteren Verlauf mit ns("variable")
  # anstelle von NS(id, "variable") gearbeitet werden.
  # TODO Erklärung: Warum Namespace
  pickerInput(
    inputId = NS(namespaceID, id),
    label = label,
    choices = colnames(iris),
    selected = selected
  )
}

# Erstellt die pickerInput-Elemente der UI mithilfe der zur
# Verfuegung gestellten Parameter.
# Verwendet die purrr-library.
pickers <- pmap(vars, pickerInput3D)

pickerUpdate <- function(session, id, selected, selection, options, noneFiller){
  # Der ausgewaehlte Parameter soll nicht deaktiviert werden
  selection <- selection[selection != selected]

  # Update des entsprechenden UI-Elements
  updatePickerInput(
    session,
    id,
    choices = options,
    selected = selected,
    # Deaktivieren der entsprechenden Elemente
    choicesOpt = list(disabled = options %in% selection),
    options = pickerOptions(noneSelectedText = noneFiller)
  )
}

# UI fuer den 3D-Tab
ui3D <- function(id = ID3D) {
  # Liste an Tags, die die UI aufbauen. In diesem Fall
  # Sidebar und MainPanel.
  tagList(
    #titlePanel("", windowTitle = "Iris Interaktiv"),
    sidebarLayout(
      sidebarPanel(
        h2("Einstellungen"),
        checkboxInput("options", "Einstellungen anzeigen"),
        # Dieses Panel wird nur angezeigt, wenn die entsprechende
        # Bedingung erfuellt ist
        conditionalPanel(
          condition = "input.options == true",
          pickers,
          # TODO
          # kein Output = kein OutputOptions()
          # outputOptions Erklaerung
          actionButton(NS(ID3D, "reset"), "Zurücksetzen"),
          actionButton(NS(ID3D, "showPlot"), "Plot anzeigen")
        ),
        width = 3
      ),
      mainPanel(
        h2("ScatterPlot ", align = "center"),
        plotlyOutput(outputId = NS(ID3D,"plot")),
        width = 9
      )

    )
  )

}

# Server fuer den 3D-Tab
server3D <- function(id = ID3D) {
  moduleServer(id, function(input, output, session) {
    # reactive observer
    # Jeder Parameter soll jeweils nur einmal verwendet werden koennen
    # Ausnahme: noneFiller
    observe({
      # Aktuell gewaehlte Parameter, die im Dropdownmenue deaktiviert werden sollen
      selection <- c(input$xaxis, input$yaxis, input$zaxis, input$color)

      # Sobald der noneFiller ausgewaehlt wird, soll der Button,
      # fuer das Aktualisieren des Plots, deaktiviert werden.
      if (all(selection != noneFiller)) {
        disableButton(F)
      }
      else {
        disableButton(T)
      }

      # noneFiller soll bei der Auswahl immer verfuegbar sein und darf somit nicht deaktiviert werden
      selection <- selection[selection != noneFiller]

      # Update der Auswahloptionen der PickerInput-UI-Elemente
      pickerUpdate(session, "xaxis", input$xaxis, selection, options, noneFiller)
      pickerUpdate(session, "yaxis", input$yaxis, selection, options, noneFiller)
      pickerUpdate(session, "zaxis", input$zaxis, selection, options, noneFiller)
      pickerUpdate(session, "color", input$color, selection, options, noneFiller)
    })

    plot <- reactive({
      # Durch das Aufrufen von input$showPlot erstellt das reaktive
      # Objekt eine Abhaengigkeit. Sobald sich der Wert von
      # input$showPlot aendert, wird der folgende Code erneut ausgefuehrt.
      input$showPlot

      # Entkopplung des Plots und der Variablen von dem reaktiven Kontext.
      # Dieser Code wird ausschliesslich dann ausgefuehrt, wenn sich input$showPlot aendert.
      isolate({
        # TODO iris pipe
        iris %>%
          plot_ly(
            type = "scatter3d",
            # Interpretiere den aktuell, in xaxis, gewaehlten Parameter als Formel
            x = ~ get(isolate(input$xaxis)),
            y = ~ get(isolate(input$yaxis)),
            z = ~ get(isolate(input$zaxis)),
            color = ~ get(isolate(input$color)),
            mode = "markers"
          )  %>%
          layout(
            scene = list(
              xaxis = list(title = isolate(input$xaxis)),
              yaxis = list(title = isolate(input$yaxis)),
              zaxis = list(title = isolate(input$zaxis))
            ),
            paper_bgcolor = 'lightgrey',
            plot_bgcolor = 'lightgrey'
          )
      })
    })

    output$plot <- renderPlotly({
      # Der Plot wird ausschliesslich dann aktiviert,
      # wenn valide Parameter ausgewaehlt sind.
      if(!disableButton()) plot()
    })
  })
}
