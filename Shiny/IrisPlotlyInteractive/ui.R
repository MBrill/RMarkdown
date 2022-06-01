library(shiny)
library(shinydashboard)

source("tab3D.R")

# UI-Objekt fuer die Navbar-UI
uiNavbar <- shinyUI(
  navbarPage(
    title = "Iris Interactiv",
    # tabPanel("Iris Datensatz", uiData()),
    tabPanel("3D Scatter Plot", ui3D())
  )
)
