library(tidyr)
library(datasets)
library(dplyr)


if(!file.exists(("C:\\Users\\Thato-JD\\Desktop\\Quize\\Getting-and-Cleaning-data")))
   {
     dir.create("C:\\Users\\Thato-JD\\Desktop\\Quize\\Getting-and-Cleaning-data")
}

#storing the link in a variable
dataUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#download the data
download.file(dataUrl,destfile = "C:\\Users\\Thato-JD\\Desktop\\Quize\\Getting-and-Cleaning-data\\dataset.zip")
unzip(zipfile = "C:\\Users\\Thato-JD\\Desktop\\Quize\\Getting-and-Cleaning-data\\dataset.zip",exdir = "C:\\Users\\Thato-JD\\Desktop\\Quize\\Getting-and-Cleaning-data")

path_file=file.path("C:\\Users\\Thato-JD\\Desktop\\Quize\\Getting-and-Cleaning-data","UCI HAR Dataset")

files=list.files(path_file,recursive = TRUE)
files

dataActivityTrain = read.table(file.path(path_file,"test","Y_test.txt"),header = FALSE)
dataActivityTest = read.table(file.path(path_file,"train", "Y_train.txt"),header = FALSE)
#getting the subject data
dataSubjecTrain = read.table(file.path(path_file,"train","subject_train.txt"),header = FALSE)
dataSubjecTest = read.table(file.path(path_file,"test","subject_test.txt"),header = FALSE)
#getting data for feature
dataFeatureTrain = read.table(file.path(path_file,"train","X_train.txt"),header = FALSE)
dataFeatureTest = read.table(file.path(path_file,"test","X_test.txt"),header = FALSE)

str(dataActivityTest)
str(dataActivityTrain)
str(dataSubjecTest)
str(dataSubjecTrain)
str(dataFeatureTest)
str(dataFeatureTrain)

#merging the test and train

dataSubject  = rbind(dataSubjecTrain,dataSubjecTest)
dataActivity = rbind(dataActivityTrain,dataActivityTest)
dataFeature  = rbind(dataFeatureTrain,dataFeatureTest)

#setting names to variable
names(dataSubject) = c("subjec")
names(dataActivity) = c("Activity")
dataFeaturenames = read.table(file.path(path_file,"features.txt"),header = FALSE)
names(dataFeature) = dataFeaturenames$V2
#merging columns to get the data frame for all the data
dataCombine = cbind(dataSubject,dataActivity)
data = cbind(dataFeature,dataCombine)
data
View(dataCombine)

#Extracts only measurements on the mean and standard deviation for each measurement
#subset name of features by measurement on the mean and std
subdataFeaturesname = dataFeaturenames$V2[grep("mean\\(\\)|std\\(\\)",dataFeaturenames$V2)]
#subsetting the data frame by selected names of features
selectedname=c(as.character(subdataFeaturesname),"subject","activity")
data = subset(data,select = selectedname)
str(data)
#Uses descriptive activity names to name the activities in the data set
activityLabels = read.table(file.path(path_file,"activity_labels.txt"),header = FALSE)
head(data$Activity,30)
#Appropriately labels the data set with descriptive variable names
names(data) = gsub("^t","time",names(data))
names(data) = gsub("^f","frequency",names(data))
names(data) = gsub("Acc","Accelerometer",names(data))
names(data) = gsub("Gyro","Gyroscope",names(data))
names(data) = gsub("Mag","Magnitude",names(data))
names(data) = gsub("BodyBody","Body",names(data))

names(data)
##Creating a second,independent tidy data set.
library(plyr)
data2 = aggregate(. ~subjec + Activity,data,mean)
data2 = data2[order(data2$subjec,data2$Activity),]
write.table(data2,file = "tidydata.txt",row.names = FALSE)
#producing codebook
library(knitr)
knit2html("codebook.Rmd");
str(data2)
data2
