
#read the data and combine them to create one data set--test
x_test<-read.table("./test/X_test.txt",header=FALSE)
y_test<-read.table("./test/y_test.txt",header=FALSE)
subject_test<-read.table("./test/subject_test.txt",header=FALSE)
test<-cbind(subject_test,y_test,x_test)

#read the data and combine them to create one data set--train
x_train<-read.table("./train/X_train.txt",header=FALSE)
y_train<-read.table("./train/y_train.txt",header=FALSE)
subject_train<-read.table("./train/subject_train.txt",header=FALSE)
train<-cbind(subject_train,y_train,x_train)

#1.Merges the training and the test sets to create one data set
mydata1<-rbind(test,train)


#2.Extracts only the measurements on the mean and standard deviation for each measurement
features<-read.table("./features.txt",header=FALSE)
meanindex<-grep("mean()",features[,2],fixed=TRUE)
stdindex<-grep("std()",features[,2],fixed=TRUE)
index1<-c(meanindex,stdindex)
index<-index1[order(index1)]
mydata2<-mydata1[,c(1,2,index+2)]

#3.Uses descriptive activity names to name the activities in the data set
activity_labels<-read.table("./activity_labels.txt",header=FALSE)
mydata2<-within(mydata2,{
        V1.1[V1.1==1]<-"WALKING"
        V1.1[V1.1==2]<-"WALKING_UPSTAIRS"
        V1.1[V1.1==3]<-"WALKING_DOWNSTAIRS"
        V1.1[V1.1==4]<-"SITTING"
        V1.1[V1.1==5]<-"STANDING"
        V1.1[V1.1==6]<-"LAYING"
})

#4.Appropriately labels the data set with descriptive variable names
a<-features[index,]
name<-c("subject_ID","activity_name",as.vector(a$V2))
names(mydata2)<-name

#5.creates a tidy data set with the average of each variable for each activity and each subject
library(reshape2)
mydata2melt<-melt(mydata2,id=c("subject_ID","activity_name"),measure.vars=as.vector(a$V2))
mydata3<-dcast(mydata2melt,subject_ID+activity_name~variable,mean)
write.table(mydata3,row.name=FALSE,file="./mydat.txt")

