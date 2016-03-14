#plot4.R
# Exploratory Data Analysis
# Assiggnment:Course Project 1

#LIBRARIES
library("data.table")

#DOWNLOAD AND UNZIP FILE
## Check that directory for download exists
if(!file.exists("data")) { dir.create("data") }

## Prepare download
fileProject <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileProject, destfile = "./data/assignment01.zip")

## Use download date as a reference
dateDownloaded <- date()
dateDownloaded

## Check if file was created
list.files("./data")

## Unzip file
unzip("./data/assignment01.zip", exdir = "./data")

## Check if unziped file was created
list.files("./data")

# READ FILE
## Read txt file with "read.table". 
## Notice that some options are required to correctly read the file.
## The columns related to "date" and "time" are read as "character" format
## to simplify their conversion in the next steps.

householdpc <- read.table("./data/household_power_consumption.txt", header = TRUE, sep = ";", colClasses=c("character", "character", rep("numeric",7)), na.strings= "?")

#PREPROCESSING

##Simplify column names
names(householdpc) <- tolower(names(householdpc))
names(householdpc) <- gsub("_", "", names(householdpc))

##Combine columns "Date" and "Time" and modify their format

## Time
householdpc$time <- strptime(paste(householdpc$date, householdpc$time), "%d/%m/%Y %H:%M:%S")

## Date
householdpc$date <- as.Date(householdpc$date, "%d/%m/%Y")

##QC
head(householdpc)
str(householdpc)

##SUBSET DATASET FOR PLOTTING 
householdpc01 <- subset(householdpc, householdpc$date >= "2007-02-01" & householdpc$date <= "2007-02-02")

##QC
head(householdpc01)
str(householdpc01)

##PLOT 4
png("plot4.png", width = 480, height = 480)
par(mfrow=c(2,2))

plot(householdpc01$time, householdpc01$globalactivepower, type = "l", col = "black", xlab = "", ylab = "Global Active Power")
plot(householdpc01$time, householdpc01$voltage, type = "l", col = "black", xlab = "", ylab = "Voltage")
plot(householdpc01$time, householdpc01$submetering1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering")
lines(householdpc01$time, householdpc01$submetering2, type = "l", col = "red")
lines(householdpc01$time, householdpc01$submetering3, type = "l", col = "blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd=2, col=c("black", "red", "blue"), cex=0.6)
plot(householdpc01$time, householdpc01$globalreactivepower, type = "l", col = "black", xlab = "datetime", ylab = "Global_reactive_power")

dev.off()