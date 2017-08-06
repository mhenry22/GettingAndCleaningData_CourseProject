#0. Run the useful libraries that could be necessary throughout the project:

library(dplyr)    #to have access to select(), rename(), arrange(), summarize() and group_by() functions
library(tidyr)    #to have access to gather(), separate(), bind_rows and bind_cols() functions

#1. Merge the training and the test sets to create one data set:

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
folder <- paste0(getwd(), "/", "Dataset.zip")
download.file(url, folder)
#Get an idea of what contains the given unzipped folder by displaying a table of its content:
dataset_folder <- unzip(folder, list = TRUE)
View(dataset_folder)
#Extract content (by default in the working directory) of the Dataset.zip folder previously created:
unzip(folder)
#The resulting folder is "UCI HAR Dataset".

#Create R objects (data tables) representing the different relevant available datasets:
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

X_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", header = FALSE)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)

X_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", header = FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)

#Convert all objects to data tables in order to use the dplyr and tidyr packages:
features <- tbl_df(features)
activity_labels <- tbl_df(activity_labels)
X_train <- tbl_df(X_train)
Y_train <- tbl_df(Y_train)
subject_train <- tbl_df(subject_train)
X_test <- tbl_df(X_test)
Y_test <- tbl_df(Y_test)
subject_test <- tbl_df(subject_test)

View(features)

#Do a first labeling of the variables in order to keep only the ones we are interested in:
#Rename X_train and X_test variables accordingly to features file:
names(X_train) <- features$V2
names(X_test) <- features$V2
#Rename Y_train and Y_test unique variable as "label", according to given README file:
names(Y_train) <- "label"
names(Y_test) <- "label"
#Rename subject_train and subject_test unique variable as "label", according to given README file:
names(subject_train) <- "subject"
names(subject_test) <- "subject"

#Combine subject, Y and X files (in that order) by columns respectively for train and test data;
#Store the result in 2 new variables called data_train and data_test:
data_train <- bind_cols(subject_train, Y_train, X_train)
dim(data_train)   #sanity check on dimensions
View(data_train)  #sanity check on full table
data_test <- bind_cols(subject_test, Y_test, X_test)
dim(data_test)    #sanity check on dimensions
View(data_test)   #sanity check on full table

#Combine tables data_train and data_set by rows: 
data_all <- bind_rows(data_train, data_test)
dim(data_all)   #sanity check on dimensions
View(data_all)  #sanity check on full table

#2. Extract only the measurements on the mean and standard deviation for each measurement:

#According to the features_info. txt file, in the set of variables that were estimated from the signals, 
#mean is denoted by "mean()" and standard deviation by "std()", so we create our new dataset data_mean_std as:
data_mean_std <- select(data_all, subject, label, contains("mean()"), contains("std()"))
dim(data_mean_std)    #sanity check on dimensions
View(data_mean_std)   #sanity check on full table

#3. Use descriptive activity names to name the activities in the data set:

names(activity_labels) <- c("label", "activity")
data_mean_std <- inner_join(x = data_mean_std, y = activity_labels, by = c("label" = "label"))
#This last step allows us to have the descriptive activity names without the underscore ("_") which in ths case is useless:
data_mean_std$activity <- gsub("_", " ", data_mean_std$activity)

dim(data_mean_std)    #sanity check on dimensions
View(data_mean_std)   #sanity check on full table

#4. Appropriately label the data set with descriptive variable names:

#PLEASE FORGET THE FOLLOWING SINCE I REALIZED AT THE END THAT IT WAS NOT RELEVANT FOR THE ASSIGNMENT REQUIREMENTS.
#MY ANSWER TO THIS QUESTION IS A LITTLE BELOW.
#data_mean_std <- separate(data_mean_std, "signal-measure-direction", c("signal", "measure", "direction"), sep = "-")
#NB.Sometimes direction is missing but it doesn't creat any major probleme, the value in direction variable will just be NA, which is right.
#We now have a tidy dataset with descriptive variable names.

#We can also improve the measure variable:
#data_mean_std$measure <- sub("mean\\(\\)", "Mean", data_mean_std$measure)
#data_mean_std$measure <- sub("std\\(\\)", "Standard deviation", data_mean_std$measure)

#Since we have already extracted and matched the names from the different given files,
#the objective now will be to put one variable by column by setting the features as a variables;
#don't know if it is mandatory for this assignment but I chose here to also create one variable named measurement containing the features:
data_mean_std <- gather(data = data_mean_std, key = "measurement", value = "value", -c(subject, label, activity))
#Give more explicit names for the measurements according to the features_info.txt file:
data_mean_std$measurement <- gsub("Acc", "Acceleration", data_mean_std$measurement)
data_mean_std$measurement <- gsub("GyroJerk", "AngularAcceleration", data_mean_std$measurement)
data_mean_std$measurement <- gsub("Gyro", "AngularSpeed", data_mean_std$measurement)
data_mean_std$measurement <- gsub("Mag", "Magnitude", data_mean_std$measurement)
data_mean_std$measurement <- gsub("^t", "TimeDomain.", data_mean_std$measurement)
data_mean_std$measurement <- gsub("^f", "FrequencyDomain.", data_mean_std$measurement)
data_mean_std$measurement <- gsub("\\.mean", ".Mean", data_mean_std$measurement)
data_mean_std$measurement <- gsub("\\.std", ".StandardDeviation", data_mean_std$measurement)
data_mean_std$measurement <- gsub("Freq\\.", "Frequency.", data_mean_std$measurement)
data_mean_std$measurement <- gsub("Freq$", "Frequency", data_mean_std$measurement)

dim(data_mean_std)    #sanity check on dimensions
View(data_mean_std)   #sanity check on full table

#5. Create a second, independent tidy data set with the average of each variable for each activity and each subject:

#Begin by creating a grouped dataset:
grouped_dataset <- group_by(data_mean_std, subject, label, activity, measurement)
dim(grouped_dataset)    #sanity check on dimensions
View(grouped_dataset)   #sanity check on full table
#Then calculate the average for each subject, label, activity with the summarize fonction from dplyr package:
tidy_dataset <- summarize(grouped_dataset, average = mean(value))
#Make sure it is relevantly ordered and delete the useless label variable:
tidy_dataset <- arrange(tidy_dataset, subject, label, activity, measurement)
tidy_dataset <- select(tidy_dataset, subject, activity, measurement, average)
dim(tidy_dataset)    #sanity check on dimensions
View(tidy_dataset)   #sanity check on full table
#Finally export this dataset to a text file:
write.table(tidy_dataset, file = "tidy_dataset.txt", row.name = FALSE)

#Generate the codebook:
library(memisc)   
#NB.Needs to be put here instead of at the begining, otherwise unable select() function from dplyr
codebook(tidy_dataset)

