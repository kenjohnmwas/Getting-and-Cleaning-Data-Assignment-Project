# Description of data cleaning and manipulation steps

In order to fulfil the requirements of the project assignment, this codebook will elaborate on the data handling which essentially was done using the code contained in the file run_analysis.r. This file (run_analysis.r) has functions that do the following:
1.	Load the required packages/libraries

library(plyr);
library(knitr)

2.	Downloads the data from:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The code that does this is as follows
 
if(!file.exists("./assignmentData")){
  dir.create("./assignmentData")
}
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
3.	Unzips the data into the working directory or working space which is assignmentData

if(!file.exists("./assignmentData/project_Dataset.zip")){
  download.file(Url,destfile="./assignmentData/assignment_Dataset.zip",mode = "wb")
}


if(!file.exists("./assignmentData/UCI HAR Dataset")){
  unzip(zipfile="./assignmentData/assignment_Dataset.zip",exdir="./assignmentData")
}

4.	The data contains subject, activity and features data in form of text files and falls into two categories of test and train data:
5.	Use the following code blocks to read the data into the working space:

featuresTest <- read.table("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset/test/X_test.txt", header = FALSE)
featuresTrain <- read.table("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset/train/X_train.txt", header = FALSE) 

activityTest  <- read.table("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset/test/Y_test.txt" , header = FALSE)
activityTrain <- read.table("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset/train/Y_train.txt", header = FALSE) 

subjectTest  <- read.table("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subjectTrain <- read.table("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset/train/subject_train.txt", header = FALSE)


6.	For subject, activity and features data combine the respective train and test data into one dataset respectively:
activityData <- rbind(activityTrain, activityTest)
subjectData <- rbind(subjectTrain, subjectTest)
featuresData <- rbind(featuresTrain, featuresTest)

7.	set variable names for the datasets (activityData, subjectData, featuresData) 

names(subjectData)<-c("subject")
names(activityData)<- c("activity")
featuresNames <- read.table(file.path("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset", "features.txt"),head=FALSE)
names(featuresData)<- featuresNames$V2

Note: the variable names for subjectData and activityData  (subject and activity) are given by the data user while the variable names for the featuresData were obtained from the features.txt file.

8.	The next step was to merge the datasets (activityData, subjectData, featuresData) column wise using "cbind"  to create  data frame called “InitialData”as follows :

dataCombine <- cbind(subjectData, activityData)
InitialData <- cbind(featuresData, dataCombine)

9.	Then the  “InitialData” data frame was subset by extracting Names of Features with "mean()" or "std()" using the grep 

subsetNames <-featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]
meandevNames <-c(as.character(subsetNames), "subject", "activity" )
InitialData <-subset(InitialData, select = meandevNames)

10.	Use descriptive activity names to name the activities in the data set by reading descriptive activity names from "activity_labels.txt and use them as factors for the “activity” variable in “InitialData” frame as follows: 

activityLabels <- read.table(file.path("C:/Users/John/Desktop/Learning Resources/Coursera/Data science/Data Cleaning/assignment/assignmentData/UCI HAR Dataset", "activity_labels.txt"),header = FALSE)

InitialData$activity<-factor(InitialData$activity, labels=activityLabels[,2])

