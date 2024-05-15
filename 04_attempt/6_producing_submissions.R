# Final Project ----
# Assessing final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
load(here("04_attempt/data/testing_data.rda"))
load(here("04_attempt/results/final_fit_rf_1.rda"))

# producing predictions
attempt_04_rf_1 <- testing_data |>
  bind_cols(predict(final_fit_rf_1, testing_data, type = "prob")) |>
  rename(predicted = .pred_1) |>
  select(id, predicted)

write_csv(attempt_04_rf_1, here("submissions/attempt_04_rf_1.csv"))
