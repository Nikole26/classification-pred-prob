# Final Project ----
# Assessing final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
load(here("data/testing_data.rda"))
load(here("01_attempt/results/final_fit_roc.rda"))

# producing predictions
attempt_01_rf_01 <- testing_data |>
  bind_cols(predict(final_fit_roc, testing_data, type = "prob")) |>
  rename(predicted = .pred_1) |>
  select(id, predicted)

write.csv(attempt_01_rf_01, here("submissions/attempt_01_rf_01.csv"), row.names = FALSE)
