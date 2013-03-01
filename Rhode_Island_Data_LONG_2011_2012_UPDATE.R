#################################################################3
###
### April 2012 Creating of 2011-2012 Long data file 
###
##################################################################

### Load packages

require(foreign)
require(SGP)


### Utility functions

front.pad <- function(x, pad.character="0", final.length) {
        if (nchar(x) >= final.length) {
                return(as.character(x))
        } else {
                paste(paste(rep(pad.character, final.length-nchar(x)), collapse=""), x, sep="")
        }
}


### Load Data

load("Data/Base_Files/April_2012_Final/2011.RData")


### Stack data sets

Rhode_Island_Data_LONG_2011_2012_UPDATE <- rbind(mathematics2011, reading2011)


### Tidy up data


my.ethnicity.labels <- c("No Primary Race/Ethnicity Reported", "American Indian or Alaskan Native", "Asian", 
	"Black or African American", "Hispanic or Latino", "Native Hawaiian or Pacific Islander", "White", "Multiple Ethnicities Reported")
my.lep.labels <- c("Non-LEP Student", "Currently Receiving LEP Services", "Former LEP Student - Monitoring Year 1", 
	"Former LEP Student - Monitoring Year 2")
my.iep.labels <- c("Students without Disabilities (Non-IEP)", "Students with Disabilities (IEP)")
my.ses.labels <- c("Not Economically Disadvantaged", "Economically Disadvantaged")

names(Rhode_Island_Data_LONG_2011_2012_UPDATE) <- toupper(names(Rhode_Island_Data_LONG_2011_2012_UPDATE))
names(Rhode_Island_Data_LONG_2011_2012_UPDATE)[c(1,3,5:13,15:18,22:23)] <- 
	c("ID" , "YEAR", "DISTRICT_NUMBER", "DISTRICT_NAME",
	"DISTRICT_NUMBER_TESTING_YEAR", "DISTRICT_NAME_TESTING_YEAR", "SCHOOL_NUMBER", "SCHOOL_NAME",
	"SCHOOL_NUMBER_TESTING_YEAR", "SCHOOL_NAME_TESTING_YEAR", "ETHNICITY", "ELL_STATUS", "IEP_STATUS",
	"FREE_REDUCED_LUNCH_STATUS", "SCALE_SCORE", "DISTRICT_ENROLLMENT_STATUS", "SCHOOL_ENROLLMENT_STATUS") 

Rhode_Island_Data_LONG_2011_2012_UPDATE$ID <- as.factor(Rhode_Island_Data_LONG_2011_2012_UPDATE$ID)
levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$YEAR) <- "2011_2012"
levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$CONTENT_AREA) <- c("MATHEMATICS", "READING")

Rhode_Island_Data_LONG_2011_2012_UPDATE$GENDER[Rhode_Island_Data_LONG_2011_2012_UPDATE$GENDER=="X"] <- NA
Rhode_Island_Data_LONG_2011_2012_UPDATE$GENDER <- droplevels(Rhode_Island_Data_LONG_2011_2012_UPDATE$GENDER)
levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$GENDER) <- c("Female", "Male")

Rhode_Island_Data_LONG_2011_2012_UPDATE$ETHNICITY <- 
	factor(Rhode_Island_Data_LONG_2011_2012_UPDATE$ETHNICITY, levels=0:7, labels=my.ethnicity.labels)

Rhode_Island_Data_LONG_2011_2012_UPDATE$ELL_STATUS[is.na(Rhode_Island_Data_LONG_2011_2012_UPDATE$ELL_STATUS)] <- 0
Rhode_Island_Data_LONG_2011_2012_UPDATE$ELL_STATUS <- 
	factor(Rhode_Island_Data_LONG_2011_2012_UPDATE$ELL_STATUS, levels=0:3, labels=my.lep.labels)


Rhode_Island_Data_LONG_2011_2012_UPDATE$IEP_STATUS <- factor(Rhode_Island_Data_LONG_2011_2012_UPDATE$IEP_STATUS, levels=0:1, labels=my.iep.labels)

Rhode_Island_Data_LONG_2011_2012_UPDATE$FREE_REDUCED_LUNCH_STATUS <- factor(Rhode_Island_Data_LONG_2011_2012_UPDATE$FREE_REDUCED_LUNCH_STATUS, levels=0:1, labels=my.ses.labels)

Rhode_Island_Data_LONG_2011_2012_UPDATE$ACHIEVEMENT_LEVEL[Rhode_Island_Data_LONG_2011_2012_UPDATE$ACHIEVEMENT_LEVEL %in% 
	c("A", "E", "N", "S", "W", "L")] <- NA
