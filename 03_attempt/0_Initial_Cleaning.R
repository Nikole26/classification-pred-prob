#### Initial Cleaning

# Load package(s) 
library(tidymodels)
library(tidyverse)
library(here)

#Loading data-------
air_bnb_data <- read_csv(here("data/train_classification.csv"),
                         col_types = cols(id = col_character()))
air_bnb_dictionary <- readxl::read_excel(here("data/data_dictionary.xlsx"))
air_bnb_test_data <- read_csv(here("data/test_classification.csv"),
                              col_types = cols(id = col_character()))

# training data tidy-----
training_data <- air_bnb_data |>
  mutate(
    ### creating factors -----
    host_response_time = factor(host_response_time),
    room_type = factor(room_type),
    host_verifications = factor(host_verifications),
    neighbourhood_cleansed = factor(neighbourhood_cleansed),
    property_type = factor(property_type),
    host_is_superhost = factor(if_else(host_is_superhost == TRUE, 1, 0),
                               levels = c(0, 1), ordered = TRUE),
    ### managing numbers ------
    host_response_rate = as.numeric(sub("%", "", host_response_rate)),
    host_acceptance_rate = as.numeric(sub("%", "", host_acceptance_rate)),
    bathrooms = if_else(str_detect(bathrooms_text, "alf"), 0.5, parse_number(bathrooms_text)),
    
    ### eliminating logicals -----
    host_has_profile_pic = factor(host_has_profile_pic, levels = c(1, 0)),
    host_identity_verified = factor(host_identity_verified, levels = c(1, 0)), 
    has_availability = factor(has_availability, levels = c(1, 0)),
    instant_bookable = factor (instant_bookable, levels = c(1, 0)),
    
    ### managing dates -----
    host_since = year(host_since),
    year_since = factor(host_since - 0),
    last_review = year(last_review),
    last_review_year = factor(last_review - 0),
    first_review = year(first_review),
    first_review_year = factor(first_review - 0)) |>
  
  select(-c(bathrooms_text, host_neighbourhood, host_since, last_review, first_review, host_location))

# testing data tidy-------
testing_data <- air_bnb_test_data |>
  mutate(host_response_time = factor(host_response_time),
         room_type = factor(room_type),
         host_verifications = factor(host_verifications),
         neighbourhood_cleansed = factor(neighbourhood_cleansed),
         property_type = factor (property_type),
         host_response_rate = as.numeric(sub("%", "", host_response_rate)),
         host_acceptance_rate = as.numeric(sub("%","", host_acceptance_rate)),
         bathrooms = if_else(str_detect (bathrooms_text, "alf"), 0.5, parse_number (bathrooms_text)),
         host_has_profile_pic = factor (host_has_profile_pic, levels = c(1, 0)),
         host_identity_verified = factor(host_identity_verified, levels = c(1, 0)),
         has_availability = factor(has_availability, levels = c(1, 0)),
         instant_bookable = factor(instant_bookable, levels = c(1, 0)),
         host_since = year(host_since),
         year_since = factor(host_since - 0),
         last_review = year(last_review),
         last_review_year = factor(last_review - 0),
         first_review = year(first_review),
         first_review_year = factor(first_review - 0)) |>
  
  select (-c(bathrooms_text, host_neighbourhood, host_since, last_review, first_review, host_location))

# Save out Cleaned Data
save(training_data, file = here("03_attempt/data/training_data.rda"))
save(testing_data, file = here("03_attempt/data/testing_data.rda"))
       