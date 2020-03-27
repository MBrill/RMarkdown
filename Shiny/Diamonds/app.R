# ---------------------------------------------
# Ein Beispiel für eine Shiny-App.
#
# Wir verwenden wieder das Beispiel wie für 
# die anderen Rmd-Ausgabeformate und laden
# den Datensatz diamonds.
# Statt die Zahl, mit der wir die Diamanten
# filtern einer Konstante zuzuweisen
# kann sie interaktiv eingestellt werden.
# ---------------------------------------------
library(tidyverse)
library(shiny)

# User Interface
ui <- fluidPage(
    titlePanel("Datensatz diamonds - Verteilung der Karatzahlen"),
    
    # Das Interface legen wir in eine sidebar
    # Die minimalen und maximalen Werte wurden vorher in R bestimmt.
    sidebarLayout(
        sidebarPanel(
            sliderInput("cutNum",
                        "Obergrenze",
                        min = 0.2,
                        max = 5.0,
                        value = 2.5),
            sliderInput("binWidth",
                        "Klassenbreite",
                        min = 0.001,
                        max = 0.3,
                        value = 0.05)            
        ),
        
        # Im Hauptpanel die Grafik ausgeben
        mainPanel(
            plotOutput("barPlot")
        )
    )
)

# Code für den Server
server <- function(input, output) {
    output$barPlot <- renderPlot({
        # Wir filtern in Anhängigkeit vom Wert input$cutNum aus der Sidebar
        smaller <- diamonds %>%
            filter(carat <= input$cutNum)
        
        ggplot(smaller, aes(carat)) +
            geom_histogram(binwidth = input$binWidth, 
                           fill="green", 
                           color="black") +
                           labs(
                             x = "Karat",
                             y = "Absolute Häufigkeit"
                           )
    })
}

# Anwendung ausführen 
shinyApp(ui = ui, server = server)