Rhode_Island_Data_LONG_2011_2012_UPDATE$ACHIEVEMENT_LEVEL <- droplevels(Rhode_Island_Data_LONG_2011_2012_UPDATE$ACHIEVEMENT_LEVEL)
levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$ACHIEVEMENT_LEVEL) <- 
	c("Substantially Below Proficient", "Partially Proficient", "Proficient", "Proficient with Distinction")

Rhode_Island_Data_LONG_2011_2012_UPDATE$TEST_STATUS[Rhode_Island_Data_LONG_2011_2012_UPDATE$TEST_STATUS==" "] <- NA
Rhode_Island_Data_LONG_2011_2012_UPDATE$TEST_STATUS <- droplevels(Rhode_Island_Data_LONG_2011_2012_UPDATE$TEST_STATUS)

Rhode_Island_Data_LONG_2011_2012_UPDATE$STATE_ENROLLMENT_STATUS <- factor(1, levels=1:2, labels=c("Enrolled State: Yes", "Enrolled State: No"))
Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_ENROLLMENT_STATUS <- as.factor(Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_ENROLLMENT_STATUS)
levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_ENROLLMENT_STATUS) <- c("Enrolled District: No", "Enrolled District: Yes")
Rhode_Island_Data_LONG_2011_2012_UPDATE$SCHOOL_ENROLLMENT_STATUS <- as.factor(Rhode_Island_Data_LONG_2011_2012_UPDATE$SCHOOL_ENROLLMENT_STATUS)
levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$SCHOOL_ENROLLMENT_STATUS) <- c("Enrolled School: No", "Enrolled School: Yes")
levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$SCHOOL_NAME) <- sub(' +$', '', levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$SCHOOL_NAME))
levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$SCHOOL_NAME_TESTING_YEAR) <- sub(' +$', '', levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$SCHOOL_NAME_TESTING_YEAR))
levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_NAME) <- sub(' +$', '', levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_NAME))
levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_NAME_TESTING_YEAR) <- sub(' +$', '', levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_NAME_TESTING_YEAR))

### Validate/Invalidate Cases

Rhode_Island_Data_LONG_2011_2012_UPDATE$VALID_CASE <- factor(1, levels=1:2, labels=c("VALID_CASE", "INVALID_CASE"))
Rhode_Island_Data_LONG_2011_2012_UPDATE$VALID_CASE[Rhode_Island_Data_LONG_2011_2012_UPDATE$GRADE==11] <- "INVALID_CASE"
Rhode_Island_Data_LONG_2011_2012_UPDATE$VALID_CASE[is.na(Rhode_Island_Data_LONG_2011_2012_UPDATE$ID)] <- "INVALID_CASE"
Rhode_Island_Data_LONG_2011_2012_UPDATE$VALID_CASE[!(Rhode_Island_Data_LONG_2011_2012_UPDATE$TEST_STATUS %in% "A")] <- "INVALID_CASE"
Rhode_Island_Data_LONG_2011_2012_UPDATE <- as.data.table(Rhode_Island_Data_LONG_2011_2012_UPDATE)
setkeyv(Rhode_Island_Data_LONG_2011_2012_UPDATE, c("VALID_CASE", "YEAR", "CONTENT_AREA", "ID"))


### Add additional variables

Rhode_Island_Data_LONG_2011_2012_UPDATE$ELL_MULTI_CATEGORY_STATUS <- Rhode_Island_Data_LONG_2011_2012_UPDATE$ELL_STATUS
Rhode_Island_Data_LONG_2011_2012_UPDATE$ELL_STATUS <- NULL
Rhode_Island_Data_LONG_2011_2012_UPDATE$ELL_STATUS <- factor(1, levels=1:2, labels=c("Non-English Language Learners (ELL)", "English Language Learners (ELL)"))
Rhode_Island_Data_LONG_2011_2012_UPDATE$ELL_STATUS[Rhode_Island_Data_LONG_2011_2012_UPDATE$ELL_MULTI_CATEGORY_STATUS != "Non-LEP Student"] <- "English Language Learners (ELL)"

Rhode_Island_Data_LONG_2011_2012_UPDATE$CONSOLIDATED_PROGRAM_SUBGROUP <- factor(1, levels=1:2, labels=c("Consolidated Program Subgroup: No", "Consolidated Program Subgroup: Yes"))
Rhode_Island_Data_LONG_2011_2012_UPDATE$CONSOLIDATED_PROGRAM_SUBGROUP[
	Rhode_Island_Data_LONG_2011_2012_UPDATE$IEP_STATUS=="IEP: Yes" | 
	Rhode_Island_Data_LONG_2011_2012_UPDATE$ELL_STATUS=="ELL: Yes"] <- "Consolidated Program Subgroup: Yes"

