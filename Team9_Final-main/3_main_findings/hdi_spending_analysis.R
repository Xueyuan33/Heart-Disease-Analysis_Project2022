library(tidyverse)
library(ggplot2)
library(dplyr)
require(maps)
library(cluster)
library(factoextra) # clustering algorithms & visualization
library(janitor)
library(stats)
library(patchwork)

#The HDI data is from 
#The Human Development Index(HDI) is an index that measures key dimensions of human development. 
#The three key dimensions are: 
#a long and healthy life- measured by life expectancy;
#access to educatioinstn-measured by expected years of schooling of children at school-entry age and mean years of schooling of the adult population;
#a decent standard of living- to measure it by Gross National Income per capita.

# 

#1,Find the relationship between HDI and death rate 

#HDI is divided into four tiers: 
#very high human development (0.8-1.0), 
#high human development (0.7-0.79), 
#medium human development (0.55-.70), 
#low human development (below 0.55)

human_develop<-master%>%
  select(Country,HDI,Death_Number,Population)%>%
  mutate(Death_rate=Death_Number/Population,human_development = 
           case_when(
             HDI < 1 & HDI > 0.8 ~ "very high",
             HDI < 0.79 & HDI > 0.7 ~ "high",
             HDI < 0.7 & HDI > 0.55 ~ "medium",
             HDI < 0.55 ~ "low",
           ) %>% as.factor()
  )%>%
  drop_na(HDI,Death_rate,human_development)

human_develop%>%
  arrange(desc(Death_rate))

world_map <- map_data("world")
human_develop_map<-full_join(human_develop,world_map,by=c("Country"="region"))
human_develop_map%>%
  ggplot(aes(long, lat, group = group))+
  geom_polygon(aes(fill = HDI), color = "white")+
  labs(title="Human development Level distribution around the world")+
  xlab("Longitude")+
  ylab("Latitude")+
  theme_light()

ggsave("human_develop_map2.png")



human_develop%>%
  group_by(Death_rate, human_development)%>%
  ggplot(aes(x=human_development, y=Death_rate))+
  geom_bar(stat="identity")+
  labs(title="Death Rate between different Human development Level")+
  xlab("Human Development Level")+
  ylab("Death Rate")



#Cluster plot for HDI and Heart death rate
# keep the variables we're interested in
df_new <- human_develop %>% 
  clean_names() %>% 
  column_to_rownames("country")%>%
  dplyr::select('death_rate', "hdi")

# scale the new dataframe 
df_new <-scale(df_new)
df_new<- na.omit(df_new)
distance <- get_dist(df_new)
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

# compute k-means with k=5
set.seed(1234)
k2 <- kmeans(df_new, centers = 5, nstart = 25)
fviz_cluster(k2, data = df_new) +
  theme_minimal()+
  labs(title="Cluster plot for HDI and Heart death rate")

#From this cluster plot, we can find the cluster 3 which contains five countries: Bulgaria, Latvia, Lithuania, Ukraine, Belarus. 
#These five countries happen to be the top 5 countries in terms of heart disease mortality. Also at the same time, four of these countries have very high human development(HDI)
#This is a very interesting finding. Why high HDI countries also have very high heart disease death rate?


#We use bar plot and try to find out if there is any relationship between heart disease death rate and human development level. 
#We get a very interesting result that the higher the level of human development, the higher the heart disease death rate.
#We know the HDI index based on three dimensions: health, education, and standard of living.


#So we continue to find the location for the countries with very high HDI, and try to find relationship between country and HDI.
#We select the Country with very high HDI and see the position on map.


#Show the TOP HDI distribution On the world map
#Select top 5 high death rate countries which have very high hdi
top_death<-human_develop%>%
  filter(Country=="Bulgaria"|Country=="Latvia"|Country=="Lithuania"|Country=="Ukraine"|Country=="Belarus")
top_death<-data.frame(top_death,name=c('BU','LAT','LIT','UKR','BEL'))
#filter(human_development=="very high")%>%
#arrange(desc(Death_rate))%>%
#top_n(5, Death_rate)

world_map <- map_data("world")

human_develop_map<-full_join(human_develop,world_map,by=c("Country"="region"))
top5<-full_join(top_death,human_develop_map,by="Country" )

human_develop_map%>%
  ggplot(aes(long, lat, group = group))+
  geom_polygon(aes(fill = HDI), color = "white")+
  labs(title="Human development Level distribution around the world")+
  xlab("Longitude")+
  ylab("Latitude")+
  theme_light()+
  geom_text(data=top5, aes(x=long,y=lat, label=name), color="orange", size=0.5)

ggsave("human_develop_map1.png")



#2, Find the relationship between healthcare spending and death rate

master%>%
  select(Country,Death_Number,Population,Healthcare_Spending)%>%
  mutate(Death_rate=Death_Number/Population)%>%
  arrange(desc(Healthcare_Spending))%>%
  drop_na(Healthcare_Spending,Death_rate)%>%
  group_by(Healthcare_Spending)%>%
  ggplot(aes(x=Healthcare_Spending, y=Death_rate))+
  #geom_bar(stat="identity",fill="steelblue")+
  geom_point()+
  geom_smooth(color="blue")+
  #theme(axis.text.x = element_text(angle=60,hjust=1))+
  labs(title="Death Rate between different Healthcare Spending")+
  xlab("Healthcare Spending")+
  ylab("Death Rate")







