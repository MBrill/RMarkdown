library(shiny)
library(plotly)

ui <- fluidPage(
    
    # App title ----
    titlePanel("Parallele Koordinaten mit plotly mit Shiny"),
    # HTML-Ausgabe
    htmlOutput("textbody"),
    plotlyOutput("parcoords"),
    verbatimTextOutput("info")
)

server <- function(input, output, session) {
    
    d <- dplyr::select_if(iris, is.numeric)
    
    output$parcoords <- renderPlotly({
        
        dims <- Map(function(x, y) {
            list(
                values = x, 
                range = range(x, na.rm = TRUE), 
                label = y
            )
        }, d, names(d), USE.NAMES = FALSE)
        
        plot_ly() %>%
            add_trace(
                type = "parcoords",
                dimensions = dims
            ) %>%
            event_register("plotly_restyle")
    })
    
    # Informationstext ausgeben
    output$info <- renderPrint({
        d <- event_data("plotly_restyle")
        if (is.null(d)) "Brush along a dimension" else d
    })
    
    # Text ausgeben
    output$textbody <- renderUI({
        HTML("<p>Parallele Koordinaten für den Datensatz Iris,
             verknüpft in einer Shiny-App</p>
             <p>Unterhalb der Grafik finden sie Info-Ausgaben aus R.</p>")
    })
    
}

shinyApp(ui, server)
