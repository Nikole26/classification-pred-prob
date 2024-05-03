# Classification Problem ----
# Setup preprocessing/recipes/feature engineering

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# loading training data -------
load(here("data/training_data.rda"))

# Recipe
recipe_1 <- recipe(host_is_superhost ~ ., data = training_data) |>
  step_impute_mean(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors()) |> 
  step_nzv(all_numeric_predictors()) |>
  step_normalize(all_numeric_predictors())

recipe_1 |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

save(recipe_1, file = here("recipes/recipe_1.rda"))

