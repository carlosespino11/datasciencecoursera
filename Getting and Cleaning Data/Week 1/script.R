library(dplyr)
library(xlsx)
library(XML)
library(data.table)

setwd("~/Desktop/datasciencecoursera/Getting and Cleaning Data/Week 1")

data = read.csv("ss06hid.csv")
names(data)

nrow(data %>% filter(VAL == 24))


dat = read.xlsx("DATA.gov_NGAP.xlsx", sheetIndex = 1, colIndex = 7:15, rowIndex = 18:23)

sum(dat$Zip*dat$Ext,na.rm=T) 


xml = xmlTreeParse("restaurants.XML", useInternal = TRUE)
rootNode = xmlRoot(xml)


zips = lapply(xml["//zipcode"], xmlValue)
sum(zips == 21231)


survey = fread("ss06pid.csv")

survey



