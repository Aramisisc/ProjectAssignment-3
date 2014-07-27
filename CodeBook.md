##Code Book for script  run_analysis.R

###Introduction
This script generate a file called Avg_data.txt.
The data source for the file is a zip file (that can be found in https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
The source file contains measurements of experiments that have been carried out with a group of 30 volunteers,wearing a smartphone. Each person performed six activities
* WALKING, 
* WALKING_UPSTAIRS, 
* WALKING_DOWNSTAIRS,  
* SITTING, 
* STANDING, 
* LAYING

###Objective
The objective of the script is to create an output file (Avg_data.txt) that contains the average of specific variables for each activity and each subject.

The specific variables are the measurements on the mean and standard deviation for each measurement
The activities are the ones mentonned in previous point
The subjects are the 30 volunteers

###Process

The script execute the following steps:
* download and unzip the data file
* read the files that are relevant for the objective:
** X_test.txt: measurement for the people performing the test data
** subject_test.txt: subjects (people) having performed each test data records
** y_test.txt: activities id performed at each test data record
** X_training.txt: measurement for the people performing the training data
** subject_training.txt: subjects (people) having performed each training data records
** y_training.txt: activities id performed at each training data record
** activity_labels.txt: description of the different activities performed
** features.txt: description of each measurement
* the measurements input files are split by "training" (X_train) and "test" (X_test) data set: so we merge the data sets to get one set (FullDataSet)
* we add the column titles (defined in features file) to data set FullDataSet
* we add to data set FullDataSet the column containing the id of activities (Id_activity) linked to each measurements records (found in y_xx files)
* we add to data set FullDataSet the column containing the subject (Id_subject) linked to each measurements records (found in subject_xx files). In this case, to avoid any issue in the next "melt" function, we coerce the subject as numeric (originally it's a data.frame)
* we add to data set FullDataSet a column containg containing the label linked to each activities id (Activity_name) (found in activity_label file)
* we create a data set (MeanStdExtr) by extracting from the data set FullDataSet:
** all the measurements linked to the mean and standard deviation variable (so all variables containing words 'mean' or 'std' in the label), 
** toghether with the activity name and the subjects 
** => these columns are defined in variable ColToKeep 
* from the MeanStdExtr data set, we create the final Avg_data data set, by melting the data in order to have the average of each variables in  MeanStdExtr,for each activity and each subject (which are the descriptive data) 
* finally, from Avg_data data set, a txt file is created (Avg_data.txt) and posted in the working directory 
