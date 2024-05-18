# Classification Problem - Attempt 5 ----
# Define and fit Boost Tree 

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(parallel)
library(doParallel)
library(bonsai)

# handle common conflicts
tidymodels_prefer()

# Handle conflicts
tidymodels_prefer()

# parallel processing ----
num.cores <- detectCores(logical = TRUE)
registerDoParallel(cores = num.cores/2)

# load resamples ----
load(here("08_attempt/data/air_bnb_folds.rda"))

# load preprocessing/recipe ----
load(here("08_attempt/recipes/recipe_2.rda"))

# model specifications ----
bt_model <- boost_tree(mode = "classification", 
                       mtry = tune(),
                       min_n = tune(),
                       learn_rate = tune()) |> 
  set_engine("lightgbm")

# define workflows ----
bt_wflow <- 
  workflow() |>
  add_model(bt_model) |>
  add_recipe(recipe_2)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(bt_model)
# change hyperparameter ranges
bt_params <- parameters(bt_model) |>
  update(mtry = mtry(c(20, 40)), 
         min_n = min_n(c(5, 25)),
         learn_rate = learn_rate(c(1000, 5000))) 
# build tuning grid
bt_grid <- grid_regular(bt_params, levels = 5)

# fit workflows/models ----
#set seed
set.seed(132)
bt_tune_2 <- tune_grid(bt_wflow,
                        air_bnb_folds,
                        grid = bt_grid,
                        control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(bt_tune_2, file = here("08_attempt/results/bt_tune_2.rda"))
