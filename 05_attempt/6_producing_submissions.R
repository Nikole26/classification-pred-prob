# Final Project ----
# Assessing final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
load(here("05_attempt/data/testing_data.rda"))
load(here("05_attempt/results/final_fit_rf.rda"))

# producing predictions
attempt_05_rf_3 <- testing_data |>
  bind_cols(predict(final_fit_rf, testing_data, type = "prob")) |>
  rename(predicted = .pred_1) |>
  select(id, predicted)

write_csv(attempt_05_rf_3, here("submissions/attempt_05_rf_3.csv"))
