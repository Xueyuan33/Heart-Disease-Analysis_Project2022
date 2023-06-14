library(ggplot2)
library(dplyr)
library(plotly)
library(hrbrthemes)
library(latticeExtra)
library(stats)
library(tidyverse)
library(janitor)
library(patchwork)
library(factoextra)
library(readr)
library(tidyr)



# Time Series for Heart Disease Death Rate

data1 <-read.csv("time_series_belarus.csv")%>%
  select(metric_name ,year ,val)%>%
  filter(metric_name=="Number")
data2<-read.csv("time_series_south_sudan.csv")%>%
  select(metric_name ,year ,val)%>%
  filter(metric_name=="Number")
data3<-read.csv("time_series_uganda.csv")%>%
  select(metric_name ,year ,val)%>%
  filter(metric_name=="Number")
data4<-read.csv("time_series_ukraine.csv")%>%
  select(metric_name ,year ,val)%>%
  filter(metric_name=="Number")
pop_data<-read.csv("population_four.csv")

chars <- sapply(pop_data, is.character)

#convert all character columns to numeric
#pop_data <- pop_data %>% mutate_at(c('population1', 'population2','population3','population4'), as.double(gsub(",", "", y)))

pop_data$population1<-as.double(gsub(",", "", pop_data$population1))
pop_data$population2<-as.double(gsub(",", "", pop_data$population2))
pop_data$population3<-as.double(gsub(",", "", pop_data$population3))
pop_data$population4<-as.double(gsub(",", "", pop_data$population4))
str(pop_data)


data<-data1%>%
  #filter(metric_name.x=="Number"& metric_name.x.x=="Number" & metric_name.y.y=="Number" & metric_name.y =="Number")%>%
  left_join(data2,by="year")%>%
  left_join(data3,by="year")%>%
  left_join(data4,by="year")%>%
  left_join(pop_data,by="year")%>%
  mutate(Belarus=val.x/population1,
         South_Sudan=val.y/population2,
         Uganda=val.x.x/population3,
         Ukraine=val.y.y/population4
         )%>%
  select(year, Belarus,South_Sudan,Uganda,Ukraine)%>%
  pivot_longer(cols=c("Belarus","South_Sudan","Uganda","Ukraine"), names_to="Country",values_to="Death_Rate")

data
write.csv(data, "2_data/phase3_data.csv", row.names = FALSE)

ggplot(data,                           
       aes(x = year,
           y = Death_Rate,
           col = Country)) +
  geom_line()+
  geom_point() +
  labs(title="Heart Disease Death Rate through Time", x="Year", y="Death Rate", subtitle="From 1990 to 2019") +
  theme_minimal()



# Time Series for GDP

gdp_data<- read.csv("four_gdp.csv")
head(gdp_data)

gdp_data$GDP<-parse_number(gdp_data$GDP)

gdp_data
  
ggplot(gdp_data,                           
       aes(x = year,
           y = GDP,
           col = Country)) +
  geom_line()+
  geom_point() +
  labs(title="GDP", x="Year", y="GDP (100 million USD") +
  theme_minimal()


