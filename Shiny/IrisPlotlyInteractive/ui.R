library(shiny)
library(shinyWidgets)
library(plotly)

shinyUI(fluidPage(
  h1("Iris Interaktiv", align = "center"),
  titlePanel("", windowTitle = "Iris Interaktiv"),
  
  sidebarLayout(
    sidebarPanel(
      h2("Einstellungen"),
      p("Verwenden Sie die nachstehenden Einstellungen, um die Parameter der Achsen festzulegen!", align = "center"),
      
      pickerInput(
        inputId = "xaxis", 
        label = "x-Achse:", 
        choices = colnames(iris), 
        selected = "Sepal.Length"
      ),
      pickerInput(
        inputId = "yaxis", 
        label = "y-Achse:", 
        choices = colnames(iris), 
        selected = "Sepal.Width"
      ),
      pickerInput(
        inputId = "zaxis", 
        label = "z-Achse:", 
        choices = colnames(iris), 
        selected = "Petal.Length"
      ),
      pickerInput(
        inputId = "color", 
        label = "Färbung:", 
        choices = colnames(iris), 
        selected = "Species"
      ),
      width = 3 
    ),
    mainPanel(
      h2("ScatterPlot ", align="center"),
      plotlyOutput(outputId = "plot"),
      width = 9
    )
  )
))
