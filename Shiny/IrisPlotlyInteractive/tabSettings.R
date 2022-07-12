# The code in this file is based on:
# https://github.com/rstudio/shinythemes/blob/main/R/shinytheme.R
#
# Changes: UI of the themeselector.
library(shinythemes)

IDSETTINGS = "settings"

# Function taken from the original code.
allThemes <- function() {
  themes <-
    dir(system.file("shinythemes/css", package = "shinythemes"),
        ".+\\.min.css")
  sub(".min.css", "", themes)
}

uiSettings <- function(id = IDSETTINGS) {
  ns <- NS(id)
  fluidPage(fluidRow(
    column(3, align = "left"),
    column(
      6,
      align = "center",
      selectInput(
        ns("selector"),
        "Theme",
        c("default", allThemes()),
        selectize = FALSE
      ),
      # Javascript taken from the original code.
      # Updates the theme of the UI on a change event.
      tags$script(
        sprintf(
          "$('#%s-selector')
  .on('change', function(el) {
    var allThemes = $(this).find('option').map(function() {
      if ($(this).val() === 'default')
        return 'bootstrap';
      else
        return $(this).val();
    });
    // Find the current theme
    var curTheme = el.target.value;
    if (curTheme === 'default') {
      curTheme = 'bootstrap';
      curThemePath = 'shared/bootstrap/css/bootstrap.min.css';
    } else {
      curThemePath = 'shinythemes/css/' + curTheme + '.min.css';
    }
    // Find the <link> element with that has the bootstrap.css
    var $link = $('link').filter(function() {
      var theme = $(this).attr('href');
      theme = theme.replace(/^.*\\//, '').replace(/(\\.min)?\\.css$/, '');
      return $.inArray(theme, allThemes) !== -1;
    });
    // Set it to the correct path
    $link.attr('href', curThemePath);
  });",
          id
        )
      )
    ),
    column(3, align = "right")
  ))

}

serverSettings <- function(id = IDSETTINGS) {

}
