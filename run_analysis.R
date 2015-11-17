##
## Coursera Getting and Cleaning Data
## by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD
##

##
## Proyect: Jorge Ramírez Arámburo
##

##
## You should create one R script called run_analysis.R that does the following. 
##


##
## ACTIVITY 1: Merges the training and the test sets to create one data set.
##

setwd("/Users/jramirez/Documents/proyectosR/GettingAndCleaningData/project")
if(!file.exists("./data")){
    dir.create("./data")
}

## Download file only if it is not already done
if(!file.exists("./data/projectData.zip")){
    dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(dataUrl,destfile = "projectData.zip",method = "curl")
}

## Unzip file only if it is not already done
if(!file.exists("./data/dataprojectData.csv")){
    unzip(zipfile="./data/projectData.zip",exdir="./data")
}

## get devices data for training and test sets
x.train <- read.table('./data/UCI HAR Dataset/train/X_train.txt')
x.test <- read.table('./data/UCI HAR Dataset/test/X_test.txt')
x <- rbind(x.train, x.test)

## get activity classification variable for train and test sets
y.train <- read.table('./data/UCI HAR Dataset/train/y_train.txt')
y.test <- read.table('./data/UCI HAR Dataset/test/y_test.txt')
y <- rbind(y.train, y.test)

## get subject  variable for train and test sets
subject.train <- read.table('./data/UCI HAR Dataset/train/subject_train.txt')
subject.test <- read.table('./data/UCI HAR Dataset/test/subject_test.txt')
subject <- rbind(subj.train, subj.test)

##
## ACTIVITY 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
##

## read variable names 
features <- read.table('./data/UCI HAR Dataset/features.txt')

## filter variable names that contains  word 'mean' and 'std' mean_sd contains an array with the proper column numbers
mean_sd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
## create a nwe data frame with the desiered colmns
x_mean_sd <- x[, mean_sd]

##
##  ACTIVITY 3: Uses descriptive activity names to name the activities in the data set
##

# get features names
names(x_mean_sd) <- features[mean_sd, 2]
# for convinences convert them to lower cases
names(x_mean_sd) <- tolower(names(x_mean_sd)) 
# throw away parentesis to have more clear colum names
names(x_mean_sd) <- gsub("\\(|\\)", "", names(x_mean_sd))

##
## ACTIVITT 4: # Appropriately labels the data set with descriptive activity names.
##

## get activity values and names
activities <- read.table('./data/UCI HAR Dataset/activity_labels.txt', as.is = TRUE)
## replace values with descriptions
y[, 1] = activities[y[, 1], 2]
## change colum names of y values
colnames(y) <- 'activity'
## chage column names of subjects
colnames(subject) <- 'subject'

## put together all datasets
tidyData <- cbind(subject, x_mean_sd, y)
## save tidyData
write.table(tidyData, './tidyData.txt', row.names = F)

##
## ACTIVITY 5:From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## 
library(dplyr)
averageData <- aggregate(x=tidyData, by=list(activities=tidyData$activity, subject=tidyData$subject), FUN=mean)
averageData <- averageData[, !(colnames(average.df) %in% c("subject", "activity"))]
str(average.df)
write.table(average.df, './averageData.txt', row.names = F)

## Thats it

