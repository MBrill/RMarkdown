# R Funktionen für die Berechnung der Schiefe und der Wölbung


#' Schiefe - skewness
#' 
#' Verwendet die Funktion \code{empsd} für die empirische
#' Standardabweichung.
#' @param x Vektor mit der Stichprobe
skewness <- function(x) {
 return(sum(((x - mean(x))/empsd(x))^3) / length(x))
}

#' Wölbung - kurtosis
#' 
#' Verwendet die Funktion \code{empsd} für die empirische
#' Standardabweichung.
#' @param x Vektor mit der Stichprobe
kurtosis <- function(x) {
 return( sum( ( (x-mean(x))/empsd(x))^4) / length(x) -3 )
}