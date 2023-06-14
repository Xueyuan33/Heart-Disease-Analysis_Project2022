# Load required packages
require(tidyverse)
require(dplyr)
require(ggplot2)

# Read in data from the master csv file
all_data <- read_csv("2_data/master.csv")

# Select relevant data
my_data <- all_data %>%
  select("Climate_Zone", "Avg_Temp_C", "Population", "Heart_Disease_Deaths")

# Part 1: Heart Disease Deaths vs Temperature

# Calculate death rate
my_data <- my_data %>%
  mutate(Death_Rate=Heart_Disease_Deaths/Population)

# Compute mean death rate
mean_rate <- mean(my_data$Death_Rate, na.rm=TRUE)

# Compute mean death rate
median_rate <- median(my_data$Death_Rate, na.rm=TRUE)

# Histogram and density plot, with mean and median
ggplot(my_data, aes(x = Death_Rate)) +
  geom_histogram(aes(y = ..density..), colour = "black", fill = "white") +
  geom_density(alpha = .2, fill="#FF6655") +
  geom_vline(xintercept=mean_rate, color="red", size=1) +
  geom_vline(xintercept=median_rate,  color="blue", size=1) +
  ylab("Density") +
  xlab("Heart disease mortality rate") +
  ggtitle("Distribution of Global Heart Disease Mortality Rate (2019)") + 
  theme_minimal()
