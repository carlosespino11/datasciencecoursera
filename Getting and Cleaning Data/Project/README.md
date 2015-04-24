# README.md

This repository contains two R scripts ```run_analsys.R``` and ```utils.R``` that are in the following way:

1. ```utils.R``` contains the auxiliary functions:
  - ```download_data()``` downloads the data and unzips it.
  - ```clean_names(features)``` cleans the names of the features so they can be used as headers in a ```data.frame```
  - ```read_data_set(type, features)``` reads and cleans the data (train or test) by adding the headers given by ```features``` and binding the necessary columns.

2. ```run_analsys.R``` uses the auxiliary functions in ```utils.R``` and the necessary code to:
  - Read, clean and merge the train and test datasets. 
  - Select only the measures of the mean and standard deviation of the features.
  - Calculate the mean by activity and subject.
  
