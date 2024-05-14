# Final Project ----
# Assessing final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
load(here("03_attempt/data/testing_data.rda"))
load(here("03_attempt/results/final_fit_rf_4.rda"))

# producing predictions
attempt_03_rf_4 <- testing_data |>
  bind_cols(predict(final_fit_rf_4, testing_data, type = "prob")) |>
  rename(predicted = .pred_1) |>
  select(id, predicted)

write_csv(attempt_03_rf_4, here("submissions/attempt_03_rf_4.csv"))
