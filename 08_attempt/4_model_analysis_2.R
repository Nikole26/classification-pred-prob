# Classification Problem ----
# Model selection/comparison & analysis

# Load package(s) & set seed ----
library(tidymodels)
library(tidyverse)
library(here)

# Handle conflicts
tidymodels_prefer()

# load data
load(here("08_attempt/results/rf_tune_2.rda"))
load(here("08_attempt/results/bt_tune_2.rda"))

# comparison table
model_set <-
  as_workflow_set(
    "bt_2" = bt_tune_2,
    "rf_2" = rf_tune_2,
  )

models_table_2 <- model_set |> 
  collect_metrics() |>
  filter(.metric == "roc_auc") |>
  arrange(desc(mean)) |>
  group_by(wflow_id) |>
  slice_max(mean, with_ties = FALSE) |>
  select(wflow_id, roc_auc = mean, std_err, n, model) |>
  ungroup() |>
  #mutate(recipe = c("recipe 2", "recipe 2", "model 3")) |> 
  select(-wflow_id) |>
  arrange(desc(roc_auc))

save(models_table_2, file = here("08_attempt/results/models_table_1.rda"))
