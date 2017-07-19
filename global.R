#global.R
library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(data.table)
data = read.csv("/Users/Sishe/Desktop/NYCDSA-SHINY/Music Copy.csv")
a = data%>%select(danceability, genres)%>%mutate(danceability = round(as.numeric(danceability),4))%>%group_by(genres)%>%summarize(dance.prob = mean(danceability))
dat = data[,c(3:8,10:13,17)]
z = gather(dat, key= genres, value = value)
colnames(z)[2] <- "newname2"
colnames(z)[3] = "values"


### for scatterplot(correlation calculation)
b = data[ ,c(3:13)]
