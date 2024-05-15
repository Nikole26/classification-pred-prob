# Classification Problem - Attempt 2 ----
# Define and fit Knn model ----

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
load(here("04_attempt/data/air_bnb_folds.rda"))

# load preprocessing/recipe ----
load(here("04_attempt/recipes/recipe_1.rda"))

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
  update(neighbors = neighbors(range = c(5, 15))) 
# build tuning grid
knn_grid <- grid_regular(knn_params, levels = 5)

# fit workflows/models ----
set.seed(3436)
knn_tune_1 <- tune_grid(knn_wflow,
                       air_bnb_folds,
                       grid = knn_grid,
                       control = control_grid(save_workflow = TRUE))


# write out results (fitted/trained workflows) ----
save(knn_tune_1, 
     file = here("04_attempt/results/knn_tune_1.rda"))
