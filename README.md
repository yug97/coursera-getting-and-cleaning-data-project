# coursera-getting-and-cleaning-data-project

This project is for the Getting and Cleaning Data Coursera course.
The R script, run_analysis.R, run as follows:

Download the dataset if it does not already exist in the working directory and unzip it

Load the activity and feature info

Loads training and test datasets, which contains only those columns which contains  Mean or Std

Loads activity and subject data for each dataset, and merges those columns with the dataset

Merges the two datasets

Converts the activity and subject columns into factors

Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.

All result is reflected in tidy.txt file.
