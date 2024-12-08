# L05 Feature Engineering II ----
# Model selection/comparison & analysis

# Load package(s) & set seed ----
library(tidymodels)
library(tidyverse)
library(here)

# Handle conflicts
tidymodels_prefer()

# load data
load(here("04_attempt/results/tune_mars_1.rda"))
load(here("04_attempt/results/nn_tune_1.rda"))
load(here("05_attempt/results/knn_tune_1.rda"))
load(here("05_attempt/results/rf_tune_1.rda"))
#load(here("03_attempt/results/bt_tune_1.rda"))

# comparison table
model_set <-
  as_workflow_set(
    #"nn_1" = nn_tune_1,
    "knn_1" = knn_tune_1,
    "rf_1" = rf_tune_1,
    #"mars_1" = tune_mars_1
  )

models_table_1 <- model_set |> 
  collect_metrics() |>
  filter(.metric == "roc_auc") |>
  arrange(desc(mean)) |>
  group_by(wflow_id) |>
  slice_max(mean, with_ties = FALSE) |>
  select(wflow_id, roc_auc = mean, std_err, n, model) |>
  ungroup() |>
  mutate(recipe = c("recipe 1")) |> 
  select(-wflow_id) |>
  arrange(desc(roc_auc))

save(models_table_1, file = here("05_attempt/results/models_table_1.rda"))
