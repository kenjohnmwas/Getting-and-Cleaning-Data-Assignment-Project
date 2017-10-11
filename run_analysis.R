#Step1

#Load the required libraries/packages

library(plyr);
library(knitr)

#step2

####the function blocks get and unzip the data for the project

if(!file.exists("./assignmentData")){
  dir.create("./assignmentData")
}
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Check and download data in zip form in the assignmentData directory
if(!file.exists("./assignmentData/project_Dataset.zip")){
  download.file(Url,destfile="./assignmentData/assignment_Dataset.zip",mode = "wb")
}

## Unzip the data into UCI HAR Dataset
if(!file.exists("./assignmentData/UCI HAR Dataset")){
  unzip(zipfile="./assignmentData/assignment_Dataset.zip",exdir="./assignmentData")
}

#Step 3

#Read and load "features" data

featuresTest <- read.table("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset/test/X_test.txt", header = FALSE)
featuresTrain <- read.table("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset/train/X_train.txt", header = FALSE)

#Read and load "activity" data

activityTest  <- read.table("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset/test/Y_test.txt" , header = FALSE)
activityTrain <- read.table("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset/train/Y_train.txt", header = FALSE)

#Read and load "subject" data

subjectTest  <- read.table("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subjectTrain <- read.table("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

#Step 4

# For subject, activity and features data combine the respective train and test data into one dataset

activityData <- rbind(activityTrain, activityTest)
subjectData <- rbind(subjectTrain, subjectTest)
featuresData <- rbind(featuresTrain, featuresTest)

#Step 5 

#set variable names for the datasets (activityData, subjectData, featuresData)


names(subjectData)<-c("subject")
names(activityData)<- c("activity")
featuresNames <- read.table(file.path("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset", "features.txt"),head=FALSE)
names(featuresData)<- featuresNames$V2



#Step 6
#merge the datasets column wise using "cbind"

tempData <- cbind(subjectData, activityData)
InitialData <- cbind(featuresData, tempData)


#Step 7

#Subset the "InitialData" data frame by extracting Names of Features with "mean()" or "std()" using the grep 

subsetNames <-featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]
meandevNames <-c(as.character(subsetNames), "subject", "activity" )
InitialData <-subset(InitialData, select = meandevNames)


#Step 8

#Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table(file.path("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset", "activity_labels.txt"),header = FALSE)
InitialData$activity<-factor(InitialData$activity, labels=activityLabels[,2])


#Step 9

names(InitialData)<-gsub("^t", "time", names(InitialData))
names(InitialData)<-gsub("^f", "frequency", names(InitialData))
names(InitialData)<-gsub("Acc", "Accelerometer", names(InitialData))
names(InitialData)<-gsub("Gyro", "Gyroscope", names(InitialData))
names(InitialData)<-gsub("Mag", "Magnitude", names(InitialData))
names(InitialData)<-gsub("BodyBody", "Body", names(InitialData))

#step 10 
#create a second, independent tidy data set with the average of each variable for each activity and each subject


finalData <-aggregate(. ~activity + subject, InitialData, mean)
finalData<-finalData[order(finalData$activity,finalData$subject),]

#step 11
write.table(finalData, file = "DataClean.txt",row.name=FALSE,quote = FALSE, sep = '\t')
