# Final Project ----
# Assessing final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
load(here("10_attempt/data/testing_data.rda"))
load(here("10_attempt/results/final_fit_bt.rda"))

# producing predictions
attempt_10_bt_2 <- testing_data |>
  bind_cols(predict(final_fit_bt, testing_data, type = "prob")) |>
  rename(predicted = .pred_1) |>
  select(id, predicted)

write_csv(attempt_10_bt_2, here("submissions/attempt_10_bt_2.csv"))
