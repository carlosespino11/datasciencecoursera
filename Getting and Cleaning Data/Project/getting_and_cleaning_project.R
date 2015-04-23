library(data.table)
library(dplyr)

## Setting working directory
setwd("~/Desktop/datasciencecoursera/Getting and Cleaning Data/Project")

## Download and unzip data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data.zip", method="curl" )
unzip("data.zip")


## Read features
features = read.table("UCI HAR Dataset/features.txt")
features$V2 = tolower(sapply(features$V2, function(x){gsub("-", "_", gsub("\\(|\\)|,", "", as.character(x)))})) # Clean varaible names removing "(", ")", "," )
## Read Train files
trainX = as.data.table(read.table("UCI HAR Dataset/train/X_train.txt"))
setnames(trainX, names(trainX), as.character(features$V2))
trainY = as.data.table(read.table("UCI HAR Dataset/train/Y_train.txt"))
setnames(trainY, names(trainY), "activity-id")
trainSubject = as.data.table(read.table("UCI HAR Dataset/train/subject_train.txt"))
setnames(trainSubject, names(trainSubject), "subject")

# trainSignals = bind_cols(
#  lapply(list.files("UCI HAR Dataset/train/Inertial Signals"), function(file){ 
#    dt = as.data.table(read.table(paste("UCI HAR Dataset/train/Inertial Signals/", file, sep="")))
#    setnames(dt, names(dt), gsub("_train.txt", "", file))
#    
#  }))

train = bind_cols(trainX, trainY, trainSubject)

## Read test files
testX = as.data.table(read.table("UCI HAR Dataset/test/X_test.txt"))
setnames(testX, names(testX), as.character(features$V2))
testY = as.data.table(read.table("UCI HAR Dataset/test/Y_test.txt"))
setnames(testY, names(testY), "activity-id")
testSubject = as.data.table(read.table("UCI HAR Dataset/test/subject_test.txt"))
setnames(testSubject, names(testSubject), "subject")

test = bind_cols(testX, testY, testSubject)

## Merge training and test dataset
data = bind_rows(train, test)

## Extract the measurement of the mean and std
wanted_cols = grepl("mean", names(data)) | grepl("std", names(data))
reduced_data = data %>% select(matches("mean|std"))
n