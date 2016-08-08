library(plyr)

# Clean up workspace
rm(list=ls())

# Step 1
# Merge the training and test sets to create one data set
###############################################################################

# combine the 'x' data sets
x_train = read.table("train/X_train.txt")
x_test = read.table("test/x_test.txt")
x_combined = rbind(x_train, x_test)

# combine the 'y' data sets
y_train = read.table("train/y_train.txt")
y_test = read.table("test/y_test.txt")
y_combined = rbind(y_train, y_test)

# combine 'subject' data sets
subject_train = read.table("train/subject_train.txt")
subject_test = read.table("test/subject_test.txt")
subject_combined = rbind(subject_train, subject_test)

# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################

features = read.table("features.txt")

# get only columns with mean() or std() in their names
# "-" is a literal, not a metacharacter
# since "(" and ")" are metacharacters, we need to escape them
set_of_mean_std_features = grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_combined = x_combined[, set_of_mean_std_features]

# correct the column names
names(x_combined) = features[set_of_mean_std_features, 2]

# Step 3
# Use descriptive activity names to name the activities in the data set
###############################################################################

activities = read.table("activity_labels.txt")

# correct column name
names(y_combined) = "activity"

# update values with correct activity names
y_combined$activity = activities[match(y_combined$activity, activities[,1]), 2]

# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subject_combined) = "subject"

# bind all the data in a single data set
all_combined = cbind(x_combined, y_combined, subject_combined)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# average all numeric columns except for the two columns matching "activity" & "subject"
averages_combined <- ddply(all_combined, .(subject, activity), function(x) colMeans(all_combined[, !(names(all_combined) %in% c("subject", "activity"))]))
# another way
# tidydata<-summarise_each(group_by(all_combined,activity,subject),funs(mean))

write.table(averages_combined, "averages_combined.txt", row.name=FALSE)