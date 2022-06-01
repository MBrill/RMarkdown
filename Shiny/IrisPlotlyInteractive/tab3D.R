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


# UI fuer den 3D-Tab
ui3D <- function(id = ID3D) {
  # Liste an Tags, die die UI aufbauen. In diesem Fall
  # Sidebar und MainPanel.
  tagList(
    titlePanel("", windowTitle = "Iris Interaktiv"),
    sidebarLayout(
      sidebarPanel(
        h2("Einstellungen"),
        checkboxInput("options", "Einstellungen anzeigen"),
        # Dieses Panel wird nur angezeigt, wenn die entsprechende
        # Bedingung erfuellt ist
        conditionalPanel(
          condition = "input.options == true",
          pickers
          # TODO
          # kein Output = kein OutputOptions()
          # outputOptions Erklärung
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
    # Variable fuer eine Option bei der kein Parameter gewaehlt wird
    noneFiller <- "None"
    # Auswahlmoeglichkeiten für Dropdownmenues festlegen
    # Hinzufuegen einer Option die immer verfuegbar ist: noneFiller
    options <- c(noneFiller, colnames(iris))

    # reactive observer
    # Jeder Parameter soll jeweils nur einmal verwendet werden koennen
    # Ausnahme: noneFiller
    observe({
      # Aktuell gewaehlte Parameter, die im Dropdownmenue deaktiviert werden sollen
      xSelected <- c(input$yaxis, input$zaxis, input$color)
      # noneFiller soll immer verfuegbar sein und darf somit nicht deaktiviert werden
      xSelected <- xSelected[xSelected != noneFiller]
      # Update des entsprechenden UI-Elements
      updatePickerInput(
        session,
        "xaxis",
        choices = options,
        selected = input$xaxis,
        # Deaktivieren der entsprechenden Elemente
        choicesOpt = list(disabled = options %in% xSelected),
        options = pickerOptions(noneSelectedText = noneFiller)
      )

      ySelected <- c(input$xaxis, input$zaxis, input$color)
      ySelected <- ySelected[ySelected != noneFiller]
      updatePickerInput(
        session,
        "yaxis",
        choices = options,
        selected = input$yaxis,
        choicesOpt = list(disabled = options %in% ySelected),
        options = pickerOptions(noneSelectedText = noneFiller)
      )

      zSelected <- c(input$xaxis, input$yaxis, input$color)
      zSelected <- zSelected[zSelected != noneFiller]
      updatePickerInput(
        session,
        "zaxis",
        choices = options,
        selected = input$zaxis,
        choicesOpt = list(disabled = options %in% zSelected),
        options = pickerOptions(noneSelectedText = noneFiller)
      )

      colorSelect <- c(input$xaxis, input$yaxis, input$zaxis)
      colorSelect <- colorSelect[colorSelect != noneFiller]
      updatePickerInput(
        session,
        "color",
        choices = options,
        selected = input$color,
        choicesOpt = list(disabled = options %in% colorSelect),
        options = pickerOptions(noneSelectedText = noneFiller)
      )
    })

    output$plot <- renderPlotly({
      # Aktuell gewaehlte Parameter
      selection <-
        c(input$xaxis, input$yaxis, input$zaxis, input$color)
      # Der Plot wird ausschliesslich dann erstellt, wenn vier gueltige Paramerter gewaehlt sind
      if (all(selection != "None")) {
        iris %>%
          plot_ly(
            type = "scatter3d",
            # Interpretiere aktuell, in xaxis, gewählten Parameter als Formel
            x = ~ get(input$xaxis),
            y = ~ get(input$yaxis),
            z = ~ get(input$zaxis),
            color = ~ get(input$color),
            mode = "markers"
          )  %>%
          layout(
            scene = list(
              xaxis = list(title = input$xaxis),
              yaxis = list(title = input$yaxis),
              zaxis = list(title = input$zaxis)
            ),
            paper_bgcolor = 'lightgrey',
            plot_bgcolor = 'lightgrey'
          )
      }
      # Alternativer Plot
      else{
        plotly_empty(type = "scatter3d", mode = "markers") %>%
          layout(
            annotations = list(
              xanchor = "center",
              yanchor = "center",
              text = "Weisen Sie vier Parameter zu!",
              showarrow = F,
              font = list(size = 28, color = "red")
            ),
            paper_bgcolor = 'lightgrey',
            plot_bgcolor = 'lightgrey'
          )
      }
    })
  })
}
