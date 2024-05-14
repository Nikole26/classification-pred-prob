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
load(here("03_attempt/results/knn_tune_3.rda"))
load(here("03_attempt/results/rf_tune_2.rda"))
load(here("03_attempt/results/tune_mars_2.rda"))


# comparison table
model_set <-
  as_workflow_set(
    #"nn_2" = nn_tune_2,
    "knn_3" = knn_tune_3,
    #"rf_2" = rf_tune_2,
    #"mars_2" = tune_mars_2
  )

models_table_3 <- model_set |> 
  collect_metrics() |>
  filter(.metric == "roc_auc") |>
  arrange(desc(mean)) |>
  group_by(wflow_id) |>
  slice_max(mean, with_ties = FALSE) |>
  select(wflow_id, roc_auc = mean, std_err, n, model) |>
  ungroup() |>
  mutate(recipe = c("recipe 3"))|> 
  select(-wflow_id) |>
  arrange(desc(roc_auc))

save(models_table_2, file = here("03_attempt/results/models_table_2.rda"))
