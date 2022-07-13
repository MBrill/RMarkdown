library(shiny)
library(tidyverse)
library(DT)

# ID for the namespace of the data-tab.
IDDATA <- "data"

uiData <- function(id = IDDATA) {
  ns <- NS(id)
  tagList(fluidPage(
    fluidRow(
      column(3, algin = "left"),
      column(
        6,
        align = "center",
        h2(),
        HTML(
          '<center><img src="https://upload.wikimedia.org/wikipedia/commons/5/5e/Logo_of_Hochschule_Kaiserslautern.png" height= "100" width= "200"></center>'
        )
      ),
      column(3, align = "right")
    ),
    fluidRow(
      column(3, align = "left"),
      column(
        6,
        align = "center",
        h2("The Iris Dataset"),

        # TODO add columns + size
        p(
          "This Dataset was used by R.A. Fisher in 1936 for the paper
          \"The Use of Multiple Measurements in Taxonomic Problems\"
          and serves as one of the standard datasets used for
          cluster analysis or pattern analysis."
        ),

        p(
          "Included are 150 observations of four attributes
          of three species of iris. Therefor the lengths and widths of the
          sepals (sepalum) and the petals (petalum) were listed
          in centimeters. In addition, the species corresponding to
          the measured value was given."
        ),

        p(
          "This dataset is suitable for classification because one
          species can be clearly identified based on its range of values,
          while the other two are difficult or impossible to separate based
          on the measured values."
        ),
        br()
      ),
      column(3, align = "right")
    ),
    fluidRow(
      column(3, align = "left"),
      column(
        6,
        align = "center",
        br(),
        h2("Used Measurements"),
        br(),
        HTML(
          '<center><img src="https://www.oreilly.com/library/view/python-artificial-intelligence/9781789539462/assets/462dc4fa-fd62-4539-8599-ac80a441382c.png" height= "353" width= "469"></center>'
        ),
        br(),
        h2("Iris Species"),
        br(),
        HTML(
          '<center><img src="https://www.embedded-robotics.com/wp-content/uploads/2022/01/Iris-Dataset-Classification.png" height= "100%" width= "100%"></center>'
        ),
        br(),
        h2("Dataset"),
        br(),
        DTOutput(ns("table"))
      ),
      column(3, align = "right")
    )
  ))
}

serverData <- function(id = IDDATA) {
  # The namespace for the server's code is specified with the ID.
  # It is therefore not necessary to address the corresponding
  # element using NS(id, "<id_name>").
  moduleServer(id, function(input, output, session) {
    output$table <- renderDT(data)
  })
}
