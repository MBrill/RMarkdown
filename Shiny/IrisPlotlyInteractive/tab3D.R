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
# Plot zurücksetzen?
resetPlot <- reactiveVal(F)


# Erstellt die entsprechenden UI-Elemente
pickerInput3D <- function(namespaceID, id, label, selected){
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

# Aktualisiert die Picker
pickerUpdate <- function(session, id, selected, selection, options, noneFiller, default, reset){
  # Zuruecksetzen der ausgewaehlten Parameter
  if(reset) {
    # Den gewuenschten Wert fuer das Zuruecksetzen festlegen
    selected <- default
    # Die entsprechenden Auswahlmoeglichkeiten festlegen
    selection <- unlist(vars[[4]])
  }

  # Der ausgewaehlte Parameter soll nicht deaktiviert werden
  selection <- selection[selection != selected]

  # Update des entsprechenden UI-Elements
  updatePickerInput(
    session,
    id,
    choices = options,
    selected = selected,
    # Deaktivieren der entsprechenden Elemente und hervorheben des noneFiller
    choicesOpt = list( content = paste("<div style='color: red;'>", noneFiller,"</div>"),
                       disabled = options %in% selection),
    options = pickerOptions(noneSelectedText = noneFiller)
  )
}

# UI fuer den 3D-Tab
ui3D <- function(id = ID3D) {
  # Festlegen des Namespace.
  # ns <- NS(namespaceID)
  # Somit kann im weiteren Verlauf mit ns("variable")
  # anstelle von NS(id, "variable") gearbeitet werden.
  # Der Namespace wird verwendet um die Inputs und Outputs der Tabs
  # der navbarPage zu separieren.
  ns <- NS(ID3D)
  # Liste an Tags, die die UI aufbauen. In diesem Fall
  # Sidebar und MainPanel.
  tagList(
    #titlePanel("", windowTitle = "Iris Interaktiv"),
    sidebarLayout(
      sidebarPanel(
        h2("Einstellungen"),
        actionButton(ns("reset"), "Zurücksetzen"),
        actionButton(ns("showPlot"), "Plot anzeigen"),
        pickers,
        width = 3
      ),
      mainPanel(
        h2("ScatterPlot ", align = "center"),
        # Der Plot wird erst erstellt, wenn der Nutzer den entsprechenden
        # Button betaetigt
        conditionalPanel(
          # Im conditionalPanel wird der Namespace mittels ns=<Namespace>
          # festgelegt
          condition = "input.showPlot > 0", ns = ns,
          addSpinner(plotlyOutput(ns("plot")), spin = "circle", color = "#0000DD")
          ),
        width = 9
      )

    )
  )

}

# Server fuer den 3D-Tab
server3D <- function(id = ID3D) {
  moduleServer(id, function(input, output, session) {
    # Verwalten der Variable fuer das Zuruecksetzen des Plots
    observeEvent(input$reset,{
      resetPlot(T)
    })

    # Jeder Parameter soll jeweils nur einmal verwendet werden koennen
    # Ausnahme: noneFiller
    updatePickers <- function(selection, reset){
      selection <- selection[selection != noneFiller]

      pickerUpdate(session, "xaxis", input$xaxis, selection, options, noneFiller,
                   vars[[4]][1], reset)
      pickerUpdate(session, "yaxis", input$yaxis, selection, options, noneFiller,
                   vars[[4]][2], reset)
      pickerUpdate(session, "zaxis", input$zaxis, selection, options, noneFiller,
                   vars[[4]][3], reset)
      pickerUpdate(session, "color", input$color, selection, options, noneFiller,
                   vars[[4]][4], reset)


    }
    # Die aktuell gewaehlten Parameter
    listenTo <- reactive({
      c(input$xaxis, input$yaxis, input$zaxis, input$color)
    })

    # Button fuer das Zuruecksetzen
    observeEvent(input$reset,{
      resetPlot(T)
    })

    # Aktualisierung der UI
    observeEvent(c(listenTo(), input$reset), {
      if(resetPlot()){
        updatePickers(listenTo(), T)
        resetPlot(F)
      }else{
        updatePickers(listenTo(), F)
      }
    })

    # Erstellen des Plots in Abhaengigkeit von dem entsprechenden Button
    plot <- eventReactive(input$showPlot,{
      # Der Plot wird nur angezeigt oder aktualisiert, wenn die entsprechende
      # Bedingung erfuellt ist
      req(all(listenTo() != noneFiller), cancelOutput = T)

      # Plot erstellen
      iris %>%
        plot_ly(
          type = "scatter3d",
          # Interpretiere den aktuell, in xaxis, gewaehlten Parameter
          # als Formel und vermeide die Abhaengigkeit des Plots
          # von der Aenderung der Parameter
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

    output$plot <- renderPlotly({
      # Der Plot wird ausschliesslich dann aktualisiert,
      # wenn valide Parameter ausgewaehlt sind.
      plot()
    })
    # Wird das conditionalPanel nicht angezeigt, wird das output-Objekt
    # nicht ausgefuehrt
    outputOptions(output, "plot")
  })
}
