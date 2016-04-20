# getting-and-cleaning-data-project
 Coursera Project on Getting and Cleaning Data in R.
 The R script, `DownloadExtractCleanupAndSummarizeData.R` generates `tidyData.csv` a clean and summarized version of the data downloaded 
from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

 The following steps were performed when generating the output `tidyData.csv`
 
1. **Download and Unzip the dataset** if data does not already exist in the working directory
2. **Load the activity and feature data** from 'activity_labels.txt' and 'features.txt' files.
3. **Extract only mean or standard deviation features/variables** and generate a boolean mask.
3. **Load both the training and test datasets** using the boolean mask generated from step 3 as a filter, this step uses the 
   files, "train/X_train.txt" and "test/X_test.txt".
4. **Load the activity and subject data for each dataset** and merge the
   columns with its respective dataset. The following files were used during this step: 'train/y_train.txt'       ,'train/subject_train.txt' ,'test/y_test.txt' and 'test/subject_test.txt'
5. **Merge both the training and test datasets** together.
6. **Convert the** `activity` **and** `subject` **columns into factors** for grouping purposes.
7. **Summarize the dataset** by getting the average(mean) value of each variable for every subject and activity pair.

#### External Dependencies
dplyr package
