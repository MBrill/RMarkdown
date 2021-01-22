require(shiny)
require(visNetwork)

server <- function(input, output) {
  output$network <- renderVisNetwork({
    # minimal example
    nodes <- data.frame(id = 1:3)
    edges <- data.frame(from = c(1,2), to = c(1,3))
    
    visNetwork(nodes, edges)
  })
}

ui <- fluidPage(
  visNetworkOutput("network")
)

shinyApp(ui = ui, server = server)