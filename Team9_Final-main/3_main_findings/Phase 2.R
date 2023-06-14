# Correlation between GDP per capital and Heart Disease Deaths
library(dplyr)
library(ggplot2)
library(tidyverse)
master<-read.csv('./2_data/master.csv')
colnames(master)[10]="Death_Number"
colnames(master)[11]="Healthcare_Spending"
master %>% dplyr::select(Population,GDP,Death_Number) %>% 
  mutate(GDP_per_capital=GDP/Population) %>% 
  drop_na() %>% 
  ggplot(aes(x=GDP_per_capital,y=Death_Number))+
  geom_point()+geom_smooth(method = lm)+
  xlab("GDP per capital")+ylab("the Number of Death")+
  ylim(0,100000)

master %>% dplyr::select(HDI,Death_Number) %>% 
  drop_na() %>% 
  ggplot(aes(x=HDI,y=Death_Number))+
  geom_point()+geom_smooth(method = lm)+
  xlab("HDI")+ylab("the Number of Death")+
  ylim(0,100000)

master %>% dplyr::select(Healthcare_Spending,Death_Number) %>% 
  drop_na() %>% 
  ggplot(aes(x=Healthcare_Spending,y=Death_Number))+
  geom_point()+geom_smooth(method = lm)+
  xlab("Healthcare Spending")+ylab("the Number of Death")+
  ylim(0,100000)

#Because the number of death is not significantly related to GDP,HDI,Spending, Let's change death number to death rate
master %>% dplyr::select(HDI,Death_Number,Population) %>% 
  mutate(Death_rate=Death_Number/Population) %>% 
  drop_na() %>% 
  ggplot(aes(x=HDI,y=Death_rate))+
  geom_point()+geom_smooth(method = lm)+
  xlab("HDI")+ylab("Death Rate")

master %>% dplyr::select(GDP,Death_Number,Population) %>% 
  mutate(Death_rate=Death_Number/Population) %>% 
  mutate(GDP_per_capital=GDP/Population) %>% 
  drop_na() %>% 
  ggplot(aes(x=GDP_per_capital,y=Death_rate))+
  geom_point()+geom_smooth(method = lm)+
  xlab("GDP per capital")+ylab("Death Rate")

master %>% dplyr::select(Healthcare_Spending,Death_Number,Population) %>% 
  mutate(Death_rate=Death_Number/Population) %>% 
  drop_na() %>% 
  ggplot(aes(x=Healthcare_Spending,y=Death_rate))+
  geom_point()+geom_smooth(method = lm)+
  xlab("Healthcare Spending")+ylab("Death Rate")
