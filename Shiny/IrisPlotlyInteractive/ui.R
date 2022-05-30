library(shiny)
library(shinydashboard)

source("tab3D.R")
source("tab2D.R")

ui <- shinyUI(dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Iris Interactiv"),
  dashboardSidebar(sidebarMenu(sidebar3D(),
                               sidebar2D())),
  dashboardBody(tabItems(tab3D(),
                         tab2D()))
))

ui2 <- shinyUI(
  navbarPage(
    title = "Iris Interactiv",
    tabPanel("3D", ui3D())
  )
)
