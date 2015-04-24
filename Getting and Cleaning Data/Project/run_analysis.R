## run_analysis.R
## 
## Read and merge the train and test datasets
## extract the measures for mean and sd for each measurement
## calculates the mean of each variable by activity and subject.

library(data.table)
library(dplyr)

## Setting working directory
setwd("~/Documents/git/datasciencecoursera/Getting and Cleaning Data/Project") 

## Load auxiliary function
source("utils.R")
## Download and unzip data
download_data()

## Read features
features = read.table("UCI HAR Dataset/features.txt")
features = clean_names(features) # Clean feature names

## Read train and test files
train = read_data_set("train", features)

## Read test files
test = read_data_set("test", features)

## Merge training and test dataset
data = bind_rows(train, test)

## Extract the measurements of the mean and std
filtered_data = data %>% select(matches("mean|std"))

## Adding activity labels to the dataset 
activity_names = read.table("UCI HAR Dataset/activity_labels.txt")
filtered_data = filtered_data %>% 
  bind_cols(select(data, activity_id, subject)) %>%  
  left_join(activity_names, by = c("activity_id" = "V1")) %>%
  rename(activity = V2)

## Calculate the mean for each column
data_summary = filtered_data %>% group_by(activity, subject) %>% summarise_each(funs(mean(.)), tbodyacc_mean_x:anglezgravitymean)

## Save the data
write.table(data_summary, "tidy_data.txt", row.name=FALSE)

