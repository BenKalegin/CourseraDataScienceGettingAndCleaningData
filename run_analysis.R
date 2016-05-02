# prepare folder for data
if(!file.exists("./data")) {
    dir.create("./data")
}

# download and unzip

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "./data/dataset.zip"

if (!file.exists(zipFile)) {
    download.file(url, zipFile)
    unzip(zipFile, exdir = "./data")
}

# read common dictionaries

# feature list is 561 length table of features, first column is index, name in second column 
featureList = read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE, col.names = c("id", "name"), header = FALSE)

# activity labels is 6 rows table of features, , first column is index, name in second column 
activityLabels = read.table("./data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE, col.names = c("activityId", "activityName"), header = FALSE)

## read training data 
folder <- "./data/UCI HAR Dataset/train/";

#y_train is label list, with one column, no header, 7352 rows. 
yTrain <- read.table(paste(folder, "y_train.txt", sep = ""), header = FALSE, colClasses = c("integer"), col.names = c("activityId")); 

#x_train is feature matrix. 7352 rows, 561 columns separated by space. 
xTrain <- read.table(paste(folder, "x_train.txt", sep = ""), header = FALSE, col.names = featureList$name);

#subject_train is number vector, no header, 7352 rows. 
subjectTrain <- read.table(paste(folder, "subject_train.txt", sep = ""), header = FALSE, , colClasses = c("integer"), col.names = c("subjectId"));

# read test data
folder <- "./data/UCI HAR Dataset/test/";

#y_test is label list, with one column, no header, 2947 rows. 
yTest <- read.table(paste(folder, "y_test.txt", sep = ""), header = FALSE, colClasses = c("integer"), col.names = c("activityId")); 

#x_test is feature matrix. 2947 rows, 561 columns separated by space. 
xTest <- read.table(paste(folder, "x_test.txt", sep = ""), header = FALSE, col.names = featureList$name);

#subject_test is number vector, no header, 2947 rows. 
subjectTest <- read.table(paste(folder, "subject_test.txt", sep = ""), header = FALSE, , colClasses = c("integer"), col.names = c("subjectId"));


# Task 1: Merges the training and the test sets to create one data set.
yTotal <- rbind(yTrain, yTest)
xTotal <- rbind(xTrain, xTest)
subjectTotal <- rbind(subjectTrain, subjectTest)

rm(list = grep( "(Train|Test)$", ls(), value = TRUE))

# Task 2: Extracts only the measurements on the mean and standard deviation for each measurement.
keepColumns <- grepl("-mean\\()|-std\\()", featureList$name)
xTotal = xTotal[,keepColumns]

rm("keepColumns")

# Task 3: Uses descriptive activity names to name the activities in the data set
activityNames <- merge(yTotal, activityLabels, by="activityId")
xTotal$ActivityName = sub("_", "", tolower(activityNames$activityName))
rm("activityNames")

#4 Appropriately labels the data set with descriptive variable names.

names(xTotal) <- gsub(x = names(xTotal), pattern = "^t", replacement = "Time")
names(xTotal) <- gsub(x = names(xTotal), pattern = "^f", replacement = "Frequency")
names(xTotal) <- gsub(x = names(xTotal), pattern = "Acc", replacement = "Acceleration")
names(xTotal) <- gsub(x = names(xTotal), pattern = "Gyro", replacement = "Gyroscope")
names(xTotal) <- gsub(x = names(xTotal), pattern = "Magnitude", replacement = "Magnitude")
names(xTotal) <- gsub(x = names(xTotal), pattern = "\\.std\\.\\.", replacement = "StandardDeviation")
names(xTotal) <- gsub(x = names(xTotal), pattern = "\\.mean\\.\\.", replacement = "Mean")
names(xTotal) <- gsub(x = names(xTotal), pattern = "\\.", replacement = "")


#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
xTotal$Subject = subjectTotal$subjectId

library(dplyr)

tidyData <- xTotal %>% group_by(ActivityName, Subject) %>% summarise_each(funs(mean))

write.csv(tidyData, "./data/tidy.csv")
