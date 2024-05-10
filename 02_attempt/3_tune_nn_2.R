# L04 Feature Engineering I ----
# Single layer neural net tuning, simple imputation ----

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(tictoc)
library(here)
library(parallel)
library(doParallel)

# Handle conflicts
tidymodels_prefer()

# parallel processing ----
num.cores <- detectCores((logical = TRUE)/2)
registerDoParallel(cores = num.cores)

# load resamples ----
load(here("02_attempt/data/air_bnb_folds.rda"))

# load preprocessing/recipe ----
load(here("02_attempt/recipes/recipe_2.rda"))

# model specifications ----
nn_model <- mlp(
  mode = "classification", 
  hidden_units = tune(),
  penalty = tune()
) %>%
  set_engine("nnet")

# define workflow ----
nn_wflow <-
  workflow() |>
  add_model(nn_model) |>
  add_recipe(recipe_2)

# hyperparameter tuning values ----
nn_params <- extract_parameter_set_dials(nn_model)
nn_grid <- grid_regular(nn_params, levels = 5)

# tuning code in here
set.seed(145)
nn_tune_2 <- tune_grid(
  nn_wflow,
  resamples = air_bnb_folds,
  grid = nn_grid,
  control = control_grid(save_workflow = TRUE)
)

# write out results (fitted/trained workflows & runtime info) ----
save(
  nn_tune_2,
  file = here("02_attempt/results/nn_tune_2.rda")
)
