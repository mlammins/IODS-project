# Marko Lamminsalo
# 2020-12-02 
# R-script for dataset BPRS and RATS  

# Data source: Kimmo Vehkalahti's Github repository of MABS
# Metadata available in book 
# Vehkalahti, Everitt (2019): Multivariate Analysis for the Behavioral Sciences
# (or MABS for short), chapters 8 and 9

# Read in both datasets (given in wide format)
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header=T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header=T)

# Save the wide formats (just in case)
write.table(BPRS, file="./data/BPRS.txt", row.names=FALSE) 
write.table(RATS, file="./data/RATS.txt", row.names=FALSE)

# Looking at the (wide) datasets 
# BPRS
names(BPRS)
head(BPRS) 
str(BPRS) 
summary(BPRS)

# RATS
names(RATS)
head(RATS)
str(RATS)
summary(RATS)

# Converting categorical variables to factors
BPRS$treatment <- as.factor(BPRS$treatment)
BPRS$subject <- as.factor(BPRS$subject)
RATS$ID <- as.factor(RATS$ID)
RATS$Group <- as.factor(RATS$Group)

# Convert datasets to long form (L for long)
library(dplyr)
library(tidyr)
BPRSL <- BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
RATSL <- RATS %>% gather(key = WD, value = rats, -ID, -Group)

# Adding week variable to BPRS and a Time variable to RATS
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(BPRSL$week,5,6)))
RATSL <-  RATSL %>% mutate(Time = as.integer(substr(RATSL$WD,3,4)))

# Taking a serious look at the (long) datasets 
# BPRS
names(BPRSL)
head(BPRSL) 
str(BPRSL) 
summary(BPRSL)

# RATS
names(RATSL)
head(RATSL)
str(RATSL)
summary(RATSL)

# Comparing formats:
# wide (fewer rows, many variables)
# long (many rows, fewer variables)

# Save the long datasets
write.table(BPRSL, file="./data/BPRSL.txt", row.names=FALSE) 
write.table(RATSL, file="./data/RATSL.txt", row.names=FALSE)