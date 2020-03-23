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