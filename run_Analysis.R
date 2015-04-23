## Read data ##
X_train <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
Y_train <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

# Merge train data #
train <- cbind(X_train, Y_train, subject_train)

X_test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
Y_test <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
subject_test = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

# Merge test data #
test <- cbind(X_test, Y_test, subject_test)

## Merge the data sets ##
data <- rbind(train, test)

## Clear unused data frames ##
rm(X_train, Y_train, subject_train, X_test, Y_test, subject_test, train, test)

## Read labels and features, and make naming more R friendly ##
labels <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
features <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] <- gsub("-mean",         "-Mean", ignore.case=FALSE, features[,2])
features[,2] <- gsub("-std",          "-Std",  ignore.case=FALSE, features[,2])
features[,2] <- gsub("[\\(\\),\\-]", "",      ignore.case=FALSE, features[,2])

## Define scopeCols to look only at what we want (mean and std) ##
scopeCols <- grep(".*Mean*|.*Std.*", features[,2])
features <- features[scopeCols,]
scopeCols <- c(scopeCols, 562, 563) # 562: activity, 563: subject, from data

## Remove unneccesary data ##
data <- data[,scopeCols]

## Rename column names ##
colnames(data) <- c(features$V2, "activity", "subject")

## Look-up the appropriate activity name, and do so for all possible labels ##
activity = 1
for (i in labels$V2) {
  data$activity <- gsub(activity, i, data$activity)
  activity <- activity + 1
}

## Create index to aggregate by ##
byIndex <- list(activity = data$activity, subject=data$subject)
## Create tidyData ##
tidyData <- aggregate(data, by=byIndex, mean)
tidyData <- tidyData[order(tidyData[,2], decreasing=FALSE),]
tidyData <- tidyData[,1:88]

## Write tidy data set to file ##
write.table(tidyData, "tidyData.txt", row.names=FALSE)