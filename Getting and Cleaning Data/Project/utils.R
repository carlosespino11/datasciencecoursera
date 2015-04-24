download_data = function() {
  if(!file.exists("data.zip")){
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data.zip", method="curl" )
    unzip("data.zip")
  }
}

clean_names = function(features){
  features$V2 = tolower(sapply(features$V2, function(x){gsub("-", "_", gsub("\\(|\\)|,", "", as.character(x)))})) # Clean varaible names removing "(", ")", "," )
  # Fix duplicate feature names indexing the repeated names
  i = 0
  j = 0
  indexed_names = c() 
  for( f in features$V2[duplicated(features$V2 )]){
    if(i %% 14 == 0)
      j= j %% 3 +1
    i = i + 1 
    indexed_names[i] = paste(f, j, sep="_")
    
  }
  features$V2[duplicated(features$V2 )] = indexed_names
  features
}

read_data_set = function(type, features) {
  X = as.data.table(read.table(paste("UCI HAR Dataset/", type,"/X_", type,".txt", sep="")))
  setnames(X, names(X), features$V2)
  Y = as.data.table(read.table(paste("UCI HAR Dataset/", type,"/Y_", type,".txt", sep="")))
  setnames(Y, names(Y), "activity_id")
  subject = as.data.table(read.table(paste("UCI HAR Dataset/", type,"/subject_", type, ".txt", sep="")))
  setnames(subject, names(subject), "subject")
  train = bind_cols(X, Y, subject)
}