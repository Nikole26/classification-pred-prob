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
num.cores <- detectCores(logical = TRUE)
registerDoParallel(cores = num.cores/2)

# load resamples ----
load(here("03_attempt/data/air_bnb_folds.rda"))

# load preprocessing/recipe ----
load(here("03_attempt/recipes/recipe_2.rda"))

# model specifications ----
rf_model <-
  rand_forest(
    trees = 1000, 
    min_n = tune(),
    mtry = tune()
  ) |>
  set_mode("classification") |>
  set_engine("ranger")

# define workflows ----
rf_wflow <- 
  workflow() |>
  add_model(rf_model) |>
  add_recipe(recipe_2)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_model)

# change hyperparameter ranges
rf_params <- parameters(rf_model) |>
  update(mtry = mtry(c(10, 20)),
         min_n = min_n(c(3, 10))) 

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5)

# fit workflows/models ----
set.seed(6435)
rf_tune_2 <- tune_grid(rf_wflow,
                        air_bnb_folds,
                        grid = rf_grid,
                        control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(
  rf_tune_2,
  file = here("03_attempt/results/rf_tune_2.rda"))
