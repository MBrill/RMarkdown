library(shiny)
library(shinydashboard)

source("tab3D.R")
source("tabData.R")

# UI-Objekt der Shiny App
ui <- shinyUI(
  navbarPage(
    #title = div(HTML('<img src="https://upload.wikimedia.org/wikipedia/commons/5/5e/Logo_of_Hochschule_Kaiserslautern.png" height= "35" width= "70">'), "Iris Interactiv"),
    title = "Iris Interaktiv",
    tabPanel("Iris Datensatz", uiData()),
    tabPanel("3D Scatter Plot", ui3D())
  )
)
