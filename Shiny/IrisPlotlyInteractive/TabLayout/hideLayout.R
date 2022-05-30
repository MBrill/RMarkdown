
  
  ui <- navbarPage("Navbar page", id = "tabs",
                   tabPanel("Home",
                            actionButton("hideTab", "Hide 'Foo' tab"),
                            actionButton("showTab", "Show 'Foo' tab"),
                            actionButton("hideMenu", "Hide 'More' navbarMenu"),
                            actionButton("showMenu", "Show 'More' navbarMenu")
                   ),
                   tabPanel("Foo", 
                            # Partial example
                            
                            # outputOptions
                            checkboxInput("smooth", "Smooth"),
                            conditionalPanel(
                              condition = "input.smooth == true",
                              selectInput("smoothMethod", "Method",
                                          list("lm", "glm", "gam", "loess", "rlm"))
                            )
                            ),
                   tabPanel("Bar", "This is the bar tab"),
                   navbarMenu("More",
                              tabPanel("Table", "Table page"),
                              tabPanel("About", "About page"),
                              "------",
                              "Even more!",
                              tabPanel("Email", "Email page")
                   )
  )
  
  server <- function(input, output, session) {
    
    observeEvent(input$hideTab, {
      hideTab(inputId = "tabs", target = "Foo")
    })
    
    observeEvent(input$showTab, {
      showTab(inputId = "tabs", target = "Foo")
    })
    
    observeEvent(input$hideMenu, {
      hideTab(inputId = "tabs", target = "More")
    })
    
    observeEvent(input$showMenu, {
      showTab(inputId = "tabs", target = "More")
    })
  }