Rhode_Island_Data_LONG_2011_2012_UPDATE$CONSOLIDATED_MINORITY_POVERTY_SUBGROUP <- factor(1, levels=1:2, 
	labels=c("Consolidated Minority/Poverty Subgroup: No", "Consolidated Minority/Poverty Subgroup: Yes"))
Rhode_Island_Data_LONG_2011_2012_UPDATE$CONSOLIDATED_MINORITY_POVERTY_SUBGROUP[
	Rhode_Island_Data_LONG_2011_2012_UPDATE$ETHNICITY!="White" & 
	Rhode_Island_Data_LONG_2011_2012_UPDATE$FREE_REDUCED_LUNCH_STATUS!="Free Reduced Lunch: No"] <- "Consolidated Minority/Poverty Subgroup: Yes"

Rhode_Island_Data_LONG_2011_2012_UPDATE$SCHOOL_ENROLLMENT_STATUS[Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_NUMBER==88] <- "Enrolled School: No"
Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_NUMBER[which(Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_NUMBER==88)] <- Rhode_Island_Data_LONG_2011_2012_UPDATE$SENDDISCODE[which(Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_NUMBER==88)]

Rhode_Island_Data_LONG_2011_2012_UPDATE$SENDDISCODE <- NULL


## Test for dups

## Identify duplicates

dups <- Rhode_Island_Data_LONG_2011_2012_UPDATE[Rhode_Island_Data_LONG_2011_2012_UPDATE[J("VALID_CASE")][duplicated(Rhode_Island_Data_LONG_2011_2012_UPDATE[J("VALID_CASE")])][,list(VALID_CASE, YEAR, CONTENT_AREA, ID)]]


### Merge in School and District names

school.and.district.names.2011_2012 <- read.spss("Data/Base_Files/2012 Public Schools for NECAP Accountability.sav", to.data.frame=TRUE)
names(school.and.district.names.2011_2012) <- c("EMH_LEVEL", "DISTRICT_NUMBER", "DISTRICT_NAME", "SCHOOL_NUMBER", "SCHOOL_NAME")

levels(school.and.district.names.2011_2012$EMH_LEVEL) <- c("Elementary", "High", "Middle")
school.and.district.names.2011_2012$DISTRICT_NUMBER <- as.integer(as.character(school.and.district.names.2011_2012$DISTRICT_NUMBER))
school.and.district.names.2011_2012$SCHOOL_NUMBER <- as.integer(as.character(school.and.district.names.2011_2012$SCHOOL_NUMBER))
levels(school.and.district.names.2011_2012$SCHOOL_NAME) <- sub(' +$', '', levels(school.and.district.names.2011_2012$SCHOOL_NAME))
levels(school.and.district.names.2011_2012$DISTRICT_NAME) <- sub(' +$', '', levels(school.and.district.names.2011_2012$DISTRICT_NAME))

district.names <- data.table(school.and.district.names.2011_2012[,c("DISTRICT_NUMBER", "DISTRICT_NAME")], key="DISTRICT_NUMBER")
district.names <- unique(district.names)

school.names <- data.table(school.and.district.names.2011_2012[,c("SCHOOL_NUMBER", "SCHOOL_NAME", "EMH_LEVEL")], key="SCHOOL_NUMBER")
school.names <- unique(school.names)

Rhode_Island_Data_LONG_2011_2012_UPDATE <- merge(as.data.frame(Rhode_Island_Data_LONG_2011_2012_UPDATE), as.data.frame(district.names), all.x=TRUE)
Rhode_Island_Data_LONG_2011_2012_UPDATE <- merge(Rhode_Island_Data_LONG_2011_2012_UPDATE, as.data.frame(school.names), all.x=TRUE)



### Merge in TCCS files

load("Data/TCCS_2011_WIDE.Rdata")
names(TCCS_2011_WIDE)[1] <- "ID"

TCCS_2011_WIDE$CONTENT_AREA <- factor(TCCS_2011_WIDE$CONTENT_AREA)
levels(TCCS_2011_WIDE$CONTENT_AREA) <- c("READING", "MATHEMATICS")

TCCS_2011_WIDE$YEAR <- factor(TCCS_2011_WIDE$YEAR)
TCCS_2011_WIDE$ID <- factor(TCCS_2011_WIDE$ID)

