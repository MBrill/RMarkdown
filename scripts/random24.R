# Monte-Carlo Simulation in einer funktionalen Realisierung
# Aufgabe random24
library(purrr)

counter <- function (inside) {
  point <- runif(2)
  circle1 <- point[1]*point[1] + (point[2]-0.5)*(point[2]-0.5) <= 0.25
  circle2 <- (point[1]-0.5)*(point[1]-0.5) + (point[2]-0.5)*(point[2]-0.5) <= 0.25
  return (circle1 & circle2)
}

n <- 10000000
#n <- 100
results <- rep(FALSE, n)

print("Wir beginnen mit der Simulation")
print("Anzahl der durchgeführten Versuche")
print(n)

frequency <- results %>%
  map_lgl(counter) %>%
  sum()

print("Ergebnis")
print("Näherung der Durchschnittsfläche")
print((frequency/n))