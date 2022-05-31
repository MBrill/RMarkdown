library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(plotly)
#library(tidyverse)

# ID fuer den Namespace des 3D-Tabs
ID3D <- "3d"

# MenuItem fuer die Sidebar
sidebar3D <- function() {
  menuItem("3D",
           tabName = ID3D,
           icon = icon("map"))
}

# TabItem fuer den 3D-Tab
tab3D <- function() {
  tabItem(tabName = ID3D,
          fluidPage(ui3D()))
}

# UI fuer den 3D-Tab
ui3D <- function(id = ID3D) {
  # Festlegen des Namespace.
  # Somit kann im weiteren Verlauf mit ns("variable")
  # anstelle von NS(id, "variable") gearbeitet werden.
  ns <- NS(id)

  # Liste an Tags, die die UI aufbauen. In diesem Fall
  # Sidebar und MainPanel.
  tagList(
    titlePanel("", windowTitle = "Iris Interaktiv"),

    sidebarLayout(
      sidebarPanel(
        h2("Einstellungen"),

        checkboxInput("options", "Einstellungen anzeigen"),
        conditionalPanel(
          condition = "input.options == true",

          pickerInput(
            inputId = ns("xaxis"),
            label = "x-Achse:",
            choices = colnames(iris),
            selected = "Sepal.Length"
          ),
          pickerInput(
            inputId = ns("yaxis"),
            label = "y-Achse:",
            choices = colnames(iris),
            selected = "Sepal.Width"
          ),
          pickerInput(
            inputId = ns("zaxis"),
            label = "z-Achse:",
            choices = colnames(iris),
            selected = "Petal.Length"
          ),
          pickerInput(
            inputId = ns("color"),
            label = "Färbung:",
            choices = colnames(iris),
            selected = "Species"
          ),
          # kein Output = kein OutputOptions()
        ),
        width = 3
      ),
      mainPanel(
        h2("ScatterPlot ", align = "center"),
        plotlyOutput(outputId = ns("plot")),
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
