# Das erste Beispiel für ein Dashboard mit Shiny
library(shinydashboard)
library(tidyverse)

ui <- dashboardPage(
    skin = "yellow",
    dashboardHeader(title = "Ein Shiny Dashboard"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Histogramm", tabName = "histo", icon = icon("dashboard")),
            menuItem("Informationen", tabName = "credits", icon = icon("id-badge"))
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName="histo",
                    tabPanel("Histogramm",
                             fluidRow(
                                 box(
                                     title = "Einstellungen",
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
                                 box(
                                     title="Histogramm",
                                     plotOutput("histo", height = 250)
                                     )
                             )
                    )
            ),
            tabItem(tabName="credits",
                    tabPanel("Informationen"),
                    fluidRow(
                        box(
                            title="Informationen",
                            textOutput("info")
                        )
                    )
                    )
        )
    )
)

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
    
    output$info <- renderText(
        "(C) Hochschule Kaiserslautern"
    )
}

shinyApp(ui, server)
