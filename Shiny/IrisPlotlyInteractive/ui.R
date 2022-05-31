library(shiny)
library(shinydashboard)

source("tab3D.R")
source("tab2D.R")

# UI-Objekt fuer die Navbar-UI
uiNavbar <- shinyUI(
  navbarPage(
    title = "Iris Interactiv",
    tabPanel("3D", ui3D())
  )
)
