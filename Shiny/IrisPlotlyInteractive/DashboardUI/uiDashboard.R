library(shiny)
library(shinydashboard)

# UI-Objekt fuer die Dashboard-UI
uiDashboard <- shinyUI(dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Iris Interactiv"),
  dashboardSidebar(sidebarMenu(sidebar3D(),
                               sidebar2D())),
  dashboardBody(tabItems(tab3D(),
                         tab2D()))
))

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
