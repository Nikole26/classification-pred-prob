# Classification Problem----
# Assessing final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
load(here("08_attempt/data/testing_data.rda"))
load(here("08_attempt/results/final_fit_rf_1.rda"))

# producing predictions
attempt_08_rf_3 <- testing_data |>
  bind_cols(predict(final_fit_rf_1, testing_data, type = "prob")) |>
  rename(predicted = .pred_1) |>
  select(id, predicted)

write_csv(attempt_08_rf_3, here("submissions/attempt_08_rf_3.csv"))
