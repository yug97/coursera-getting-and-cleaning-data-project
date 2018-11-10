# Download Dataset if not previously downloaded
if(!file.exists('./dataset.zip')) 
{
  fileurl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(fileurl,'./dataset.zip')
}
#unzip dataset
if(!file.exists('./UCI HAR Dataset'))
{
  unzip('./dataset.zip')
}
# Read file and coverting their 2nd column to charecter from factor
activitylabels <- read.table('./UCI HAR Dataset/activity_labels.txt')
activitylabels[,2] <- as.character(activitylabels[,2])
activitylabels
features <- read.table('./UCI HAR Dataset/features.txt')
features[,2] <- as.character(features[,2])
message("Performing Step: Get Mean and Std of Measurements")
#Find features with mean and std in it
featureswanted <- grep(pattern = '.*mean.*|.*std.*',features[,2])
#extract that feature name from line 
featureswanted.names <- features[featureswanted,2]
#Replace mean with Mean and same for the std also remove ()
featureswanted.names <- gsub('-mean','Mean',featureswanted.names)
featureswanted.names <- gsub('-std','Std',featureswanted.names)
featureswanted.names <- gsub('[-()]','',featureswanted.names)
train <- read.table('UCI HAR Dataset/train/X_train.txt')[featureswanted]
train_activity <- read.table('UCI HAR Dataset/train/Y_train.txt')
train_subjects <- read.table('UCI HAR Dataset/train/subject_train.txt')
train <- cbind(train_subjects,train_activity,train)
test <- read.table('UCI HAR Dataset/test/X_test.txt')[featureswanted]
test_activity <- read.table('UCI HAR Dataset/test/Y_test.txt')
test_subjects <- read.table('UCI HAR Dataset/test/subject_test.txt')
test <- cbind(test_subjects,test_activity,test)
#combine both data (test + train)
message("Performing Step : Merging Datasets")
alldata <- rbind(train,test)
colnames(alldata) <- c('subject','activity',featureswanted.names)
library(reshape2)
message("Performing Step: Rename activities in the dataset")
alldata$activity <- factor(alldata$activity,levels = activitylabels[,1],labels = activitylabels[,2])
alldata$subject <- as.factor(alldata$subject)
alldata.melted <- melt(alldata,id=c('subject','activity'))
alldata.mean <- dcast(alldata.melted,subject+activity~ variable,mean)
message("Created the Tidy dataset")
# Write the Tidy Dataset to file
write.table(alldata.mean,'tidy.txt',row.names =FALSE , quote=FALSE)
message("tidy.txt file created!")
