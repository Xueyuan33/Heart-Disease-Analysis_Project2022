# Load required packages
require(tidyverse)
require(dplyr)
require(ggplot2)
require(factoextra)

# Read in data from the master csv file
all_data <- read_csv("2_data/master.csv")

# Select relevant data
my_data <- all_data %>%
  select("Country", "Climate_Zone", "Avg_Temp_C", "Population", "Heart_Disease_Deaths")

# Part 1: Heart Disease Deaths vs Temperature

# Calculate death rate
my_data <- my_data %>%
  mutate(Death_Rate=Heart_Disease_Deaths/Population)

# Compute mean death rate
mean_rate <- mean(my_data$Death_Rate, na.rm=TRUE)

# Calculate mean temperature and create hot and cold categories
mean_tmp <- mean(my_data$Avg_Temp_C)
my_data <- my_data %>%
  mutate(Temperature_Category = ifelse(Avg_Temp_C <= mean_tmp, "Cold", "Hot"))


# Scatter plot of death rate and temperature category
cols <- c("Hot" = "tomato", "Cold" = "mediumturquoise")
ggplot(my_data, aes(x=Avg_Temp_C, y=Death_Rate, col=Temperature_Category)) + 
  geom_point() +
  geom_vline(xintercept = mean_tmp, col="darkgrey", linetype="dashed") +
  geom_hline(yintercept = mean_rate, col="darkgrey", linetype="dashed") +
  labs(x = "Average annual temperature (°C)", y = "Heart disease death rate") + 
  guides(col=guide_legend(title="Temperature Category")) +
  ggtitle("Heart Disease Rate against Country Temperature Category") +
  scale_color_manual(values=cols) +
  theme_minimal() 

# Plot heart disease death rate against temperature
ggplot(my_data, aes(x=Avg_Temp_C, y=Death_Rate)) + 
  geom_point(col="red1") +
  # Add line of best fit
  geom_smooth(method = "lm", se = FALSE, col="blue") +
  # Log the y-axis scale to obtain a better visualization
  scale_y_continuous(trans="log10") +
  labs(x = "Average annual temperature (°C)", y = "Heart disease death rate (Logged Scale)") +
  ggtitle("Heart Disease Rate against Average Temperature") + 
  theme_minimal()

# Calculate correlation between heart disease deaths and average temperature
my_data_for_corr <- my_data %>% drop_na(Population,Death_Rate)
corr <- cor(my_data_for_corr$Avg_Temp_C, my_data_for_corr$Death_Rate)

# Part 2: Heart Disease Deaths and Climate Zone

# Visualize distribution of different climates
my_data %>% 
  group_by(Climate_Zone) %>% 
  summarise(count = n()) %>% 
  ggplot(aes(x = reorder(Climate_Zone,(-count)), y = count)) + 
  geom_bar(stat = 'identity', fill="royalblue") + 
  ylab("Count") + 
  xlab("Climate zone") +
  ggtitle("Distribution of Global Climate Zones") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))

# K-Means Clustering

# Set seed for reproducible results (same colors for clusters)
set.seed(123)

# Get variables of interest
cluster_vars <- my_data %>%
  select(Country, Climate_Zone, Avg_Temp_C, Death_Rate)

# Remove NAs
# Note: there is only one country that has NA value for relevant data, so dropping this one row should not affect our results too much.
cluster_vars <- na.omit(cluster_vars)

# Get labels, which is climate zone
cluster.labels = cluster_vars$Climate_Zone

# Cluster data is temperature and death rate
cluster_data <- cluster_vars[3:4]

# Scale data
cluster_data_scale <- scale(cluster_data)

# Distance (euclidean)
cluster_data <- dist(cluster_data_scale)

# Distance gradient
distance <- get_dist(cluster_data_scale)
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

# Function to calculate optimal number of clusters using elbow plot and within Sum Squares method
wssplot <- function(data, nc=15, seed=1234){
  wss <- (nrow(data)-1)*sum(apply(data,2,var))
  for (i in 2:nc){
    set.seed(seed)
    wss[i] <- sum(kmeans(data, centers=i)$withinss)}
  plot(1:nc, wss, type="b", col="blue",  main="Elbow Plot", xlab="Number of Clusters",
       ylab="Within-clusters sum of squares")
}

# Generate elbow plot
wssplot(cluster_data_scale)

# K-Means
km.out <- kmeans(cluster_data, centers=5, nstart=100)
print(km.out)

# Visualize the clustering algorithm results
km.clusters <- km.out$cluster
rownames(cluster_data_scale) <- paste(cluster.labels, 1:dim(cluster_vars)[1], sep="_")
fviz_cluster(list(data=dist(cluster_data_scale), cluster=km.clusters), main = "Cluster Plot of Climate Zones") +
  xlim(c(-20, 50)) +
  ylim(c(-10, 40)) +
  theme_minimal()

# Countries as labels
cluster.labels = cluster_vars$Country

# Visualize the clustering algorithm results
km.clusters <- km.out$cluster
rownames(cluster_data_scale) <- paste(cluster.labels)
fviz_cluster(list(data=dist(cluster_data_scale), cluster=km.clusters), main = "Cluster Plot of Countries") +
  xlim(c(-20, 50)) +
  ylim(c(-10, 40)) +
  theme_minimal()
         

# Plot of top 10 highest death rates
top_10_rates <- arrange(my_data, by=desc(Death_Rate)) %>%
  head(10)
 
top_10_rates %>%
  ggplot(aes(x = reorder(Country,(-Death_Rate)), y = Death_Rate, fill = Climate_Zone)) +
  geom_bar(stat = "identity") +
  labs(x = "Country", y = "Heart disease mortlaity rate", title = "Top 10 Countries by Heart Disease Mortality Rate",
       subtitle = "Accurate for 2019") +
  scale_fill_discrete(name = "Climate Zone") + 
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 
