# Final Project ----
# Select final model and train it

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
load(here("07_attempt/results/rf_tune_1.rda"))
load(here("07_attempt/data/training_data.rda"))

# Best Model --------
select_best(rf_tune_1, metric = "roc_auc")

# finalize workflow for roc-----
final_wflow_roc <- rf_tune_1 |>
  extract_workflow(rf_tune_1) |>
  finalize_workflow(select_best(rf_tune_1, metric = "roc_auc"))

# train final model----
set.seed(114)
final_fit_rf <-  fit(final_wflow_roc, training_data)

# saving results-------
save(final_fit_rf, file = here("07_attempt/results/final_fit_rf.rda"))
