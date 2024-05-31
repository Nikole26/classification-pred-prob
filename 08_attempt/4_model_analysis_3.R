# Classification Problem----
# Model selection/comparison & analysis

# Load package(s) & set seed ----
library(tidymodels)
library(tidyverse)
library(here)

# Handle conflicts
tidymodels_prefer()

# load data
load(here("08_attempt/results/rf_tune_3.rda"))
load(here("08_attempt/results/bt_tune_3.rda"))

# comparison table
model_set <-
  as_workflow_set(
    "bt_3" = bt_tune_3,
    "rf_3" = rf_tune_3,
  )

models_table_3 <- model_set |> 
  collect_metrics() |>
  filter(.metric == "roc_auc") |>
  arrange(desc(mean)) |>
  group_by(wflow_id) |>
  slice_max(mean, with_ties = FALSE) |>
  select(wflow_id, roc_auc = mean, std_err, n, model) |>
  ungroup() |>
  mutate(tuning = c("tuning 3")) |> 
  select(-wflow_id) |>
  arrange(desc(roc_auc))

save(models_table_3, file = here("08_attempt/results/models_table_3.rda"))
