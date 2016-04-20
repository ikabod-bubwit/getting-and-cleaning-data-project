library(dplyr)

# Download and Unzip Data files
downloadAndUnzipDataFile <- function(){
	dataFileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
	outputDataFile <- 'UCI_HAR_Dataset.zip'
	outputDir <- 'UCI HAR Dataset'
	
	message('Downloading and Unzipping Files......')
	
	# Download data file only once
	if (!file.exists(outputDataFile)){
		message('Start Downloading File[s]......')
		download.file(dataFileURL, outputDataFile, method=='curl')
	}
	# Unzip file ot outputDir
	if (!file.exists(outputDir)){
		message('Start Unzipping Files......')
		unzip(outputDataFile)
	}
	dataFilenames <- c('activity_labels.txt' ,'features.txt' ,"train/X_train.txt" ,'train/y_train.txt' 
		,'train/subject_train.txt' ,"test/X_test.txt" ,'test/y_test.txt' ,'test/subject_test.txt' )
	dataFilepaths <- paste(outputDir, dataFilenames, sep='/')
	
	# Test whether all data files exists
	if (sum(as.numeric(file.exists(dataFilepaths))) != length(dataFilepaths)){
		stop('Data Files are missing')	
	}	

	dataFilenames <- c('activitiesFile' ,'featuresFile' ,'trainingSetData' ,'trainingSetActivities' 
		,'trainingSetSubjects' ,'testSetData' ,'testSetActivities' ,'testSetSubjects' )
	
	dataFiles <- list()
	for (i in 1:length(dataFilepaths)){ dataFiles[[dataFilenames[i]]] <- dataFilepaths[i]}	

	dataFiles
}

# Extract labels and data from data files
extractRequiredData <- function(dataFiles){
	message('Extracting Data from Data Files......')

	features.labels <- read.table(dataFiles$featuresFile, col.names=c('id', 'labels'))
	activities.labels <- read.table(dataFiles$activitiesFile, col.names=c('id', 'labels'))

	# Coerce features.labels to string to perform some cleanup
	features.labels$labels <- as.character(features.labels$labels)
	
	# Extract only the data for mean and standard deviation and Cleanup Variable names
	features.required <- grepl(".*(mean|std).*", features.labels$labels)  #Save the boolean mask for required fields
	features.cleanLabels <- features.labels$labels[features.required]
	features.cleanLabels <- gsub('[)(-]', '',features.cleanLabels)
	features.cleanLabels <- sub('[Mm][Ee][Aa][Nn]', 'Mean',features.cleanLabels)
	features.cleanLabels <- sub('[Ss][Tt][Dd]', 'Std',features.cleanLabels)

	# Load both the training and test datasets including the subjects and activities
	# Filter only the Mean/Std Variables.
	data.trainSet <- read.table(dataFiles$trainingSetData)[,features.required]
	colnames(data.trainSet)<-features.cleanLabels
	data.trainSetSubjects <- read.table(dataFiles$trainingSetSubjects, col.names=c('subject'))
	data.trainSetActivities <- read.table(dataFiles$trainingSetActivities, col.names=c('activity'))
	# bind the subject and activity vars with the features vars
	data.trainSet <- cbind(data.trainSetSubjects, data.trainSetActivities, data.trainSet )

	data.testSet <- read.table(dataFiles$testSetData)[,features.required]
	colnames(data.testSet)<-features.cleanLabels
	data.testSetSubjects <- read.table(dataFiles$testSetSubjects, col.names=c('subject'))
	data.testSetActivities <- read.table(dataFiles$testSetActivities, col.names=c('activity'))
	# bind the subject and activity vars with the features vars
	data.testSet <- cbind(data.testSetSubjects, data.testSetActivities, data.testSet )


	message('Merging and Summarizing Data......')
	# Merge the training and test sets
	data.all <- rbind(data.trainSet, data.testSet)

	# Convert subject and activity to factors(grouping)
	data.all$subject <- as.factor(data.all$subject)
	data.all$activity <- factor(data.all$activity, levels=activities.labels$id, labels=activities.labels$labels)

	# Summarizing the data
	data.summarized <- data.all %>%  
			# select(1:5) %>%  // For testing
			group_by(subject, activity, add=TRUE)  %>%
			summarise_each(funs(mean))

	write.table(data.summarized, "tidyData.txt", row.names = FALSE, quote = FALSE)
	write.csv(data.summarized, "tidyData.csv", row.names = FALSE, quote = FALSE)

	data.summarized
}

# Putting it all togethter
main <- function(){
	dataFiles <- downloadAndUnzipDataFile()
	data.summarized <- extractRequiredData(dataFiles)
	View(data.summarized)
	cat ("Press [enter] to continue")
	b <- scan("stdin", character(), n=1)
}

main()
