### EDA

# Load package(s) 
library(tidymodels)
library(tidyverse)
library(here)
library(parallel)
library(doParallel)

# Loading data
load(here("01_attempt/data/training_data.rda"))

# Checking missingness-------
skimr::skim_without_charts(training_data)

# Target variable distribution-----------
training_data |>
  ggplot(aes (x = host_is_superhost, fill = host_is_superhost) ) +
  geom_bar () +
  labs (y = "Count" , x = "Superhost Status") +
  theme_classic() + theme (legend.position = "none") +
  scale_fill_manual(values = c("darkgreen", "green"))

# Check correlations-----------
cor_matrix <- training_data.rda |>
  select (where(is.numeric) | where(is.logical)) |>
  na.omit() |> 
  cor() |>
  as_tibble( )

cor_matrix$varl <- 
  colnames(cor_matrix)

