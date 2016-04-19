library(dplyr)


# Define Globals
dataFileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
outputDataFile <- 'UCI_HAR_Dataset.zip'
outputDir <- 'UCI HAR Dataset'
activitiesFile <- 'activity_labels.txt'
featuresFile <- 'features.txt'

# Checks if all required data files exists/extracted
dataFilesExist <- function(vFiles){
	f <- c(activitiesFile, featuresFile)
	fpaths <- paste(outputDir, f, sep='/')
	if (sum(as.numeric(file.exists(fpaths))) != length(f)){
		stop('Data Files are missing')	
	}
	TRUE
}

# Download and Unzip Data files
downloadAndUnzipDataFile <- function(){
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
