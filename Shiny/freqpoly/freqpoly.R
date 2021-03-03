#
# Beispiel für Parameter für ggplot2 aus "Mastering Shiny"
#
library(shiny)
library(ggplot2)

# Funktion, die wir in server aufrufen und die einen
# data.set erzeugt, den wir anschließend in ggplot darstellen.
# Wickham macht das fast immer - data.frame erzeugen mit
# reactive values, und dann etwas damit tun.
freqpoly <- function(x1, x2, binwidth = 0.1, xlim = c(-3, 3)) {
    df <- data.frame(
        x = c(x1, x2),
        g = c(rep("x1", length(x1)), rep("x2", length(x2)))
    )
    
    ggplot(df, aes(x, color = g)) + 
        geom_freqpoly(binwidth = binwidth, size = 1) + 
        coord_cartesian(xlim = xlim)
}

# Funktion für den t Test
t_test <- function(x1, x2) {
    test <- t.test(x1, x2)
    
    sprintf(
        "t-Test\n p Wert: %0.3f\n[%0.2f, %0.2f]\n t-Statistik Wert %1.2f",
        test$p.value, test$conf.int[1], test$conf.int[2], test$statistic
    )
}

# User interface
ui <- fluidPage(
    fluidRow(
        column(4,
               "Verteilung 1",
               numericInput("n1", label = "n", value = 1000, min = 1),
               numericInput("mean1", label = "mue", value = 0, step = 0.1),
               numericInput("sd1", label = "sigma", value = 0.5, min = 0.1, step = 0.1)
               ),
        column(4,
               "Verteilung 2",
               numericInput("n2", label = "n", value = 1000, min = 1),
               numericInput("mean2", label = "mue", value = 0, step = 0.1),
               numericInput("sd2", label = "sigma", value = 0.5, min = 0.1, step = 0.1)
               ),
        column(4,
               "Häufigkeitspolynom",
               numericInput("binwidth", label = "Klassenbreite", value = 0.1, step = 0.1),
               sliderInput("range", label = "Bereich", value = c(-3, 3), min = -5, max = 5)
               )
    ),
    fluidRow(
        column(9, plotOutput("hist")),
        column(3, verbatimTextOutput("ttest"))
    )
)

# server Funktion. Hier steht auch Code, den wir sonst in der Konsole ausführen würden!
server <- function(input, output, session) {

    # Wir erzeugen die Daten in einer reactive-function und können so die Werte wiederverwenden
    x1 <- reactive(rnorm(input$n1, input$mean1, input$sd1))
    x2 <- reactive(rnorm(input$n2, input$mean2, input$sd2))
    
    output$hist <- renderPlot({

        # freqpoly funktion aufrufen und input-Variable übergeben
        freqpoly(x1(), x2(), binwidth = input$binwidth, xlim = input$range)
        }
    )
    
    output$ttest <- renderText({
        # t_test aufrufen und die Daten übergeben
        t_test(x1(), x2())
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
