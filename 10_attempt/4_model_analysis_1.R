# L05 Feature Engineering II ----
# Model selection/comparison & analysis

# Load package(s) & set seed ----
library(tidymodels)
library(tidyverse)
library(here)

# Handle conflicts
tidymodels_prefer()

# load data
load(here("10_attempt/results/rf_tune_1.rda"))
load(here("10_attempt/results/bt_tune_1.rda"))
load(here("10_attempt/results/rf_tune_2.rda"))
load(here("10_attempt/results/bt_tune_2.rda"))

# comparison table
model_set <-
  as_workflow_set(
    "bt_1" = bt_tune_1,
    "rf_1" = rf_tune_1,
    "bt_2" = bt_tune_2,
    "rf_2" = rf_tune_2,
  )

models_table <- model_set |> 
  collect_metrics() |>
  filter(.metric == "roc_auc") |>
  arrange(desc(mean)) |>
  group_by(wflow_id) |>
  slice_max(mean, with_ties = FALSE) |>
  select(wflow_id, roc_auc = mean, std_err, n, model) |>
  ungroup() |>
  mutate(recipe = c("recipe 1", "recipe 2", "recipe 2", "recipe 1")) |> 
  select(-wflow_id) |>
  arrange(desc(roc_auc))

bt_autoplot_2 <- autoplot(bt_tune_2, metric = "roc_auc") +
  labs(title = "Attempt 10 Boosted Tree Hyperparameters") +
  theme_minimal()

bt_autoplot_1 <- autoplot(bt_tune_1, metric = "roc_auc") +
  theme_minimal()

save(models_table, file = here("10_attempt/results/models_table.rda"))
save(bt_autoplot_2, file = here("10_attempt/results/bt_autoplot_2.rda"))
