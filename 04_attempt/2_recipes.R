# Classification Problem ----
# Setup preprocessing/recipes/feature engineering

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(here)
library(recipes)
library(car)

# handle common conflicts
tidymodels_prefer()

# loading training data -------
load(here("04_attempt/data/training_data.rda"))

# Recipe 1
recipe_1 <- recipe(host_is_superhost ~ ., data = training_data) |>
  step_rm(id, host_verifications, host_response_time, beds, first_review_year, last_review_year, 
          host_has_profile_pic, host_identity_verified, has_availability, instant_bookable, 
          longitude, latitude, reviews_per_month, neighbourhood_cleansed, property_type, room_type,
          availability_30, availability_60, availability_90, availability_365) |>
  step_impute_mean(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors()) |>
  step_nzv(all_numeric_predictors()) |>
  step_normalize(all_numeric_predictors())

# Recipe 2
recipe_2 <- recipe(host_is_superhost ~ ., data = training_data) |>
  step_mutate(host_listings_ratio = host_listings_count / host_total_listings_count) |>
  step_rm(host_listings_count, host_total_listings_count,id, 
          host_verifications, host_response_time, beds, first_review_year, last_review_year, 
          host_has_profile_pic, host_identity_verified, has_availability, instant_bookable, 
          longitude, latitude, reviews_per_month, neighbourhood_cleansed, property_type, room_type,
          availability_30, availability_60, availability_90, availability_365,
          bathrooms, has_availability, minimum_nights, maximum_nights, minimum_maximum_nights, 	
          maximum_maximum_nights) |>
  step_impute_mean(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_nzv(all_numeric_predictors()) |>
  step_normalize(all_numeric_predictors())

recipe_2 |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

save(recipe_1, file = here("04_attempt/recipes/recipe_1.rda"))
save(recipe_2, file = here("04_attempt/recipes/recipe_2.rda"))
