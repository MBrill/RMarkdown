library(shiny)

# Server-Objekt der Shiny App
server <- shinyServer(function(input, output) {
  serverData()
  server3D()
  serverSources()
})
