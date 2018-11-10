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
acti_labels <- read.table('./UCI HAR Dataset/activity_labels.txt')
acti_labels[,2] <- as.character(acti_labels[,2])
acti_labels
feat <- read.table('./UCI HAR Dataset/features.txt')
feat[,2] <- as.character(feat[,2])
message("Performing Step: Get Mean and Std of Measurements")
#Find feat with mean and std in it
req_feat <- grep(pattern = '.*mean.*|.*std.*',feat[,2])
#extract that feature name from line 
req_feat.names <- feat[req_feat,2]
#Replace mean with Mean and same for the std also remove ()
req_feat.names <- gsub('-mean','Mean',req_feat.names)
req_feat.names <- gsub('-std','Std',req_feat.names)
req_feat.names <- gsub('[-()]','',req_feat.names)
train <- read.table('UCI HAR Dataset/train/X_train.txt')[req_feat]
train_activity <- read.table('UCI HAR Dataset/train/Y_train.txt')
train_subjects <- read.table('UCI HAR Dataset/train/subject_train.txt')
train <- cbind(train_subjects,train_activity,train)
test <- read.table('UCI HAR Dataset/test/X_test.txt')[req_feat]
test_activity <- read.table('UCI HAR Dataset/test/Y_test.txt')
test_subjects <- read.table('UCI HAR Dataset/test/subject_test.txt')
test <- cbind(test_subjects,test_activity,test)
#combine both data (test + train)
message("Performing Step : Merging Datasets")
merged_data <- rbind(train,test)
colnames(merged_data) <- c('subject','activity',req_feat.names)
library(reshape2)
message("Performing Step: Rename activities in the dataset")
merged_data$activity <- factor(merged_data$activity,levels = acti_labels[,1],labels = acti_labels[,2])
merged_data$subject <- as.factor(merged_data$subject)
merged_data.melted <- melt(merged_data,id=c('subject','activity'))
merged_data.mean <- dcast(merged_data.melted,subject+activity~ variable,mean)
message("Created the Tidy dataset")
# Write the Tidy Dataset to file
write.table(merged_data.mean,'tidy.txt',row.names =FALSE , quote=FALSE)
message("tidy.txt file created!")
