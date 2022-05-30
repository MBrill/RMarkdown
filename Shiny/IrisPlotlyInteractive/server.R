library(shiny)

server <- shinyServer(function(input, output) {
  server3D()
  server2D()
})
