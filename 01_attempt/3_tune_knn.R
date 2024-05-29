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
load(here("01_attempt/data/air_bnb_folds.rda"))

# load preprocessing/recipe ----
load(here("01_attempt/recipes/recipe_1.rda"))

# model specifications ----
knn_model <-
  nearest_neighbor(mode = "classification",
                   neighbors = tune()) |>
  set_engine("kknn")

# define workflows ----
knn_wflow <- 
  workflow() |>
  add_model(knn_model) |>
  add_recipe(recipe_1)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(knn_model)
# change hyperparameter ranges
knn_params <- parameters(knn_model) |>
  update(neighbors = neighbors(range = c(1, 10))) 
# build tuning grid
knn_grid <- grid_regular(knn_params, levels = 5)

# tune/fit workflow/model ----
tic.clearlog() # clear log
tic("knn_tune_1: RECIPE 1") # start clock

# fit workflows/models ----
set.seed(7026)
knn_tune_1 <- tune_grid(knn_wflow,
                       air_bnb_folds,
                       grid = knn_grid,
                       control = control_grid(save_workflow = TRUE))

toc(log = TRUE)

# Extract runtime info
time_log <- tic.log(format = FALSE)

tictoc_knn_1 <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

# write out results (fitted/trained workflows) ----
save(knn_tune_1, 
     file = here("01_attempt/results/knn_tune_1.rda"))

save(
  tictoc_knn_1,
  file = here("01_attempt/results/tictoc_knn_1.rda")
)

