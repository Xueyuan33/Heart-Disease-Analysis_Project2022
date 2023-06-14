
# Phase 1

# Load libraries
library(readr)
library(ggplot2)
library(tidyverse)

# Read in death data
data <- read.csv("1-preprocessing/Death_rate.csv")


death <- data %>%
  select(cause_name, year, val) %>%         # Select only the cause of death, the year, and no. of deaths
  mutate(total_death_num=sum(val)) %>%      # Calculate the total no. of deaths
  group_by(cause_name) %>%                  # Group the resulting data frame by the cause of death
  summarise(deaths_from_cause=sum(val), proportion_of_total_deaths=deaths_from_cause/total_death_num) %>% # Create death rate variable
  arrange(desc(deaths_from_cause))           


# Subset to get only top 10 causes of death
top_disease <- unique(death)[1:50,]

# Clean the data to remove rows that aggregate information for multiple conditions (e.g. Total disorders, diseases, infections, etc.)
# Remove sub-types of disease (e.g. specific type of stroke, we want just "Stroke")
# Remove causes that are not actually diseases (e.g. violence, trauma, complications during birth, etc.)
top_10_disease <- subset(top_disease, 
                         !(endsWith(cause_name, 'disorders')) &   
                           !(endsWith(cause_name, 'es')) &
                           !(endsWith(cause_name, 'infections')) & 
                           !(endsWith(cause_name, 'Neoplasms')) &
                           !(endsWith(cause_name, 'violence')) &
                           !(endsWith(cause_name, 'stroke')) &
                           !(endsWith(cause_name, 'tuberculosis')) &
                           !(endsWith(cause_name, 'malaria')) &
                           !(endsWith(cause_name, 'pain')) &
                           !(endsWith(cause_name, 'defects')) &
                           !(endsWith(cause_name, 'trauma')) &
                           !(endsWith(cause_name, 'birth')) &
                           !(endsWith(cause_name, '2')) &
                           !(startsWith(cause_name, 'Total')))


# Save top 10 disease data as csv to data folder, this is clean data
write.csv(top_10_disease, "2_data/phase1_data.csv", row.names = FALSE)

# Generate bar plot showing top 10 diseases and their corresponding death rate
top_10_disease %>%
  arrange(proportion_of_total_deaths) %>%
  ggplot(aes(x  = reorder(cause_name, proportion_of_total_deaths), y = proportion_of_total_deaths)) +
  geom_bar(stat = "identity", size=0.5, col = "darkred", fill = "darkred") +
  theme(axis.text.x = element_text(angle=60, hjust = 1)) +
  theme_minimal() +
  coord_flip() +
  labs(x="Disease", y="Proportion of total deaths", title="Top 10 Diseases (IHME)", 
       subtitle="Accurate for 2019")
