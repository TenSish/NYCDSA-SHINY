#global.R
library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)

setwd = ("/Users/Sishe/Desktop/NYCDSA-SHINY/")
data = read.csv("./Music copy.csv")


### server coord cord
dat = data[,c(3:8,10,17)]
z = gather(dat, key= genres, value = value)
colnames(z)[2] <- "newname2"
colnames(z)[3] = "values"