Rhode_Island_Data_LONG_2011_2012_UPDATE <- merge(Rhode_Island_Data_LONG_2011_2012_UPDATE, TCCS_2011_WIDE, all.x=TRUE)

names(Rhode_Island_Data_LONG_2011_2012_UPDATE)[29:35] <- paste("INSTRUCTOR_NUMBER_", 1:7, sep="")

Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_NUMBER <- as.factor(Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_NUMBER)
Rhode_Island_Data_LONG_2011_2012_UPDATE$SCHOOL_NUMBER <- as.factor(Rhode_Island_Data_LONG_2011_2012_UPDATE$SCHOOL_NUMBER)
levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_NUMBER) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$DISTRICT_NUMBER), front.pad, final.length=2))
levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$SCHOOL_NUMBER) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$SCHOOL_NUMBER), front.pad, final.length=5))


### Save results

save(Rhode_Island_Data_LONG_2011_2012_UPDATE, file="Data/Rhode_Island_Data_LONG_2011_2012_UPDATE.Rdata")



### Reconstruct Rhode_Island_SGP object and merge:

load("Data/Base_Files/Rhode_Island_SGP_020112_PRELIMINARY.Rdata")


### Tidy up levels of factors in @Data

Rhode_Island_SGP@Data$SGP_LEVEL <- droplevels(Rhode_Island_SGP@Data$SGP_LEVEL)
Rhode_Island_SGP@Data$SGP_LEVEL_BASELINE <- droplevels(Rhode_Island_SGP@Data$SGP_LEVEL_BASELINE)
Rhode_Island_SGP@Data$DISTRICT_NAME <- droplevels(Rhode_Island_SGP@Data$DISTRICT_NAME)
Rhode_Island_SGP@Data$DISTRICT_NAME_TESTING_YEAR <- droplevels(Rhode_Island_SGP@Data$DISTRICT_NAME_TESTING_YEAR)
Rhode_Island_SGP@Data$SCHOOL_NAME <- droplevels(Rhode_Island_SGP@Data$SCHOOL_NAME)
Rhode_Island_SGP@Data$SCHOOL_NAME_TESTING_YEAR <- droplevels(Rhode_Island_SGP@Data$SCHOOL_NAME_TESTING_YEAR)
Rhode_Island_SGP@Data$GENDER <- droplevels(Rhode_Island_SGP@Data$GENDER)
Rhode_Island_SGP@Data$CATCH_UP_KEEP_UP_STATUS_INITIAL <- droplevels(Rhode_Island_SGP@Data$CATCH_UP_KEEP_UP_STATUS_INITIAL)
Rhode_Island_SGP@Data$ACHIEVEMENT_LEVEL_PRIOR <- droplevels(Rhode_Island_SGP@Data$ACHIEVEMENT_LEVEL_PRIOR)


Rhode_Island_SGP@Data$SUPER_SUBGROUP_3 <- NULL
setnames(Rhode_Island_SGP@Data, 44:45, c("CONSOLIDATED_PROGRAM_SUBGROUP", "CONSOLIDATED_MINORITY_POVERTY_SUBGROUP"))
levels(Rhode_Island_SGP@Data$IEP_STATUS) <- levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$IEP_STATUS)
levels(Rhode_Island_SGP@Data$ELL_STATUS) <- levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$ELL_STATUS)
levels(Rhode_Island_SGP@Data$FREE_REDUCED_LUNCH_STATUS) <- levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$FREE_REDUCED_LUNCH_STATUS)
levels(Rhode_Island_SGP@Data$CONSOLIDATED_PROGRAM_SUBGROUP) <- levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$CONSOLIDATED_PROGRAM_SUBGROUP)
levels(Rhode_Island_SGP@Data$CONSOLIDATED_MINORITY_POVERTY_SUBGROUP) <- levels(Rhode_Island_Data_LONG_2011_2012_UPDATE$CONSOLIDATED_MINORITY_POVERTY_SUBGROUP)

Rhode_Island_Data_LONG_2011_2012_UPDATE <- as.data.table(Rhode_Island_Data_LONG_2011_2012_UPDATE)
tmp <- subset(Rhode_Island_SGP@Data, !YEAR %in% "2011_2012")
Rhode_Island_SGP@Data <- as.data.table(rbind.fill(tmp, Rhode_Island_Data_LONG_2011_2012_UPDATE))

### NULL out values to be recalculated

