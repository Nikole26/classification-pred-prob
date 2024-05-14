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
load(here("03_attempt/data/training_data.rda"))

# Recipe 1
recipe_1 <- recipe(host_is_superhost ~ ., data = training_data) |>
  step_rm(id, host_verifications, host_response_time, beds, first_review_year, last_review_year, 
          host_has_profile_pic, host_identity_verified, has_availability, instant_bookable, 
          longitude, latitude, reviews_per_month, neighbourhood_cleansed, property_type, room_type) |>
  step_impute_median(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors()) |> 
  step_nzv(all_numeric_predictors()) |>
  step_normalize(all_numeric_predictors()) 

# Recipe 2
recipe_2 <- recipe(host_is_superhost ~ ., data = training_data) |>
  step_rm(id, host_verifications, host_response_time, beds, first_review_year, last_review_year, 
          host_has_profile_pic, host_identity_verified, has_availability, instant_bookable, 
          longitude, latitude, reviews_per_month, neighbourhood_cleansed, property_type, room_type) |>
  step_impute_median(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_normalize(all_numeric_predictors()) 

# Recipe 3
recipe_3 <- recipe(host_is_superhost ~ ., data = training_data) |>
  step_rm(id, host_verifications, host_response_time, beds, first_review_year, last_review_year, 
          host_has_profile_pic, host_identity_verified, has_availability, instant_bookable, 
          longitude, latitude, reviews_per_month, neighbourhood_cleansed, property_type, room_type) |>
  step_impute_median(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_log(all_numeric_predictors(), -c(host_acceptance_rate, availability_30, availability_60,
                                        availability_90, availability_365, number_of_reviews,
                                        number_of_reviews_ltm, number_of_reviews_l30d,
                                        calculated_host_listings_count_entire_homes,
                                        calculated_host_listings_count_private_rooms, bathrooms)) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_corr(all_predictors(), threshold = 0.7, method = "spearman") |>
  step_nzv(all_predictors()) |>
  step_normalize(all_numeric_predictors(), na_rm = TRUE)

# Recipe 4
recipe_4 <- recipe(host_is_superhost ~ ., data = training_data) |>
  step_rm(id, host_verifications, host_response_time, beds, first_review_year, last_review_year, 
          host_has_profile_pic, host_identity_verified, has_availability, instant_bookable, 
          longitude, latitude, reviews_per_month, neighbourhood_cleansed, property_type, room_type) |>
  step_impute_mean(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_nzv(all_numeric_predictors()) |>
  step_dummy(all_nominal_predictors()) |>
  step_normalize(all_numeric_predictors())

recipe_4 |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

save(recipe_1, file = here("03_attempt/recipes/recipe_1.rda"))
save(recipe_2, file = here("03_attempt/recipes/recipe_2.rda"))
save(recipe_3, file = here("03_attempt/recipes/recipe_3.rda"))
save(recipe_4, file = here("03_attempt/recipes/recipe_4.rda"))

