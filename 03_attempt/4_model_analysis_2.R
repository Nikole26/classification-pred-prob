# L05 Feature Engineering II ----
# Model selection/comparison & analysis

# Load package(s) & set seed ----
library(tidymodels)
library(tidyverse)
library(here)

# Handle conflicts
tidymodels_prefer()

# load data
load(here("03_attempt/results/nn_tune_2.rda"))
load(here("03_attempt/results/knn_tune_2.rda"))
load(here("03_attempt/results/rf_tune_2.rda"))

# comparison table
model_set <-
  as_workflow_set(
    "nn_2" = nn_tune_2,
    "knn_2" = knn_tune_2,
    #"rf_2" = rf_tune_2
  )

models_table_2 <- model_set |> 
  collect_metrics() |>
  filter(.metric == "roc_auc") |>
  arrange(desc(mean)) |>
  group_by(wflow_id) |>
  slice_max(mean, with_ties = FALSE) |>
  select(wflow_id, roc_auc = mean, std_err, n, model) |>
  ungroup() |>
  mutate(recipe = c( "recipe 2", "recipe 2")) |> 
  select(-wflow_id) |>
  arrange(desc(roc_auc))

save(models_table_1, file = here("03_attempt/results/models_table_1.rda"))
