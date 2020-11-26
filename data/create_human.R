# Marko Lamminsalo
# 2020-11-26 (edit) & 2020-11-20 (original)
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
dim(hd) # 195 8
summary(hd)
colnames(gii)
str(gii)
dim(gii) # 195 10
summary(gii)

# Renaming columns as shorter based on metadata
# I did not find this info on meta, so making own abbreviations.
colnames(hd)
#[1] "HDI.Rank"                              
#[2] "Country"                               
#[3] "Human.Development.Index..HDI."         
#[4] "Life.Expectancy.at.Birth"              
#[5] "Expected.Years.of.Education"           
#[6] "Mean.Years.of.Education"               
#[7] "Gross.National.Income..GNI..per.Capita"
#[8] "GNI.per.Capita.Rank.Minus.HDI.Rank"    
colnames(hd) <- c("HDI.Rank","Country","HDI","Life.Exp","Edu.Exp",
                  "Edu.Mean","GNI","GNI.Minus.Rank")
#
colnames(gii)
#[1] "GII.Rank"                                    
#[2] "Country"                                     
#[3] "Gender.Inequality.Index..GII."               
#[4] "Maternal.Mortality.Ratio"                    
#[5] "Adolescent.Birth.Rate"                       
#[6] "Percent.Representation.in.Parliament"        
#[7] "Population.with.Secondary.Education..Female."
#[8] "Population.with.Secondary.Education..Male."  
#[9] "Labour.Force.Participation.Rate..Female."    
#[10] "Labour.Force.Participation.Rate..Male."      
colnames(gii) <- c("GII.Rank","Country","GII","Mat.Mor","Ado.Birth",
                   "Parli.F","Edu2.F","Edu2.M","Labo.F","Labo.M")

# Mutating gii to create 2 new variables (ratios F/M)
library(dplyr)
gii <- mutate(gii,  Edu2.FM = Edu2.F/Edu2.M) # 
gii <- mutate(gii, Labo.FM = Labo.F/Labo.M) # 


# Combining the data sets with common column to use as identifier
join_by <- "Country"
# join the two datasets by the selected identifier
human <- inner_join(hd, gii, by = join_by)
dim(human) # 195 19

# Saving the joined and modified dataset
 write.csv(human, file="./data/human.csv", row.names=FALSE)

 
 
# 2020-11-26 cont.
# The previously created dataset is wrangled even furher

# Load the data and explore
human <- read.csv("./data/human.csv")
names(human) # column names
str(human) # structure (dim 195 19)
summary(human) # summary

# Mutate the GNI from chr to numeric by using string manipulation (stringr package)
library(stringr)
str(human$GNI) # see that GNI actually consists of numeric data
# remove the commas from GNI and change to numeric
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

# Exclude unneeded variables by defining the columns to keep
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
# select the 'keep' columns
human <- dplyr::select(human, one_of(keep))

# Remove all rows with missing values with completeness indicator complete.cases()
human <- filter(human, complete.cases(human))

# Remove observations relating to regions instead of countries
tail(human,10)            # look at the last 10 observations of human
last <- nrow(human) - 7   # define the last indice we want to keep
human <- human[1:last, ] # choose everything until the last 7 observations

# Define row names by the country names and remove column Country
rownames(human) <- human$Country        # add countries as rownames
human <- dplyr::select(human, -Country) # remove the Country variable

# Checking data
str(human) # 155 obs in 8 variables

# Saving the modified dataset WITH row names
write.csv(human, file="./data/human.csv", row.names=TRUE)
