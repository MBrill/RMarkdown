library(shiny)

# Server-Objekt der Shiny App
server <- shinyServer(function(input, output) {
  server3D()
  server2D()
})
