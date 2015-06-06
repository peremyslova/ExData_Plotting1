#Date: Date in format dd/mm/yyyy
#Time: time in format hh:mm:ss
#Global_active_power: household global minute-averaged active power (in kilowatt)
#Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
#Voltage: minute-averaged voltage (in volt)
#Global_intensity: household global minute-averaged current intensity (in ampere)
#Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
#Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
#Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

#The dataset has 2,075,259 rows and 9 columns. 
#First calculate a rough estimate of how much memory the dataset 
#will require in memory before reading into R. 
#Make sure your computer has enough memory (most modern computers should be fine).
library(dplyr)
library(sqldf)
fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL,destfile='a1.zip', method='curl')
unzip("a1.zip", files = NULL, list = FALSE, overwrite = TRUE,junkpaths = FALSE, exdir = ".", unzip = "internal",setTimes = FALSE)


op.size <- object.size(read.table("household_power_consumption.txt", nrow=1000))
#gsub
#system invokes the OS comman specified by command
#wc -l : Prints the number of lines in a file.
#system("wc -l household_power_consumption.txt", intern=T)
#[1] " 2075260 household_power_consumption.txt"
lines <- as.numeric(gsub("[^0-9]", "", system("wc -l household_power_consumption.txt", intern=T)))
size.estimate <- lines / 1000 * op.size
#315124080.48 bytes
#size.estimate/1000000 gives the size required for reading the data set in megabytes

#We will only be using data from the dates 2007-02-01 and 2007-02-02. 
#One alternative is to read the data from just those dates rather than 
#reading in the entire dataset and subsetting to those dates.
library(sqldf)
sqldata <- read.csv.sql('household_power_consumption.txt', sql = 'select * from file where Date in ("1/2/2007", "2/2/2007")', header = TRUE,sep =";",stringsAsFactors = FALSE)


#You may find it useful to convert the Date and Time variables to Date/Time 
#classes in R using the strptime() and as.Date() functions.
#We will use lubridate package and dmy_hms function that
#transform dates stored as character or numeric vectors to POSIXct objects. 
library(lubridate)
sqldata$datetime <- dmy_hms(paste(sqldata$Date, sqldata$Time))

#???df_D<-alldata[order(as.Date(alldata$Date, format="%d/%m/%Y")),]
#???df_T<-df_D[order(strptime(df_D$Date, format="%d/%m/%Y")),]

#???df <- filter(df_T, DateTime >= as.Date("2006-02-01 00:00:00"), DateTime < as.Date("2006-02-03 00:00:00"))

#Note that in this dataset missing values are coded as ?.
sqldata[is.na(sqldata)] <- "?"

#Drawing plot one for Global_active_power
png(filename="plot1.png")
hist(as.numeric(sqldata$Global_active_power), las=1,main="Global Active Power", xlab="Global Active Power (kilowatts)",col = "red")
dev.off()


