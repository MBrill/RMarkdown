library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      flowLayout(
        "object",
        "obj"
      )
    ),
    mainPanel(
      
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)