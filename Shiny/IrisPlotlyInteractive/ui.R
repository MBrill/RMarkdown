library(shiny)
library(shinydashboard)
library(shinythemes)

source("tab3D.R")
source("tabData.R")
source("tabSources.R")

# UI-object for the Shiny App.
ui <- shinyUI(
  tagList(
    # Creates a floating Panel handling the theme selection.
    shinythemes::themeSelector(),
    navbarPage(
      title = "Iris Interaktive",
      tabPanel("Iris Data", uiData()),
      tabPanel("3D Scatter Plot", ui3D()),
      tabPanel("Sources", uiSources())
    )
  )

)
