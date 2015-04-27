library(dplyr)
setwd("~/Desktop/datasciencecoursera/Exploratory Data Analysis/Course Project 1")

data = fread("household_power_consumption.txt", sep = ";", header = T, na.strings = "?")

data$datetime = strptime(paste(data$Date,data$Time, sep="-") , format = "%d/%m/%Y-%H:%M:%S")

filtered = filter(data, Date %in% c(as.Date("2007-02-01"), as.Date("2007-02-02")) )

png("plot1.png",width = 480, height = 480 )
with(filtered, hist(as.numeric(Global_active_power), main="Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red"))
dev.off()

with(filtered, plot(y = as.numeric(Global_active_power), x = Date, main=NA, ylab = "Global Active Power (kilowatts)", type = "line"))
