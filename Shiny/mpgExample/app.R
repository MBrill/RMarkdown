#
# Ein Beispiel aus dem Github-Repository shiny-examples
#
library(shiny)
library(datasets)
library(RColorBrewer)
myPalette <- brewer.pal(5, "YlGn")

# Wir bereiten die Daten vor und erzeugen einen factor für das Merkmal am
mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))


# User Interface
ui <- fluidPage(
    
    # App title ----
    titlePanel("Verbrauch und Parameter im Datensatz mtcars"),
    
    # Sidebar layout
    sidebarLayout(
        
        sidebarPanel(
            # HTML-Ausgabe
            htmlOutput("textbody"),
            
            # Input: Pulldown für untersuchte Variable
            selectInput("variable", "Variable:",
                        c("Zylinder" = "cyl",
                          "Getriebe" = "am",
                          "Gänge" = "gear")),
            
            # Input: Checkbox für die Anzeige von Ausreißern ----
            checkboxInput("outliers", "Ausreißer anzeigen?", TRUE)
            
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            # Output: Plot of the requested variable against mpg ----
            plotOutput("mpgPlot")
            
        )
    )
)

# Logik auf dem Server
server <- function(input, output) {
    
    # String für Funktion boxplot erzeugen
    formulaText <- reactive({
        paste("mpg ~", input$variable)
    })
    
    # Boxplot erzeugen
    output$mpgPlot <- renderPlot({
        boxplot(as.formula(formulaText()),
               data = mpgData,
               outline = input$outliers,
               col = myPalette[1], 
               pch = 19)
        
    # Text ausgeben
    output$textbody <- renderUI({
        HTML("<p>Wie hängt der Verbrauch von verschiedenen Parametern ab?</p>
             <p>Verwenden Sie das Pulldown um verschiedene Box-Plots zu sehen!</p>")
        })
    })
    
}

# Create Shiny app ----
shinyApp(ui, server)