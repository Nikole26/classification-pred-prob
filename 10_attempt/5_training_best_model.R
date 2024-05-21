# Final Project ----
# Select final model and train it

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(bonsai)

# loading necessary data
load(here("10_attempt/results/bt_tune_2.rda"))
load(here("10_attempt/data/training_data.rda"))

# Best Model --------
select_best(bt_tune_2, metric = "roc_auc")

# finalize workflow for roc-----
final_wflow_roc <- bt_tune_2 |>
  extract_workflow(bt_tune_2) |>
  finalize_workflow(select_best(bt_tune_2, metric = "roc_auc"))

# train final model----
set.seed(115)
final_fit_bt <-  fit(final_wflow_roc, training_data)

# saving results-------
save(final_fit_bt, file = here("10_attempt/results/final_fit_bt.rda"))
