# L05 Feature Engineering II ----
# Model selection/comparison & analysis

# Load package(s) & set seed ----
library(tidymodels)
library(tidyverse)
library(here)

# Handle conflicts
tidymodels_prefer()

# load data
load(here("03_attempt/results/nn_tune_4.rda"))
load(here("03_attempt/results/knn_tune_4.rda"))
load(here("03_attempt/results/rf_tune_4.rda"))
load(here("03_attempt/results/tune_mars_4.rda"))


# comparison table
model_set <-
  as_workflow_set(
    "nn_4" = nn_tune_4,
    "knn_4" = knn_tune_4,
    "rf_4" = rf_tune_4,
    "mars_4" = tune_mars_4
  )

models_table_4 <- model_set |> 
  collect_metrics() |>
  filter(.metric == "roc_auc") |>
  arrange(desc(mean)) |>
  group_by(wflow_id) |>
  slice_max(mean, with_ties = FALSE) |>
  select(wflow_id, roc_auc = mean, std_err, n, model) |>
  ungroup() |>
  mutate(recipe = c("recipe 4", "recipe 4", "recipe 4", "recipe 4"))|> 
  select(-wflow_id) |>
  arrange(desc(roc_auc))

save(models_table_4, file = here("03_attempt/results/models_table_4.rda"))
