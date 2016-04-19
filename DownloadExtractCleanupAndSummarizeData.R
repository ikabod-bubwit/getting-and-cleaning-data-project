library(dplyr)


# Define Globals
outputDir <- 'UCI HAR Dataset'
activitiesFile <- 'activity_labels.txt'
featuresFile <- 'features.txt'
trainingSetData <- "train/X_train.txt"
trainingSetActivities <- 'train/y_train.txt'
trainingSetSubjects <- 'train/subject_train.txt'
testSetData <- "test/X_test.txt"
testSetActivities <- 'test/y_test.txt'
testSetSubjects <- 'test/subject_test.txt'


features <- NULL
features.labels <- NULL
features.cleanLabels <- NULL

# Checks if all required data files exists/extracted
dataFilesExist <- function(f){
	# f <- c(activitiesFile, featuresFile)
	# fpaths <- paste(outputDir, f, sep='/')
	if (sum(as.numeric(file.exists(f))) != length(f)){
		stop('Data Files are missing')	
	}
	TRUE
}

# Download and Unzip Data files
downloadAndUnzipDataFile <- function(){
	dataFileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
	outputDataFile <- 'UCI_HAR_Dataset.zip'
	
	message('Downloading and Unzipping Files......')
	
	# Download data file only once
	if (!file.exists(outputDataFile)){
		download.file(dataFileURL, outputDataFile, method=='curl')
	}
	# Unzip file ot outputDir
	if (!file.exists(outputDir)){
		unzip(outputDataFile)
	}
}

# Extract labels and data from data files
extractRequiredData <- function(){
	dataFilenames <- c(activitiesFile ,featuresFile ,trainingSetData ,trainingSetActivities 
		,trainingSetSubjects ,testSetData ,testSetActivities ,testSetSubjects )
	dataFilepaths <- paste(outputDir, dataFilenames, sep='/')
	
	# Test whether all data files exists
	dataFilesExist(dataFilepaths)

	dataFilenames <- c('activitiesFile' ,'featuresFile' ,'trainingSetData' ,'trainingSetActivities' 
		,'trainingSetSubjects' ,'testSetData' ,'testSetActivities' ,'testSetSubjects' )
	
	dataFiles <- list()
	for (i in 1:length(dataFilepaths)){ dataFiles[[dataFilenames[i]]] <- dataFilepaths[i]}
	
	message('Extracting Data from Data Files......')

	features.labels <- read.table(dataFiles$featuresFile, col.names=c('id', 'labels'))
	activities.labels <- read.table(dataFiles$activitiesFile, col.names=c('id', 'activities'))

	# Coerce features.labels to string to perform some cleanup
	features.labels$labels <- as.character(features.labels$labels)
	
	# Extract only the data for mean and standard deviation and Cleanup Variable names
	features.required <- grepl(".*(mean|std).*", features.labels$labels)  #Save the boolean mask for required fields
	features.cleanLabels <- features.labels$labels[features.required]
	features.cleanLabels <- gsub('[)(-]', '',features.cleanLabels)
	features.cleanLabels <- sub('[Mm][Ee][Aa][Nn]', 'Mean',features.cleanLabels)
	features.cleanLabels <- sub('[Ss][Tt][Dd]', 'Std',features.cleanLabels)

	

	


}

# Putting it all togethter
main <- function(){
	downloadAndUnzipDataFile()
	extractRequiredData()
}

main()
