# Classification Problem ----
# Setup preprocessing/recipes/feature engineering

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# loading training data -------
load(here("03_attempt/data/training_data.rda"))

# Recipe 1
recipe_1 <- recipe(host_is_superhost ~ ., data = training_data) |>
  step_rm(host_verifications, host_response_time) |>
  step_impute_mean(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors()) |> 
  step_nzv(all_numeric_predictors()) |>
  step_normalize(all_numeric_predictors())

# Recipe 2
recipe_2 <- recipe(host_is_superhost ~ ., data = training_data) |>
  step_rm(id, host_verifications, host_response_time, beds, first_review_year, last_review_year, 
          host_has_profile_pic, host_identity_verified, has_availability, instant_bookable, 
          longitude, latitude, reviews_per_month) |>
  step_impute_knn(all_numeric_predictors(), neighbors = 5) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors()) |> 
  step_corr(all_predictors(), threshold = 0.7) |>
  step_nzv(all_numeric_predictors()) |>
  step_normalize(all_numeric_predictors())

recipe_2 |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

save(recipe_1, file = here("03_attempt/recipes/recipe_1.rda"))
save(recipe_2, file = here("03_attempt/recipes/recipe_2.rda"))
