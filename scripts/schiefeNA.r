# R Funktionen für die Berechnung der Schiefe und der Wölbung


#' Schiefe - skewness
#' 
#' Verwendet die Funktion \code{empsd} für die empirische
#' Standardabweichung.
#' @param x Vektor mit der Stichprobe
#' @param na.rm Default: false. Falls true werden
#'        mit NA gekennzeichnete Werte bei der Berechnung
#'        ignoriert.
skewness <- function(x, na.rm = FALSE) {
  # Wurde ein Vektor übergeben?
  stopifnot(is.numeric(x) & is.vector(x))
  
  # Falls es fehlende Werte gibt werden diese
  # mit na.omit aus dem Vektor gelöscht:
  if ( na.rm )
    x <- na.omit(x)
  
  return(sum(((x - mean(x))/empsd(x))^3) / length(x))
}

#' Wölbung - kurtosis
#' 
#' Verwendet die Funktion \code{empsd} für die empirische
#' Standardabweichung.
#' @param x Vektor mit der Stichprobe
#' @param na.rm Default: false. Falls true werden
#'        mit NA gekennzeichnete Werte bei der Berechnung
#'        ignoriert.#' 
kurtosis <- function(x, na.rm = FALSE) {
  # Wurde ein Vektor übergeben?
  stopifnot(is.numeric(x) & is.vector(x))
  
  # Falls es fehlende Werte gibt werden diese
  # mit na.omit aus dem Vektor gelöscht:
  if ( na.rm )
    x <- na.omit(x)
  
  return( sum( ( (x-mean(x))/empsd(x))^4) / length(x) - 3 )
}