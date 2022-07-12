library(shiny)
library(shinydashboard)
library(shinythemes)

source("tab3D.R")
source("tabData.R")
source("tabSources.R")
source("tabSettings.R")

# UI-object for the Shiny App.
ui <- shinyUI(
  tagList(
    navbarPage(
      title = "Iris Interaktive",
      tabPanel("Iris Data", uiData()),
      tabPanel("3D Scatter Plot", ui3D()),
      tabPanel("Sources", uiSources()),
      tabPanel("Settings", uiSettings())
    )
  )

)
