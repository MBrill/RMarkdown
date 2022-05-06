library(shiny)
library(tidyverse)

server <- function(input, output, session) {
  noneFiller <- "None"
  options <- c(noneFiller, colnames(iris))
  
  observe({
    xSelected <- c(input$yaxis, input$zaxis, input$color)
    xSelected <- xSelected[xSelected != noneFiller]
    updatePickerInput(
      session,
      "xaxis",
      choices = options,
      selected = input$xaxis,
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
    selection <- c(input$xaxis, input$yaxis, input$zaxis, input$color)
    if (all(selection != "None")) {
      iris %>%
        plot_ly(
          type = "scatter3d",
          # interpretiere aktuell, in xaxis, gewählten Parameter als Formel
          x = ~ get(input$xaxis),
          y = ~ get(input$yaxis),
          z = ~ get(input$zaxis),
          color = ~ get(input$color),
          mode = "markers"
        )  %>%
        layout(scene = list(
          xaxis = list(title = input$xaxis),
          yaxis = list(title = input$yaxis),
          zaxis = list(title = input$zaxis)
        ),
        paper_bgcolor='lightgrey',
        plot_bgcolor='lightgrey')
    }
    else{
      # TODO überarbeiten
      plotly_empty(type = "scatter3d", mode = "markers") %>%
        layout(
          xaxis = list(visible = T),
          yaxis = list(visible = T),
          annotations = list(
            xanchor = "center",
            yanchor = "center",
            text = "Weisen Sie vier Parameter zu!",
            showarrow = F,
            font = list(size = 28, color="red")
          ),
          paper_bgcolor='lightgrey',
          plot_bgcolor='lightgrey'
        )
    }
  })
}
