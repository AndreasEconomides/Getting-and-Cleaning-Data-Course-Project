## assumed that the working directory contains a folder called ##"data", in which 
the "UCI HAR Dataset" folder is found, with ##the data files in it

path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

##list the files

TestActivity  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
TrainActivity <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

##read the activity files and assign to variables

TrainSubject <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
TestSubject  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

##read the subject files and assign to variables

TestFeatures  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
TrainFeatures <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

##read the features files and assign to variables

Subject <- rbind(TrainSubject, TestSubject)
Activity<- rbind(TrainActivity, TestActivity)
Features<- rbind(TrainFeatures, TestFeatures)

##merge datasets by rows

names(Subject)<-c("subject")
names(Activity)<- c("activity")
FeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(Features)<- FeaturesNames$V2

##assign names to variables

Combine <- cbind(Subject, Activity)
Data <- cbind(Features, Combine)

subFeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]

selectedNames<-c(as.character(subFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

##subest data frame by chosen Features names

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

##read descriptive names from the "activity_labels.txt" file

Data$activity <-gsub("1", "WALKING", Data$activity)
Data$activity <-gsub("2", "WALKING_UPSTAIRS", Data$activity)
Data$activity <-gsub("3", "WALKING_DOWNSTAIRS", Data$activity)
Data$activity <-gsub("4", "SITTING", Data$activity)
Data$activity <-gsub("5", "STANDING", Data$activity)
Data$activity <-gsub("6", "LAYING", Data$activity)

##assign new descriptive names to the activities

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

##assign new descriptive names to the variables

##install.packages("plyr")

library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "cleandata.txt",row.name=FALSE)

##create the clean dataset