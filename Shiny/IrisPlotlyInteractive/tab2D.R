library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(plotly)
library(tidyverse)

ID2D <- "2d"
sidebar2D <- function(){
  menuItem("Test",
           tabName = ID2D,
           icon = icon("map"))
}
tab2D <- function(){
  tabItem(tabName = ID2D,
          fluidPage(ui2D()))
}
ui2D <- function(id = ID2D){
  ns <- NS(id)
  tagList(
    
  )
}
server2D <- function(id = ID2D){
  moduleServer(id, function(input, output, session){
    
  })
}