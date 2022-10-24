library(shiny)

# Server object for the Shiny App.
server <- shinyServer(function(input, output) {
  serverData()
  server3D()
  serverSources()
  serverSettings()
})
