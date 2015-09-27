
#Read all the column names from features.txt
features<-read.table("features.txt",sep="")

#Read the training data
X_train<-read.table("train/X_train.txt",sep="")
Y_train<-read.table("train/Y_train.txt",sep="")
subject_train<-read.table("train/subject_train.txt",sep="")

#add column names to train data
names(X_train)<-features$V2
names(Y_train)<-c("Activity")
names(subject_train)<-c("Subject")

#combine train data
train_data<-cbind(subject_train,Y_train,X_train)

#Read the test data
X_test<-read.table("test/X_test.txt",sep="")
Y_test<-read.table("test/Y_test.txt",sep="")
subject_test<-read.table("test/subject_test.txt",sep="")

#add column names to test data
names(X_test)<-features$V2
names(Y_test)<-c("Activity")
names(subject_test)<-c("Subject")

#combine test data
test_data<-cbind(subject_test,Y_test,X_test)

#combine the rows of test data and training data
combineddata<-rbind(train_data,test_data)

#Extract only the measurements on the mean and standard deviation for each measurement. 
#Create a logical vector to determine the column names having the mean() or std() 
meanstdcols<-grepl("mean\\(\\)", names(combineddata))|grepl("std\\(\\)", names(combineddata))

#retain the subject and activity data in 1st 2 columns
meanstdcols[1:2]<-TRUE

#remove all the extra columns
combineddata<-combineddata[,meanstdcols]

#Uses descriptive activity names to name the activities in the data set

#Read activity lables from activity_labels.txt
activity_lables<-read.table("activity_labels.txt",sep="")
names(activity_lables)<-c("activityId","activityname")
combineddata$Activity<-factor(combineddata$Activity,labels = activity_lables$activityname)


## Creates a second, independent tidy data set with the
## average of each variable for each activity and each subject.

meltedData<-melt(combineddata,id=c("Subject","Activity"))
tidyData<-dcast(meltedData,Subject+Activity ~ variable, mean)

write.table(tidyData,file="tidyData.txt",row.names = F)











