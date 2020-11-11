# Marko Lamminsalo
# 2020-11-11
# R-script for creating dataset alc by joining data together 

# Data source: UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/dataset)
# Metadata available at: https://archive.ics.uci.edu/ml/datasets/Student+Performance
#   The data are from two identical questionaires related to secondary school student alcohol
#   comsumption in Portugal.
# P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance.
# paper <- "http://www3.dsi.uminho.pt/pcortez/student.pdf"

# Read in both datasets
math <- read.csv("./data/student-mat.csv", sep=";")
por <- read.csv("./data/student-por.csv", sep=";")

# Exploring structure and dims
colnames(math)
str(math)
dim(math) # 395 33
colnames(por)
str(por)
dim(por) # 649 33

# Combining the data sets with dplyr library
library(dplyr)
# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
# join the two datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by, suffix=c(".math",".por"))

# Exploring the joined data
colnames(math_por)
glimpse(math_por)
dim(math_por) # 382 53

# Combine duplicated answers in joined data
alc <- select(math_por, one_of(join_by)) # a new data frame with only the joined columns
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by] # the columns not used for joining the data
notjoined_columns # print out the names of columns not used for joining

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# Exploring the new combined data
colnames(alc)
glimpse(alc)
dim(alc) # 382 33

# Create new column regarding alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2) # combining weekday and weekend alcohol use
alc <- mutate(alc, high_use = alc_use > 2) # define a new logical column 'high_use'

# Explore the data
colnames(alc)
glimpse(alc)
dim(alc) # 382 35

# Saving the joined and modified dataset
write.csv(alc, file="./data/alc.csv", row.names=FALSE)

# Note! There appears to be error in the script above.
# Instead of 382, there are actually 370 unique observations.
# See:
# https://github.com/rsund/IODS-project/blob/master/data/create_alc.R