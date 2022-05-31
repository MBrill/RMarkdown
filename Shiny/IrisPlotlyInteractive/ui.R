library(shiny)
library(shinydashboard)

source("tab3D.R")
source("tab2D.R")

# UI-Objekt fuer die Dashboard-UI
uiDashboard <- shinyUI(dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Iris Interactiv"),
  dashboardSidebar(sidebarMenu(sidebar3D(),
                               sidebar2D())),
  dashboardBody(tabItems(tab3D(),
                         tab2D()))
))

# UI-Objekt fuer die Navbar-UI
uiNavbar <- shinyUI(
  navbarPage(
    title = "Iris Interactiv",
    tabPanel("3D", ui3D())
  )
)
