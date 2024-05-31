# Classification Problem ----
# Model selection/comparison & analysis

# Load package(s) & set seed ----
library(tidymodels)
library(tidyverse)
library(here)

# Handle conflicts
tidymodels_prefer()

# load data
load(here("01_attempt/results/tune_mars_1.rda"))
load(here("01_attempt/results/nn_tune_1.rda"))
load(here("01_attempt/results/tictoc_mars_1.rda"))
load(here("01_attempt/results/tictoc_mlp_1.rda"))
load(here("01_attempt/results/knn_tune_1.rda"))
load(here("01_attempt/results/tictoc_knn_1.rda"))
load(here("01_attempt/results/rf_tune_1.rda"))
load(here("01_attempt/results/tictoc_rf_1.rda"))

# comparison table
model_set <-
  as_workflow_set(
    "mars_1" = tune_mars_1,
    "nn_1" = nn_simple_tune,
    "knn_1" = knn_tune_1,
    "rf_1" = rf_tune_1
  )

models_table <- model_set |> 
  collect_metrics() |>
  filter(.metric == "roc_auc") |>
  arrange(desc(mean)) |>
  group_by(wflow_id) |>
  slice_max(mean, with_ties = FALSE) |>
  select(wflow_id, roc_auc = mean, std_err, n, model) |>
  ungroup() |>
  mutate(recipe = c("recipe 1", "recipe 1", "recipe 1", "recipe 1")
         #runtime = c(tictoc_mars_1$runtime,
          #           tictoc_mlp_simple$runtime,
           #          tictoc_knn_1$runtime)
         ) |>
  select(-wflow_id) |>
  arrange(desc(roc_auc))

save(models_table, file = here("01_attempt/results/models_table.rda"))

rf_autplot <- autoplot(rf_tune_1, metric = "roc_auc") +
  theme_minimal()

save(models_table, file = here("01_attempt/results/models_table.rda"))
save(rf_autplot, file = here("01_attempt/results/rf_autplot.rda"))
