# Final Project ----
# Select final model and train it

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
load(here("03_attempt/results/rf_tune_4.rda"))
load(here("03_attempt/data/training_data.rda"))

# Best Model --------
select_best(rf_tune_4, metric = "roc_auc")

# finalize workflow for roc-----
final_wflow_roc <- rf_tune_4 |>
  extract_workflow(rf_tune_4) |>
  finalize_workflow(select_best(rf_tune_4, metric = "roc_auc"))

# train final model----
set.seed(150)
final_fit_rf_4 <-  fit(final_wflow_roc, training_data)

# saving results-------
save(final_fit_rf_4, file = here("03_attempt/results/final_fit_rf_4.rda"))
