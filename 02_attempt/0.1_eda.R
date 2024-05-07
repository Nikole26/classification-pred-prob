## EDA -------------
load(here("02_attempt/data/training_data.rda"))

# Skiming thorugh the data-------
skimr::skim_without_charts(training_data)

# Most missingness is only in the review_scores_... variables, host_response_rate and host_acceptance_rate
# Exploring the target variable-----
skimr::skim_without_charts(training_data$host_is_superhost)

training_data |>
  ggplot(aes (x = host_is_superhost, fill = host_is_superhost) ) +
  geom_bar () +
  labs (y = "Count" , x = "Superhost Status") +
  theme_classic() + theme (legend.position = "none") +
  scale_fill_manual(values = c("darkgreen", "green"))

## No missingness in the target variable 
## There is slightly more present of the superhost not being a superhost than one being superhost. 
