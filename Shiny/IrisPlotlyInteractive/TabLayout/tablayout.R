library(shiny)

tab1 <- function(){
  tabPanel("Tab1", "content1")
}
tab2 <- function(){
  tabPanel("Tab2", "content2")
}

ui <- fluidPage(
  navbarPage( title = "Title",
    tab1(),
    tab2()
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)