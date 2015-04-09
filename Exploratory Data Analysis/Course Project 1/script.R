library(dplyr)
library(data.table)

setwd("~/Desktop/datasciencecoursera/Exploratory Data Analysis/Course Project 1")

data = fread("household_power_consumption.txt", sep = ";", header = T, na.strings = "?")

# filtered = filter(data, Date %in% c("01/02/2007", "02/02/2007") )
filtered = filter(data, as.Date(Date , "%d/%m/%Y") %in% c(as.Date("2007-02-01"), as.Date("2007-02-02")) )

filtered$DateTime = with(filtered, as.POSIXct(paste(Date, Time, sep="-" ), format = "%d/%m/%Y-%T"))



png("plot1.png", width=480, height = 480)
with(filtered, hist(as.numeric(Global_active_power), col="red", main = "Global active power", xlab = "Global active power (kilowatts)"))
dev.off()

png("plot2.png", width=480, height = 480)
with(filtered, plot(y = as.numeric(Global_active_power), x= DateTime, type="line", ylab = "Global active power (kilowatts)", xlab= NA))
dev.off()

png("plot3.png", width=480, height = 480)
with(filtered, plot(y = Sub_metering_1, x= DateTime, type="line", ylab = "Global active power (kilowatts)", xlab= NA))
with(filtered, lines(y = Sub_metering_2, x= DateTime, col="red"))
with(filtered, lines(y = Sub_metering_3, x= DateTime, col="blue"))
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), fill=c("black", "red", "blue"))
dev.off()
