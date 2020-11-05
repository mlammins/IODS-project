#### create_learning2014.R ####
# R-script for creating the dataset for the IODS-course
# Marko Lamminsalo, 2020-11-05
####
# Loading needed packages
#install.packages('dplyr')
require(dplyr)


#### Reading dataset ####
#
# Reading full learning2014 data from the web:
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",
                    sep="\t", header=TRUE)
dim(lrn14) # exploring dimensions: 183 rows, 60 columns
str(lrn14) # structure: gender as char, all other int values
# Additional info about data available at https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-meta.txt


#### Creating analysis dataset ####
# variables gender, age, attitude, deep, stra, surf and points
####
# create column 'attitude' by scaling the column "Attitude"
lrn14$attitude <- lrn14$Attitude / 10
# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# choose a handful of columns to keep
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# see the stucture of the new dataset
str(learning2014) # 183 obs. of 7 variables

# print out the column names of the data
colnames(learning2014)

# change the name of the second column
colnames(learning2014)[2] <- "age"

# change the name of "Points" to "points"
colnames(learning2014)[7] <- "points"

# print out the new column names of the data
colnames(learning2014)

# select rows where points is greater than zero
learning2014 <- filter(learning2014, points > 0)

# The data should then have 166 observations and 7 variables
str(learning2014) # data matches the criteria


#### Writing and loading the data ####
getwd() # check current working directory
# setwd() # for setting wd e.g. setwd("/home/user/Documents/IODS-project")
# here I dont set wd since I have it set
write.table(learning2014, file="./data/learning2014.txt", row.names=FALSE) # try writing txt
write.csv(learning2014, file="./data/learning2014.csv", row.names=FALSE) # try writing csv
# Try reading from written files
txt <- read.table("./data/learning2014.txt", header = TRUE)
csv <- read.csv("./data/learning2014.csv")
# Check to see match 
str(txt)
str(csv)
str(learning2014)
head(txt)
head(csv)
head(learning2014)
# seems the same