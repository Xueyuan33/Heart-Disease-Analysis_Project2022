# Final EDA Project - Team 9

# Contents

1. [Preprocessing](https://github.com/DSI-EDA-2022/Team9_Final/tree/main/1-preprocessing)
2. [Data](https://github.com/DSI-EDA-2022/Team9_Final/tree/main/2_data)
3. [Main Findings](https://github.com/DSI-EDA-2022/Team9_Final/tree/main/3_main_findings)
4. [Deliverables](https://github.com/DSI-EDA-2022/Team9_Final/tree/main/4_deliverables)

# Research idea

The overarching aim of our project is to investigate disease in different countries from different key standpoints. Specifically, we will analyze this issue in-depth by examining the local climate, economy, and political system. The question we hope to answer is if these factors are related to the incidence of a particular disease. This will involve combining around 3-4 different data sets to make a single data frame on which we can perform our analysis and inference. To accomplish this, our project will be divided into three main components, or phases, as described below. 

## Phase 1: Disease and mortality

The first phase of our project will be to analyze disease and mortality data. The goal is to identify the current deadliest disease (the disease that has been responsible for the most deaths worldwide, based on the most recent data available). Visualizations (most likely a bar plot) will be used to showcase the top 10 diseases responsible for the most deaths. From this visualization, the deadliest disease by total mortality can be identified. This disease will be our focus for the remainder of our analysis. 

## Phase 2: Main exploratory data analysis

This is the most significant portion of our project. In this phase, we will combine multiple data sets to create a data frame that will serve as the starting point for the remainder of the project. Presently, we envision that the final data frame will consist of around 195 rows, where each row represents a country (there are 195 countries in the world, but it is unlikely that we will be able to find all the relevant data for all these countries, and so the final table will most likely have slightly fewer observations). Additionally, we plan to have eight columns (variables/features) in total. These are listed below:

* Country (1)
* Mortality rate (deaths from disease/total population) (2)
* Climate zone (we will use the Köppen classification) (3)
* Freedom score (4)
* Economic and welfare indicators, which are sub-divided into:
    - GDP (5)
    - GDP per capita (6)
    - HDI (7)
    - Net spend on public healthcare (8)

Our goal in this phase is to determine if disease mortality rate is correlated with some or all of the other variables. Additionally, we hope to use clustering machine learning algorithms (such as K-means clustering) and visualizations to investigate if we can classify countries into different groups based on these other factors. This will add another level to our exploration by allowing us to see if certain groups (e.g. countries with a specific climate, such as tropical) have higher mortality rates from disease than other groups. 

## Phase 3: Time series analysis

Note that time is fixed for phases 1 and 2 of our project. Thus, the final phase will be a time series analysis. After phase 2 has concluded, we will be able to identify the country with the highest mortality rate from this disease. Therefore, it would be interesting to see how they arrived at this point over time. We will use historical data to perform a time series analysis that shows how total mortality changed with time, along with the economic indicators. The visualization we will use here is a line plot. This will allow us to determine if these variables follow a similar pattern over time. 

# Data sets

## Climate data

Link: https://tcktcktck.org/countries

Description: This data set contains information about different countries, their average annual temperature, and their climate zone (according to the Köppen classification). The data is stored as a table. We will need to read this data into R, which will likely involve using the `rvest` package and the `read_html()` function. 

## GBD data

Link: https://vizhub.healthdata.org/gbd-results/

Description: The data examines trends from 1990 to 2019 of the Global Burden of Disease (GBD) and mortality and disability from hundreds of diseases, injuries, and risk factors around the world. The data is stored as a table in CSV format. When reading data into R, we will need `read_csv()` function.

## Government data

Link: https://apps.who.int/nha/database/ViewData/Indicators/en

Description: This data shows government spending on healthcare for each country from 2012 to 2019. It includes Capital health expenditure, general government expenditure,Current health expenditure by Diseases and Conditions. The data is stored as a xlsx file, we can load 'library("readxl")', then we can use 'read_excel()' function in R.

## Population data

Link: https://data.worldbank.org/indicator/SP.POP.TOTL

Description: This data shows the population by countries. It is in the csv form so we can use read_csv in R to load data.

## Gross Domestic Product(GDP) data

Link: https://data.oecd.org/gdp/gross-domestic-product-gdp.htm

Description: This data shows the gross domestic product for each country per year. It is in the csv form so we can use read_csv in R to load data.

## Freedom score and status data

Link: https://freedomhouse.org/countries/freedom-world/scores

Description: This data set shows the freedom score and status of 210 countries based on the people’s access to political rights and civil liberties in the 210 countries and territories through its annual Freedom in the World report. 

## Human Development Index(HDI) data

Link: https://hdr.undp.org/data-center/human-development-index#/indicies/HDI

Description: The Human Development Index (HDI) is a summary measure of average achievement in key dimensions of human development: a long and healthy life, being knowledgeable and have a decent standard of living. The HDI is the geometric mean of normalized indices for each of the three dimensions. The Data is  a xlsx file so we could read it in R.

# Timeline

## Soft deadlines

Phase 1: 10/31

Phase 2: 11/09

Phase 3: 11/14

Research paper first draft: 11/30

Create and practice presentation: 12/07

## Hard deadlines

Research paper final draft: 12/11 at 11:59 PM

Final presentation: 12/12 at 9 AM - 12 PM