Rhode_Island_SGP@Summary <- NULL
Rhode_Island_SGP@SGP$SGPercentiles[["READING.2011_2012"]] <- NULL
Rhode_Island_SGP@SGP$SGPercentiles[["READING.2011_2012.BASELINE"]] <- NULL
Rhode_Island_SGP@SGP$SGPercentiles[["MATHEMATICS.2011_2012"]] <- NULL
Rhode_Island_SGP@SGP$SGPercentiles[["MATHEMATICS.2011_2012.BASELINE"]] <- NULL
Rhode_Island_SGP@SGP$SGProjections[["READING.2011_2012"]] <- NULL
Rhode_Island_SGP@SGP$SGProjections[["READING.2011_2012.BASELINE"]] <- NULL
Rhode_Island_SGP@SGP$SGProjections[["READING.2011_2012.LAGGED"]] <- NULL
Rhode_Island_SGP@SGP$SGProjections[["READING.2011_2012.LAGGED.BASELINE"]] <- NULL
Rhode_Island_SGP@SGP$SGProjections[["MATHEMATICS.2011_2012"]] <- NULL
Rhode_Island_SGP@SGP$SGProjections[["MATHEMATICS.2011_2012.BASELINE"]] <- NULL
Rhode_Island_SGP@SGP$SGProjections[["MATHEMATICS.2011_2012.LAGGED"]] <- NULL
Rhode_Island_SGP@SGP$SGProjections[["MATHEMATICS.2011_2012.LAGGED.BASELINE"]] <- NULL
Rhode_Island_SGP@SGP$Knots_Boundaries[["MATHEMATICS.2011_2012"]] <- NULL
Rhode_Island_SGP@SGP$Knots_Boundaries[["READING.2011_2012"]] <- NULL
Rhode_Island_SGP@SGP$Goodness_of_Fit[["MATHEMATICS.2011_2012"]] <- NULL
Rhode_Island_SGP@SGP$Goodness_of_Fit[["READING.2011_2012"]] <- NULL
Rhode_Island_SGP@SGP$Goodness_of_Fit[["MATHEMATICS.2011_2012.BASELINE"]] <- NULL
Rhode_Island_SGP@SGP$Goodness_of_Fit[["READING.2011_2012.BASELINE"]] <- NULL
Rhode_Island_SGP@SGP$Coefficient_Matrices[["MATHEMATICS.2011_2012"]] <- NULL
Rhode_Island_SGP@SGP$Coefficient_Matrices[["READING.2011_2012"]] <- NULL
Rhode_Island_SGP@SGP$Simulated_SGPs[["MATHEMATICS.2011_2012"]] <- NULL
Rhode_Island_SGP@SGP$Simulated_SGPs[["READING.2011_2012"]] <- NULL


### Create School/District/State Enrollment Status variable

Rhode_Island_SGP@Data[['VALID_CASE']][substr(Rhode_Island_SGP@Data[['SCHOOL_NUMBER']], 3, 3) %in% c("2", "3", "9")] <- "INVALID_CASE"
Rhode_Island_SGP@Data[['STATE_ENROLLMENT_STATUS']][substr(Rhode_Island_SGP@Data[['SCHOOL_NUMBER']], 3, 3) %in% c("2", "3", "9")] <- "Enrolled State: No"
Rhode_Island_SGP@Data[['DISTRICT_ENROLLMENT_STATUS']][substr(Rhode_Island_SGP@Data[['SCHOOL_NUMBER']], 3, 3) %in% c("2", "3", "9")] <- "Enrolled District: No"
Rhode_Island_SGP@Data[['SCHOOL_ENROLLMENT_STATUS']][substr(Rhode_Island_SGP@Data[['SCHOOL_NUMBER']], 3, 3) %in% c("2", "3", "9")] <- "Enrolled School: No"
Rhode_Island_SGP@Data[['SCHOOL_ENROLLMENT_STATUS']][is.na(Rhode_Island_SGP@Data[['SCHOOL_NUMBER']])] <- "Enrolled School: No"

### Make SCHOOL_NUMBER and DISTRICT_NUMBER NA equal to 88 or 88888

Rhode_Island_SGP@Data[['SCHOOL_NUMBER']][is.na(Rhode_Island_SGP@Data[['SCHOOL_NUMBER']]) & Rhode_Island_SGP@Data[['YEAR']]=="2011_2012"] <- "88888"
Rhode_Island_SGP@Data[['DISTRICT_NUMBER']][is.na(Rhode_Island_SGP@Data[['DISTRICT_NUMBER']]) & Rhode_Island_SGP@Data[['YEAR']]=="2011_2012"] <- "88"


### Save results

save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")
