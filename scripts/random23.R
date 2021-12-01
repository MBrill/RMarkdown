# Monte-Carlo Simulation in einer funktionalen Realisierung
# Aufgabe random23 - Tafel-Experiment
# Die Tafel ist als Rechteck [0, 2]x[0, 1] angenommen,
# hat also Fläche 2.
library(purrr)

n <- 1000000
results <- rep(FALSE, n)

areaOfTable <- 2.0
xmin <- 0.5
xmax <- 1.5
ymin <- 0.5
ymax <- 1

inArea <- function (hit) {
  point.x <- runif(1, min=0, max=2)
  # Tafel hat in x-Richtung Länge 2
  point.y <- runif(1)
  return ((point.x >= xmin && point.x <= xmax) 
          && (point.y >= ymin && point.y <= ymax))
}

print("Wir beginnen mit der Simulation")
print("Anzahl der durchgeführten Würfe auf die Tafel")
print(n)

frequency <- results %>%
  map_lgl(inArea) %>%
  sum()

print("Die Ergebnisse")
print("Absolute Häufigkeit der Treffer auf die Fläche A")
print(frequency)
print("Schätzung für die Fläche von A (exaktes Ergebnis ist 0.5)")
print((frequency/n)*areaOfTabel)