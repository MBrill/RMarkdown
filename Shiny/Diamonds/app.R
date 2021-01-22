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
            h2("Einstellungen"),
            p("Verwenden Sie die Slider für die Veränderung des Histogramms!"),
            sliderInput("cutNum",
                        "Dargestellter Bereich der Karatzahlen",
                        min = 0.0,
                        max = 5.0,
                        step = 0.1,
                        value = c(1.0, 2.0)),
            sliderInput("binWidth",
                        "Klassenbreite für das Histogramm",
                        min = 0.05,
                        max = 0.5,
                        step = 0.01,
                        value = 0.1)            
        ),
        
        # Im Hauptpanel die Grafik ausgeben
        mainPanel(
            h2("Histogramm ", align="center"),
            plotOutput("histo")
        )
    )
)

# Code für den Server
server <- function(input, output) {
    
    output$histo <- renderPlot({
        # Daten filtern, wie im Slider definiert.
        smaller <- diamonds %>%
            filter(carat <= input$cutNum[2] & carat >= input$cutNum[1])
        # Grafik erstellen
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
