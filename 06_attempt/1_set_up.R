# Classification Problem ----
# Processing training, creating resamples

# Load package(s)
library(tidymodels)
library(tidyverse)
library(here)

# handle common conflicts
tidymodels_prefer()

# read in training data -------
load(here("06_attempt/data/training_data.rda"))

# create resamples (10-fold cv with 4 repeats) ----------
set.seed(1274)
air_bnb_folds <- training_data |>
  vfold_cv(v = 10, repeats = 5, host_is_superhost)

save(air_bnb_folds, file = here("06_attempt/data/air_bnb_folds.rda"))
