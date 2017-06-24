# Load the datasets, assuming they are in a folder into the WD.

#Load labels
labels <-
  read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[, 2]
#Load Training set
trset <-
  read.table("./UCI HAR Dataset/train/X_train.txt", col.names = labels)
#Load Test Set
tsset <-
  read.table("./UCI HAR Dataset/test/X_test.txt", col.names = labels)
#Merge the two datasets
dataset <- rbind(trset, tsset)
#Select only "mean column"
library(dplyr)
dataset <- dataset %>% select(matches("mean|std"))
#Load subjects dataset and join it to the dataset
subjecttraning <-
  read.table(
    "./UCI HAR Dataset/train/subject_train.txt",
    stringsAsFactors = FALSE,
    col.names = c("subject")
  )
subjecttest <-
  read.table(
    "./UCI HAR Dataset/test/subject_test.txt",
    stringsAsFactors = FALSE,
    col.names = c("subject")
  )
subjectcolumn <- rbind(subjecttraning, subjecttest)
dataset <- cbind(dataset, subjectcolumn)
#Load activity labels
activitylabels <-
  read.table(
    "./UCI HAR Dataset/activity_labels.txt",
    stringsAsFactors = FALSE,
    col.names = c("class_id", "class_name")
  )
#Join the activity class for both subdataset. First we need to merge them
trsetclasses <-
  read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("class_id"))
tssetclasses <-
  read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("class_id"))
classes <- rbind(trsetclasses, tssetclasses)
dataset <- mutate(dataset, class = classes$class_id)
dataset <-
  merge(x = dataset,
        y = activitylabels,
        by.x = "class",
        by.y = "class_id")
#Remove the class column
dataset <- dataset[, -which(names(dataset) == "class")]
#Rename the other column using these simple conventions:
# - strip the trailing dots
# - replace the remaining dots with the character "_"
names(dataset) <-
  apply(
    X = array(names(dataset)),
    MARGIN = 1,
    FUN = function(x)
      gsub("[/.]", "_",
           gsub("[/.]*$", "",
                gsub("[/.]{2,}", "_", x)))
  )

#Write the resulting dataset as txt file and clear the workspace
write.table(x = dataset, file = "Prog_Ass_Dat01.txt", row.names = FALSE)
rm(
  activitylabels,
  classes,
  subjectcolumn,
  subjecttest,
  subjecttraning,
  trset,
  trsetclasses,
  tsset,
  tssetclasses
)

# Compute the second dataset as the average of each variable for each activity and each subject
dataset2 <-
  aggregate(
    select(dataset, -class_name,-subject),
    list(dataset$class_name, dataset$subject),
    mean
  )
#Write the second dataset on the disk and clean the workspace
write.table(x = dataset2, file = "Prog_Ass_Dat02.txt", row.names = FALSE)
rm(dataset, dataset2)
