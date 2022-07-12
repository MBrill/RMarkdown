# TODO Zusammenfassung

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(plotly)
library(purrr)
#library(tidyverse)

# ID for the namespace of the 3D tab.
ID3D <- "3d"
# Parameters for creating the UI elements.
vars <- list(
  # NamespaceID.
  ID3D,
  # ID-list.
  list("xaxis",
       "yaxis",
       "zaxis",
       "color"),
  # Label list.
  list("x-Axis",
       "y-Axis",
       "z-Axis",
       "Color"),
  # List with the default values of the UI elements.
  list("Sepal.Length",
       "Sepal.Width",
       "Petal.Length",
       "Species")
)
# Variable for an option where no parameter is chosen.
noneFiller <- "None"
# Define selection options for dropdown menus.
# Adding an option that is always available: noneFiller.
options <- c(noneFiller, colnames(data))
# reactiveVal, boolean.
resetPlot <- reactiveVal(F)


# Creates the corresponding UI elements.
pickerInput3D <- function(namespaceID, id, label, selected){
  pickerInput(
    inputId = NS(namespaceID, id),
    label = label,
    choices = colnames(data),
    selected = selected
  )
}

# Creates the UI's pickerInput elements using the provided parameters.
# Uses the purrr library.
pickers <- pmap(vars, pickerInput3D)

# Updates the pickers
pickerUpdate <- function(session, id, selected, selection, options, noneFiller, default, reset){
  # Reset the selected parameters?
  if(reset) {
    # Specify the desired value for the reset.
    selected <- default
    # Set the appropriate choices.
    selection <- unlist(vars[[4]])
  }

  # The selected parameter should not be deactivated.
  selection <- selection[selection != selected]

  # Update the corresponding UI element.
  updatePickerInput(
    session,
    id,
    choices = options,
    selected = selected,
    # Deactivate the corresponding elements and mark noneFiller.
    choicesOpt = list( content = paste("<div style='color: red;'>", noneFiller,"</div>"),
                       disabled = options %in% selection),
    options = pickerOptions(noneSelectedText = noneFiller)
  )
}

# UI for the 3D tab.
ui3D <- function(id = ID3D) {
  # Set the namespace.
  # ns <- NS(namespaceID)
  # This means that ns("variable") can be used instead of NS(id, "variable") later on.
  # The namespace is used to separate the inputs and outputs of the navbarPage tabs.
  ns <- NS(id)
  # List of tags that build the UI. In this case Sidebar and MainPanel.
  tagList(
    sidebarLayout(
      #TODO dynamic size possible?
      sidebarPanel(
        h2("Options"),
        actionButton(ns("reset"), "Reset Plot"),
        pickers,
        width = 3
      ),
      mainPanel(
        h2("ScatterPlot ", align = "center"),
        addSpinner(plotlyOutput(ns("plot")), spin = "circle", color = "#0000DD"),
        width = 9
      )

    )
  )

}

# Server for the 3D tab
server3D <- function(id = ID3D) {
  moduleServer(id, function(input, output, session) {

    # Each parameter should only be used once. To make this possible the pickers
    # have to be update on every change of input.
    # Exception: noneFiller.
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
    # The currently selected parameters.
    listenTo <- reactive({
      c(input$xaxis, input$yaxis, input$zaxis, input$color)
    })

    # Button for the reset.
    observeEvent(input$reset,{
      resetPlot(T)
    })

    # Update UI.
    # TODO Bug: Sometimes it is necessary to click the button
    # twice in order to reset the plot.
    observeEvent(c(listenTo(), input$reset), {
      if(resetPlot()){
        updatePickers(listenTo(), T)
        resetPlot(F)
      }else{
        updatePickers(listenTo(), F)
      }
    })

    output$plot <- renderPlotly({
      # The plot is only updated if valid parameters are selected.
      req(all(listenTo() != noneFiller), cancelOutput = T)

      # Create plot.
      data %>%
        plot_ly(
          type = "scatter3d",
          # Interpret the currently selected parameter in xaxis
          # as a formula.
          x = ~ get(input$xaxis),
          y = ~ get(input$yaxis),
          z = ~ get(input$zaxis),
          color = ~ get(input$color),
          mode = "markers"
        )  %>%
        layout(
          legend=list(title=list(text='<b> Species </b>')),
          scene = list(
            xaxis = list(title = input$xaxis),
            yaxis = list(title = input$yaxis),
            zaxis = list(title = input$zaxis)
          ),
          paper_bgcolor = 'lightgrey',
          plot_bgcolor = 'lightgrey'
        )
    })
  })
}
