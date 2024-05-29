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
  add_recipe(recipe_1)

# hyperparameter tuning values ----
nn_params <- extract_parameter_set_dials(nn_model)
nn_grid <- grid_regular(nn_params, levels = 5)

# tune/fit workflow/model ----
tic.clearlog() # clear log
tic("nn_simple_tune: RECIPE 1") # start clock

# tuning code in here
set.seed(142)
nn_tune_1 <- tune_grid(
  nn_wflow,
  resamples = air_bnb_folds,
  grid = nn_grid,
  control = control_grid(save_workflow = TRUE)
)

toc(log = TRUE)

# Extract runtime info
time_log <- tic.log(format = FALSE)

tictoc_mlp_1 <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

# write out results (fitted/trained workflows & runtime info) ----
save(
  nn_tune_1,
  file = here("01_attempt/results/nn_tune_1.rda")
)

save(
  tictoc_mlp_1,
  file = here("01_attempt/results/tictoc_mlp_1.rda")
)

