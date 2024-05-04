# L05 Feature Engineering II ----
# Tuning for MARS FE model  ----

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
num.cores <- (detectCores(logical = TRUE)/2)
registerDoParallel(cores = num.cores)

# load resamples ----
load(here("data/air_bnb_folds.rda"))

# load preprocessing/recipe ----
load(here("01_attempt/recipes/recipe_1.rda"))

# model specifications ----
mars_spec <- mars(
  num_terms = tune(),
  prod_degree = tune()
) |>
  set_mode("classification") |>
  set_engine("earth")

# define workflow ----
mars_wflow <-
  workflow() |>
  add_model(mars_spec) |>
  add_recipe(recipe_1)

# hyperparameter tuning values ----
mars_params <- hardhat::extract_parameter_set_dials(mars_spec) |>
  update(
    num_terms = num_terms(range = c(1L, 5L))
  )

# build grid
mars_grid <- grid_regular(
  mars_params,
  levels = c(
    "num_terms" = 5,
    "prod_degree" = 2)
)

# tune/fit workflow/model ----
tic.clearlog() # clear log
tic("mars_1") # start clock

# tuning code in here
tune_mars_1 <- tune_grid(
  mars_wflow,
  resamples = air_bnb_folds,
  grid = mars_grid,
  control = control_grid(save_workflow = TRUE)
)

toc(log = TRUE)

# Extract runtime info
time_log <- tic.log(format = FALSE)

tictoc_mars_1 <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

# write out results (fitted/trained workflows & runtime info) ----
save(
  tune_mars_1,
  file = here("01_attempt/results/tune_mars_1.rda")
)

save(
  tictoc_mars_1,
  file = here("01_attempt/results/tictoc_mars_1.rda")
)
