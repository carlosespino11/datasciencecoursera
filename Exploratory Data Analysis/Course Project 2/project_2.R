library(dplyr)
library(ggplot2)
library(gridExtra)
library(scales)

## Setting working directory
setwd("~/Documents/git/datasciencecoursera/Exploratory Data Analysis//Course Project 2") 

## Download and unzip data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip", method="curl" )
unzip("data.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

data = left_join(NEI, SCC, by = c("SCC" = 'SCC'))

## Total emissions PM2.5 per year
plot1_data = data %>% group_by(year) %>% summarise(total_emissions = sum(Emissions))

png(filename="plot1.png", width = 600, height = 600)
plot(plot1_data, type = "b", xaxt="n", ylab = "total emissions", main = "Total emissions by year")
axis(1, at=c(plot1_data$year))
dev.off()

plot2_data = data %>% filter(fips == "24510") %>% group_by(year) %>% 
  summarise(total_emissions = sum(Emissions)) %>%

png(filename="plot2.png", width = 600, height = 600)
with(plot2_data, plot(y = total_emissions, x = year, type = "b", xaxt="n", ylab = "Total Emissions", main = "Baltimore total emissions by year"))
axis(1, at=c(plot2_data$year))
dev.off()

plot3_data = data %>% filter(fips == "24510") %>% group_by(year, type) %>% 
  summarise(total_emissions = sum(Emissions))%>% 
  group_by(type) %>%
  mutate(percent_change =total_emissions/first(total_emissions) -1, total_change = total_emissions - first(total_emissions) )

p3_2 = ggplot(filter(plot3_data, year == 2008)) + 
  aes(x = type, y = total_change) +  
  geom_bar(stat="identity", aes(fill = type)) +
  scale_y_continuous("total emissions change") +
  ggtitle("Total emissions change In Baltimore 1999 - 2008") +
  theme(legend.position = "none")

p3_1 =ggplot(plot3_data) + 
  aes(x = year, y = percent_change) +  
  geom_line(aes(color = type)) +
  scale_x_continuous(breaks= plot3_data$year)+
  scale_y_continuous("emissions % change", labels = percent, breaks = seq(-1,3,.5)) +
  ggtitle("Emissions % change in Baltimore by type") +
  theme(legend.position = "top")

png(filename="plot3.png",width = 600, height = 600)
grid.arrange(p3_1, p3_2, nrow=2)
dev.off()

plot4_data = data %>% filter(grepl("[Cc]oal", EI.Sector )) %>% group_by(year) %>% summarise(total_emissions = sum(Emissions))

png(filename="plot4.png", width = 600, height = 600)
ggplot(plot4_data) + 
  aes(x = year, y = total_emissions) + 
  geom_line(color = "red") + geom_point(color = "red")+
  scale_x_continuous(breaks= plot4_data$year) + scale_y_continuous("total emissions") + 
  ggtitle("Total emissions by year from coal combustion-related sources")
dev.off()

plot5_data = data %>% filter(grepl("[Vv]ehicles", EI.Sector ), fips == "24510") %>% group_by(year) %>% summarise(total_emissions = sum(Emissions))

png(filename="plot5.png", width = 600, height = 600)
ggplot(plot5_data) + 
  aes(x = year, y = total_emissions) + 
  geom_line(color = "steelblue") + geom_point(color = "steelblue")+
  scale_x_continuous(breaks= plot4_data$year) +
  ylab("total emissions") + ggtitle("Motor vehicles emissions by year in Baltimore")
dev.off()

plot6_data = data %>% filter(fips %in% c("06037","24510"), grepl("[Vv]ehicles", EI.Sector )) %>%
  group_by(year, fips) %>% summarise(total_emissions = sum(Emissions)) %>% group_by(fips) %>%
  mutate(percent_change =total_emissions/first(total_emissions) -1, total_change = total_emissions - first(total_emissions))

plot6_data$fips = factor(plot6_data$fips, labels = c("Los Angeles", "Baltimore") )
p6_1 = ggplot(filter(plot6_data, year == 2008)) + 
  aes(x = fips, y = total_change) +  
  geom_bar(aes(fill = fips), stat = "identity") +
  scale_y_continuous("total emissions change") +
  xlab("city") +
  ggtitle("Motor vehicles emissions total change 1999 - 2008 by city") + 
  theme(legend.position="none")

p6_2 = ggplot(plot6_data) + 
  aes(x = year, y = percent_change) +  
  geom_line(aes(color = fips)) +
  scale_x_continuous(breaks= seq(1999, 2008, 3)) +
  scale_y_continuous("emissions percent change", labels = percent) + 
  ggtitle("Motor vehicle emissions % change by city") + 
  theme(legend.position="top")

png(filename="plot6.png", width = 600, height = 600)
grid.arrange(p6_2, p6_1, nrow=2)
dev.off()