11.	The next step is to give descriptive names to the variables in the “InitialData”.
A  check of the data at this moment using “names(InitialData)” shows that the variable names are as follows :

 	
[1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"           
 [5] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"            "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
 [9] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"         "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
[13] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"       
[17] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"        "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
[21] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"           "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
[25] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"      
[29] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"       "tBodyAccMag-mean()"          "tBodyAccMag-std()"          
[33] "tGravityAccMag-mean()"       "tGravityAccMag-std()"        "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
[37] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"          "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
[41] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"           "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"           
[45] "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"            "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
[49] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"        "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
[53] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"          "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"          
[57] "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"           "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
[61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
[65] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()"  "subject"                     "activity"

Use the following code to assign descriptive names:

names(InitialData)<-gsub("^t", "time", names(InitialData))
names(InitialData)<-gsub("^f", "frequency", names(InitialData))
names(InitialData)<-gsub("Acc", "Accelerometer", names(InitialData))
names(InitialData)<-gsub("Gyro", "Gyroscope", names(InitialData))
names(InitialData)<-gsub("Mag", "Magnitude", names(InitialData))
names(InitialData)<-gsub("BodyBody", "Body", names(InitialData))

After assigning the descriptive names which are longer and human readable, the variable names are now as follows :

[1] "timeBodyAccelerometer-mean()-X"                 "timeBodyAccelerometer-mean()-Y"                
 [3] "timeBodyAccelerometer-mean()-Z"                 "timeBodyAccelerometer-std()-X"                 
 [5] "timeBodyAccelerometer-std()-Y"                  "timeBodyAccelerometer-std()-Z"                 
 [7] "timeGravityAccelerometer-mean()-X"              "timeGravityAccelerometer-mean()-Y"             
 [9] "timeGravityAccelerometer-mean()-Z"              "timeGravityAccelerometer-std()-X"              
[11] "timeGravityAccelerometer-std()-Y"               "timeGravityAccelerometer-std()-Z"              
[13] "timeBodyAccelerometerJerk-mean()-X"             "timeBodyAccelerometerJerk-mean()-Y"            
[15] "timeBodyAccelerometerJerk-mean()-Z"             "timeBodyAccelerometerJerk-std()-X"             
[17] "timeBodyAccelerometerJerk-std()-Y"              "timeBodyAccelerometerJerk-std()-Z"             
[19] "timeBodyGyroscope-mean()-X"                     "timeBodyGyroscope-mean()-Y"                    
[21] "timeBodyGyroscope-mean()-Z"                     "timeBodyGyroscope-std()-X"                     
[23] "timeBodyGyroscope-std()-Y"                      "timeBodyGyroscope-std()-Z"                     
[25] "timeBodyGyroscopeJerk-mean()-X"                 "timeBodyGyroscopeJerk-mean()-Y"                
[27] "timeBodyGyroscopeJerk-mean()-Z"                 "timeBodyGyroscopeJerk-std()-X"                 
[29] "timeBodyGyroscopeJerk-std()-Y"                  "timeBodyGyroscopeJerk-std()-Z"                 
[31] "timeBodyAccelerometerMagnitude-mean()"          "timeBodyAccelerometerMagnitude-std()"          
[33] "timeGravityAccelerometerMagnitude-mean()"       "timeGravityAccelerometerMagnitude-std()"       
[35] "timeBodyAccelerometerJerkMagnitude-mean()"      "timeBodyAccelerometerJerkMagnitude-std()"      
[37] "timeBodyGyroscopeMagnitude-mean()"              "timeBodyGyroscopeMagnitude-std()"              
[39] "timeBodyGyroscopeJerkMagnitude-mean()"          "timeBodyGyroscopeJerkMagnitude-std()"          
[41] "frequencyBodyAccelerometer-mean()-X"            "frequencyBodyAccelerometer-mean()-Y"           
[43] "frequencyBodyAccelerometer-mean()-Z"            "frequencyBodyAccelerometer-std()-X"            
[45] "frequencyBodyAccelerometer-std()-Y"             "frequencyBodyAccelerometer-std()-Z"            
[47] "frequencyBodyAccelerometerJerk-mean()-X"        "frequencyBodyAccelerometerJerk-mean()-Y"       
[49] "frequencyBodyAccelerometerJerk-mean()-Z"        "frequencyBodyAccelerometerJerk-std()-X"        
[51] "frequencyBodyAccelerometerJerk-std()-Y"         "frequencyBodyAccelerometerJerk-std()-Z"        
[53] "frequencyBodyGyroscope-mean()-X"                "frequencyBodyGyroscope-mean()-Y"               
[55] "frequencyBodyGyroscope-mean()-Z"                "frequencyBodyGyroscope-std()-X"                
[57] "frequencyBodyGyroscope-std()-Y"                 "frequencyBodyGyroscope-std()-Z"                
[59] "frequencyBodyAccelerometerMagnitude-mean()"     "frequencyBodyAccelerometerMagnitude-std()"     
[61] "frequencyBodyAccelerometerJerkMagnitude-mean()" "frequencyBodyAccelerometerJerkMagnitude-std()" 
[63] "frequencyBodyGyroscopeMagnitude-mean()"         "frequencyBodyGyroscopeMagnitude-std()"         
[65] "frequencyBodyGyroscopeJerkMagnitude-mean()"     "frequencyBodyGyroscopeJerkMagnitude-std()"     
[67] "subject"                                        "activity"    


12.	The next step involves creating a second tidy data set named “finalData” with the average
of each variable for each activity and each subject as follows:

finalData <-aggregate(. ~subject + activity, InitialData, mean)
finalData <-finalData[order(finalData$subject,finalData$activity),]

Please note that the average of standard deviation is a thing according to the guideline provided here :
 https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/


13.	Finally, the last step is to save the “finalData” as .txt file as below:

write.table(finalData, file = "DataClean.txt",row.name=FALSE,quote = FALSE, sep = '\t')
