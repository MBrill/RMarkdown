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
