# Monte-Carlo Simulation in einer funktionalen Realisierung
# Aufgabe random21
library(purrr)

counter <- function (lottozahl) {
  draw <- sample.int(49, 6, replace=FALSE)
  return (sum(draw == lottozahl))
}

n <- 10000000
results <- rep(42, n)

print("Wir beginnen mit der Simulation")
print("Anzahl der durchgeführten Ziehungen")
print(n)

frequency <- results %>%
  map_int(counter) %>%
  sum()

print("Die Ergebnisse")
print("Absolute Häufigkeit für die Zahl 42")
print(frequency)
print("Relative Häufigkeit für die Zahl 42")
print(frequency/n)