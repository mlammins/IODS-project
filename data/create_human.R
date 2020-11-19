# Marko Lamminsalo
# 2020-11-15
# R-script for creating dataset human 

# Data source: UNDP Human Development Index (HDI)
# Metadata available: http://hdr.undp.org/en/content/human-development-index-hdi
# Additional Technical Metadata available: http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf 
# The Human Development Index (HDI) is a summary measure of average achievement in key dimensions of 
# human development: a long and healthy life, being knowledgeable and have a decent standard of living. 
# The HDI is the geometric mean of normalized indices for each of the three dimensions.

## Read in both datasets, which are part of the Human Development Index
# “Human development”
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
# “Gender inequality”
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Exploring structure and dims
colnames(hd)
str(hd)
dim(hd) # 395 33
summary(hd)
colnames(gii)
str(gii)
dim(gii) # 649 33
summary(gii)

####


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


Data wrangling for the next week’s data! (Max 5 points)

Meta file for these datasets can be seen here and here are some technical notes. (1 point)
Explore the datasets: see the structure and dimensions of the data. Create summaries of the variables. (1 point)
Look at the meta files and rename the variables with (shorter) descriptive names. (1 point)
Mutate the “Gender inequality” data and create two new variables. The first one should be the ratio of Female and Male populations with secondary education in each country. (i.e. edu2F / edu2M). The second new variable should be the ratio of labour force participation of females and males in each country (i.e. labF / labM). (1 point)
Join together the two datasets using the variable Country as the identifier. Keep only the countries in both data sets (Hint: inner join). The joined data should have 195 observations and 19 variables. Call the new joined data "human" and save it in your data folder. (1 point)

