# Classification Problem ----
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
load(here("01_attempt/data/air_bnb_folds.rda"))

# load preprocessing/recipe ----
load(here("01_attempt/recipes/recipe_1.rda"))

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
  add_recipe(recipe_1)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_model)

# change hyperparameter ranges
rf_params <- parameters(rf_model) |>
  update(mtry = mtry(c(1, 13)),
         min_n = min_n(c(5, 50))) 

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5)

# tune/fit workflow/model ----
tic.clearlog() # clear log
tic("rf_tune_1: recipe 1") # start clock

# fit workflows/models ----
set.seed(7102)
rf_tune_1 <- tune_grid(rf_wflow,
                        air_bnb_folds,
                        grid = rf_grid,
                        control = control_grid(save_workflow = TRUE))

toc(log = TRUE)

# Extract runtime info
time_log <- tic.log(format = FALSE)

tictoc_rf_1 <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

# write out results (fitted/trained workflows) ----
save(
  rf_tune_1,
  file = here("01_attempt/results/rf_tune_1.rda"))

save(
  tictoc_rf_1,
  file = here("01_attempt/results/tictoc_rf_1.rda")
)
