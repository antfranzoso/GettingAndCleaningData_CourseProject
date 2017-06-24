# Details on the workflow
The script works on the follow assumption:
  - The UCI HAR Dataset is in the R working directory

## What the script does
The "run_analysis.R" script reads:
 - the training and test sets
 - the subjects info for each datasets
 - the activity label file ("activity_labels.txt")
 - the activity classes for each data sets
and produces:
 - a dataset (named "Prog_Ass_Dat01.txt") composed by all the observations in the training and test set, the resulting activity    class (its descriptive label), the subject related to the observation
 - a dataset (named "Prog_Ass_Dat02.txt") derived from the first one which each variables is aggregated by the activity class      and subject

## The run_analysis.R script
The script performs the follows operations:
 - Loads the training and test sets and merge them together
 - Selects only the columns that contains "mean" or "std" in their name
 - Loads and merges the subject training and subject test datasets and append the resulting column to the dataset
 - Loads and merges the training activity class and test activity class and append the resulting column to the dataset
 - Adds to the dataset a descriptive column for the activity class by joining together the dataset and the activity labels (the    "activity_labels.txt". The join is performed by merge function
 - Renames the columns stripping the trailing dots and replacing them with the underscore char
 - writes the resulting dataset to the disk and removes all the unused variables from workspace
 - computes a second dataset by calculating the mean for each variable for each class and subject
 - write the second dataset to the disk and remove the remaining variables
