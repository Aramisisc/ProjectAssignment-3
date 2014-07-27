#download and unzip the data file: to this extend we create a temp file
temp <- tempfile()

url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url,temp)

unzip(temp)

#read the files that will be used for the course assignment
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",  sep = "",header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt",  sep = "",header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt",  sep = "",header = FALSE)

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",  sep = "",header = FALSE)
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt",  sep = "",header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt",  sep = "",header = FALSE)

features <- read.table("./UCI HAR Dataset/features.txt",  sep = "",header = FALSE)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",  sep = "",header = FALSE)

#Merge the training and the test sets to create one data set: this is Part1 of the assignement
FullDataSet <- rbind(X_train,X_test)

#assign the column names (the time and frequency features) to the training and test data sets
#this is the Part4 of the assignement
colnames(FullDataSet) <- features[,2]

# Add the related activity to each record of trainig data set and test data set
#To this extend, first merge the activity files in the right order
#we assume that records order in FullDataSet and activities are the same
activities <- rbind(y_train,y_test)
FullDataSet$Id_activity <- activities

# Add the related subject who performed the activity to each record of trainig data set and test data set
#To this extend, first merge the activity files in the right order
#we assume that records order in FullDataSet and subjects are the same
subject <- rbind(subject_train,subject_test)
#before adding the subject column, i coerce it to a numeric class (now a data.frame),
#otherwhise there will be an isue later in the melt function: "check that the only non 
#numeric column is activity, because if in melt you had id=c("SubjectID", "Activity") and 
#there was another non-numeric column, you would be trying to melt non-numeric data in 
#amongst numeric data, and R will not be very happy.
subjects  <- as.numeric(as.matrix(subject))

FullDataSet$Id_subject <- subjects

#Part3 of the assignement: Uses descriptive activity names to name the activities in the data set
#First, assign the right column name in the activity_labels file
FullDataSet$Activity_name <-activity_labels[,2][activities[,1]]

#Part2 of the assignement:Extracts only the measurements on the mean and standard deviation for each measurement
#Selection of all columns containing the words mean or std 
#We'll keep also the reference to the subject and the activity name
ColToKeep <- grepl(".*mean.*|.*std.*|Id_subject|Activity_name", colnames(FullDataSet))
MeanStdExtr  <- FullDataSet[,ColToKeep]

#Part5 of the assignement: creation of tidy data set with the average of each variable for each activity and each subject
#The variables will be the ones from MeanStdExtr (so not the 561 variables)
#define the figures variables
     ColVar <- grepl(".*mean.*|.*std.*", colnames(MeanStdExtr))
     meas_var <- colnames(MeanStdExtr[,Colvar])

DataSet_melt <- melt(MeanStdExtr, id = c("Id_subject", "Activity_name"), measure.vars = meas_var)
Avg_data <- dcast(DataSet_melt, Id_subject + Activity_name ~ variable, mean)
#creation of the file, tab separated, without quote surrounding the character string (the header)
#and without rownames (1,2,3,etc...)
write.table(Avg_data, file="Avg_data.txt", sep="\t", quote=FALSE, row.names=FALSE)