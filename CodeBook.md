---
title: "CodeBook"
output: github_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Code book 


### Introduction 

This file describes how to clean up data from Human Activity Recongnition Using Smartphones to be compliant with the Getting and Cleaning Data Course requirements from Coursera Data Science specialization.

## Obtaining data

Initial data can be downloaded as zip file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Cleaning data

- Read feature list from features.txt file  
- Read activity tables from activity_labels.txt file  
- Read tran and sets from x_train.txt, y_train.txt, subject_train.txt
- Merge test and train data into total datasets
- remove from total x dataset all columns except mean and std
- merge actibity name into x 
- rename columns to be self-describing
- group data with the average of each variable for each activity and each subject

R file run_analysus.R contains all the instructions to clean the data so you dont need to do anything manually. Steps above are provided  just to comply with course requirements.


