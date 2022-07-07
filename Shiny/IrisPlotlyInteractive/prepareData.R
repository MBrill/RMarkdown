library(tidyverse)

data <- iris %>% mutate(Species = str_to_title(Species))


