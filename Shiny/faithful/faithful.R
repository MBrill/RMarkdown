#
# Shiny App für die Darstellung von Histogrammen mit
# verschiedenen Klassenbreiten.
#
# Der R-Code für die Klassenbreiten liegt als Markdown-Dokument in faithful.Rmd
#

library(shiny)
library(RColorBrewer)
myPalette <- brewer.pal(5, "Set2")

#' Empirische Varianz
#' 
#' \code{empvar} berechnet die empirische Varianz
#' 
#' Verwendet die Funktion \code{var} für die korrigierte
#' Standardabweichung.
#' @param x Vektor mit der Stichprobe
empvar <- function(x) {
    n <- length(x)
    return(((n-1)/n)*var(x))
}

#' Empirische Standardabweichung
#' 
#' \code{empsd} berechnet die empirische Standardabweichung
#' 
#' Verwendet die Funktion \code{empvar} für die empirische
#' Varianz.
#' @param x Vektor mit der Stichprobe
empsd <- function(x) {
    return(sqrt(empvar(x)))
}

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser"),

    # Slider für die Klassenbreite
    sidebarLayout(
        sidebarPanel(
            sliderInput("binwidth",
                        "Klassenbreite",
                        min = 0.0,
                        max = 1.0,
                        step = 0.05,
                        value = 0.5)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("histo")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$histo <- renderPlot({
        bw <- input$binwidth
        subt <- paste("Klassenbreite", bw)
        ggplot(data=faithful) + 
            geom_histogram(aes(x = eruptions), 
                           colour="black",
                           fill=myPalette[1],
                           binwidth=bw,
                           show.legend=FALSE) +
            labs(
                title="Dauer der Eruptionen von Old Faithful", 
                x="Dauer in Minuten", 
                y="Absolute Häufigkeiten",
                subtitle=subt
            )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
