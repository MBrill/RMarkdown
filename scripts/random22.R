# Monte-Carlo Simulation in einer funktionalen Realisierung
# Aufgabe random22
library(purrr)

counter <- function (inside) {
  point <- runif(2)
  return (sum(point**2) <= 1.0)
}

n <- 10000000
results <- rep(FALSE, n)

print("Wir beginnen mit der Simulation")
print("Anzahl der durchgeführten Versuche")
print(n)

frequency <- results %>%
  map_lgl(counter) %>%
  sum()

print("Ergebnis")
print("Näherung der Zahl pi")
print(4.0*(frequency/n))