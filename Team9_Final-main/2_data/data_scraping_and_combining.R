# Load libraries
library(rvest)
library(dplyr)
library(readr)
library(tidyverse)
library(readxl)

# Read climate html data from web
climateURL <- read_html("https://tcktcktck.org/countries")
# Get all tables from webpage
climate_tab <- climateURL %>% html_table(fill = TRUE)
# Use indexing to extract desired table
climate_data <- climate_tab[[1]]

# Save climate data frame as csv to preprocessing folder, this is raw data
write.csv(climate_data, "1-preprocessing/climate.csv", row.names = FALSE)


# Read freedom score html data from web
freedomURL <- read_html("https://freedomhouse.org/countries/freedom-world/scores")
# Get all tables from webpage
freedom_tab <- freedomURL %>% html_table(fill = TRUE)
# Use indexing to extract desired table
freedom_data <- freedom_tab[[1]]
# First rename first column of freedom_dat to be "Country"
colnames(freedom_data)[1] = "Country"
# For freedom data, we are only interested in total score and status, so we only select this column and Country
freedom_data <- freedom_data %>% select("Country", "Total Score and Status", "Political Rights", "Civil Liberties")
# Save freedom data frame as csv to preprocessing folder, this is raw data
write.csv(freedom_data, "1-preprocessing/freedom.csv", row.names = FALSE)

#-----------------------
# # Read climate data
# climate_data <- read.csv("climate.csv")
# 

# Read freedom data
freedom_data <- read.csv("1-preprocessing/freedom.csv")
# Split the score and status into two columns and rename columns
freedom_data <- freedom_data %>% 
  separate("Total.Score.and.Status", c("Freedom_score", "Freedom_status")) %>% 
  rename(Political_Rights= Political.Rights,
       Civil_Liberties = Civil.Liberties)
# Complete the wording of observations
freedom_data$Freedom_status <- gsub("Partly", "Partly Free", freedom_data$Freedom_status)
freedom_data$Freedom_status <- gsub("Not", "Not Free", freedom_data$Freedom_status)
  

# Read in population data from preprocessing folder
population_data <- read.csv("1-preprocessing/Global_population.csv")

# Select relevant columns
population_data <- population_data %>% 
  dplyr::select(Country.Name,X2019)

# Read in GDP data from preprocessing folder
gdp <-read.csv("1-preprocessing/GDP.csv")
# Select relevant columns
gdp_data <- gdp %>% 
  dplyr::select(Country.Name, X2019)

# Read in HDI data from preprocessing folder
HDI <- read.csv("HDI.csv")

# Read in disease data from preprocessing folder
disease_number <- read.csv("1-preprocessing/Ischemic_disease_global.csv")
# Filter for relevant metric and select relevant columns
disease_data <- disease_number %>% filter(metric_name=="Number") %>%
  filter(measure_name == "Deaths") %>% 
  dplyr::select(location_name, val)
disease_data[117,1]="United States"

#Read in healthcare spending data from preprocessing folder
health_spending<-read.csv("1-preprocessing/healthcare_expenditure_percapita.csv")
healthcare_spending_per <- health_spending %>%
  dplyr::select(Country.Name,X2019)


# Start building master data frame, Country is primary key

# Combine climate and freedom data on Country column (Country is primary key)
climate_data[178,1]="Russian Federation"
freedom_data[150,1]="Russian Federation"
climate_and_freedom <- merge(climate_data, freedom_data, by = "Country")
print(climate_data,n=246)

# Combine all remaining variables using left joins to construct master data frame
master_data <- climate_and_freedom %>%
  inner_join(population_data,by=c("Country"="Country.Name")) %>%
  inner_join(gdp_data, by=c("Country"="Country.Name")) %>%
  inner_join(HDI,by="Country") %>%
  inner_join(disease_data,by=c("Country"="location_name")) %>%
  inner_join(healthcare_spending_per,by=c("Country"="Country.Name"))

setdiff(climate_and_freedom$Country, population_data$Country.Name)

# Rename columns
colnames(master_data)[2]="Climate_Zone"
colnames(master_data)[3]="Avg_Temp_F"
colnames(master_data)[4]="Avg_Temp_C"
colnames(master_data)[5]="Freedom_Score"
colnames(master_data)[6]="Freedom_Status"
colnames(master_data)[7]="Political_Rights"
colnames(master_data)[8]="Civil_Liberties"
colnames(master_data)[9]="Population"
colnames(master_data)[10]="GDP"
colnames(master_data)[12]="Heart_Disease_Deaths"
colnames(master_data)[13]="Healthcare_Spending"
getOption("max.print")
# Write master data frame as csv to data folder
write.csv(master_data, "2_data/phase2_data.csv", row.names = FALSE)
