# Loads a predefined workspace for the App.
# In order to see changes made it is necessary to comment out this
# command.
load("IrisInteractive.RData")

source("prepareData.R")
source("ui.R")
source("server.R")

# Profiling library
# library(profvis)

# Builds a Shiny App using a UI/Server pair.
shinyApp(ui, server)
