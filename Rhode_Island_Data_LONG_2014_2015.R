##############################################################
###
### Script for creating Rhode_Island_Data_LONG_2014_2015
###
##############################################################

### Load SGP and data.table

require(SGP)
require(data.table)
require(foreign)


### Load data

Rhode_Island_Data_LONG_2014_2015 <- as.data.table(read.spss("Data/Base_Files/2015 NECAP.sav", to.data.frame=TRUE, use.value.labels=FALSE))


##########################################################
### Clean up 2014 2015 data
##########################################################



