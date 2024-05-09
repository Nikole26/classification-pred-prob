# Classification Problem ----
# Setup preprocessing/recipes/feature engineering

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# loading training data -------
load(here("02_attempt/data/training_data.rda"))

# Recipe
recipe_2 <- recipe(host_is_superhost ~ ., data = training_data) |>
  step_rm(beds, host_verifications, host_response_time, latitude, longitude) |>
  step_impute_mean(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors()) |> 
  step_nzv(all_numeric_predictors()) |>
  step_corr(all_predictors(), threshold = 0.7) |>
  step_normalize(all_numeric_predictors())

recipe_2 |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

save(recipe_2, file = here("02_attempt/recipes/recipe_2.rda"))

