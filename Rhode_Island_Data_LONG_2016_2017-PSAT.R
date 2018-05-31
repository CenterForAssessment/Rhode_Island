################################################################
###                                                          ###
###   Script for creating Rhode_Island_Data_LONG_2016_2017   ###
###                                                          ###
################################################################

### Load required packages

require(SGP)
require(data.table)
require(foreign)


### Load data

Rhode_Island_Data_PSAT_2017 <- as.data.table(read.spss("Data/Base_Files/PSAT 2016-17 scores.sav", to.data.frame=TRUE, use.value.labels=FALSE))
Rhode_Island_Data_LONG_2016_2017 <- as.data.table(read.spss("Data/Base_Files/2017 PARCC Summative File For Accountability.sav", to.data.frame=TRUE, use.value.labels=FALSE))


##########################################################
###   Clean up 2017 PSAT data
##########################################################

variables.to.keep <- c("CB_ID", "NAME_FIRST", "NAME_LAST", "SEX", "DERIVED_AGGREGATE_RACE_ETH",
        "LATEST_PSAT_TOTAL", "LATEST_PSAT_EBRW", "LATEST_PSAT_MATH_SECTION", "COHORT_YEAR") #, "LATEST_PSAT_DATE")

Rhode_Island_Data_PSAT_2017 <- Rhode_Island_Data_PSAT_2017[, variables.to.keep, with=FALSE]


### Tidy Up data

variable.names.new <- c("CB_ID", "FIRST_NAME", "LAST_NAME", "GENDER", "ETHNICITY", "PSAT_TOTAL", "PSAT_EBRW", "PSAT_MATH", "COHORT_YEAR") # , "LATEST_PSAT_DATE")
setnames(Rhode_Island_Data_PSAT_2017, variable.names.new)

Rhode_Island_Data_PSAT_2017[, YEAR := "2016_2017"]
Rhode_Island_Data_PSAT_2017[, GRADE := "EOCT"]
Rhode_Island_Data_PSAT_2017[, VALID_CASE := "VALID_CASE"]

Rhode_Island_Data_PSAT_2017[COHORT_YEAR != "2019", VALID_CASE := "INVALID_CASE"]

levels(Rhode_Island_Data_PSAT_2017$FIRST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_PSAT_2017$FIRST_NAME), capwords))
levels(Rhode_Island_Data_PSAT_2017$LAST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_PSAT_2017$LAST_NAME), capwords))

levels(Rhode_Island_Data_PSAT_2017$GENDER) <- c("Female", "Male", NA)

# https://secure-media.collegeboard.org/digitalServices/pdf/ap/ap-guide-to-race-ethnicity-reporting-schools-districts-2016.pdf
levels(Rhode_Island_Data_PSAT_2017$ETHNICITY) <- c("No Primary Race/Ethnicity Reported", "American Indian or Alaskan Native", "Other", "Multiple Ethnicities Reported", "Asian", "Black or African American", "Hispanic or Latino", "Native Hawaiian or Pacific Islander", "White")

###  Add SASID
ID_LOOKUP <- fread("Data/Base_Files/psat sasid match_format.csv")

ID_LOOKUP[, CB_ID := as.character(CB_ID)]
Rhode_Island_Data_PSAT_2017[, CB_ID := Literasee:::trimWhiteSpace(as.character(CB_ID))]
setkey(ID_LOOKUP, CB_ID)
setkey(Rhode_Island_Data_PSAT_2017, CB_ID)
Rhode_Island_Data_PSAT_2017 <- ID_LOOKUP[, list(SASID, CB_ID)][Rhode_Island_Data_PSAT_2017]
setnames(Rhode_Island_Data_PSAT_2017, "SASID", "ID")

###  Combine content areas into single LONG file

Rhode_Island_Data_LONG_PSAT_2017 <- rbindlist(list(
      Rhode_Island_Data_PSAT_2017[, SCALE_SCORE := PSAT_MATH][, list(VALID_CASE, ID, YEAR, GRADE, FIRST_NAME, LAST_NAME, GENDER, ETHNICITY, SCALE_SCORE)][, CONTENT_AREA := "PSAT_MATH"],
      Rhode_Island_Data_PSAT_2017[, SCALE_SCORE := PSAT_EBRW][, list(VALID_CASE, ID, YEAR, GRADE, FIRST_NAME, LAST_NAME, GENDER, ETHNICITY, SCALE_SCORE)][, CONTENT_AREA := "PSAT_EBRW"]#,
      # Rhode_Island_Data_PSAT_2017[, SCALE_SCORE := PSAT_TOTAL][,list(ID, YEAR, FIRST_NAME, LAST_NAME, GENDER, ETHNICITY, SCALE_SCORE)][, CONTENT_AREA := "PSAT_TOTAL"]
))

Rhode_Island_Data_LONG_PSAT_2017 <- Rhode_Island_Data_LONG_PSAT_2017[!is.na(ID)]

# cohort <- Rhode_Island_Data_PSAT_2017[!is.na(ID), list(ID, LATEST_PSAT_DATE, COHORT_YEAR)]
# setkey(cohort, ID)

##########################################################
###   Clean up 2016-2017 PARCC data
##########################################################

variables.to.keep <- c("ResponsibleDistrictCode", "ResponsibleSchoolCode",
        "StateStudentIdentifier", "TestFormat", "FirstName", "LastOrSurname", "Sex", "GradeLevelWhenAssessed",
        "FederalRaceEthnicity", "EnglishLearnerEL", "EconomicDisadvantageStatus", "StudentWithDisabilities", "PrimaryDisabilityType",
        "TestCode", "TestScaleScore", "IRTTheta", "TestPerformanceLevel") # No "GiftedandTalented", "MigrantStatus",  - maybe one of the "StateField*" vars ?

Rhode_Island_Data_LONG_2016_2017 <- Rhode_Island_Data_LONG_2016_2017[, variables.to.keep, with=FALSE]

variable.names.new <- c("DISTRICT_NUMBER", "SCHOOL_NUMBER", "ID", "TEST_FORMAT", "FIRST_NAME", "LAST_NAME", "GENDER", "GRADE_ENROLLED",
    "ETHNICITY", "ELL_STATUS", "FREE_REDUCED_LUNCH_STATUS", "IEP_STATUS", "DISABILITY_TYPE", "TestCode",
    "SCALE_SCORE_ACTUAL", "SCALE_SCORE", "ACHIEVEMENT_LEVEL") # "GIFTED_AND_TALENTED_STATUS", "MIGRANT_STATUS",

setnames(Rhode_Island_Data_LONG_2016_2017, variable.names.new)

### Tidy Up data

Rhode_Island_Data_LONG_2016_2017[, ID := as.character(ID)]
Rhode_Island_Data_LONG_2016_2017[, YEAR := "2016_2017"]
Rhode_Island_Data_LONG_2016_2017[, VALID_CASE := "VALID_CASE"]

####  CONTENT_AREA from TestCode
Rhode_Island_Data_LONG_2016_2017[, CONTENT_AREA := factor(TestCode)]
levels(Rhode_Island_Data_LONG_2016_2017$CONTENT_AREA) <- c("AAELA", "AAMAT", "ALGEBRA_I", "ALGEBRA_II", rep("ELA", 7), "GEOMETRY", rep("MATHEMATICS", 6))
Rhode_Island_Data_LONG_2016_2017[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  GRADE from TestCode
Rhode_Island_Data_LONG_2016_2017[, GRADE := gsub("ELA|MAT", "", TestCode)]
Rhode_Island_Data_LONG_2016_2017[, GRADE := as.character(as.numeric(GRADE))]
Rhode_Island_Data_LONG_2016_2017[which(is.na(GRADE)), GRADE := "EOCT"]
Rhode_Island_Data_LONG_2016_2017[, GRADE := as.character(GRADE)]
# table(Rhode_Island_Data_LONG_2016_2017[, GRADE, TestCode])

Rhode_Island_Data_LONG_2016_2017[, TestCode := NULL]

Rhode_Island_Data_LONG_2016_2017[, SCHOOL_NUMBER:=paste(DISTRICT_NUMBER, SCHOOL_NUMBER, sep="_")]

levels(Rhode_Island_Data_LONG_2016_2017$FIRST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2016_2017$FIRST_NAME), capwords))
levels(Rhode_Island_Data_LONG_2016_2017$LAST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2016_2017$LAST_NAME), capwords))

levels(Rhode_Island_Data_LONG_2016_2017$GENDER) <- c("Female", "Male")
levels(Rhode_Island_Data_LONG_2016_2017$ETHNICITY) <- c("American Indian or Alaskan Native", "Asian", "Black or African American", "Hispanic or Latino", "Native Hawaiian or Pacific Islander", "White", "Multiple Ethnicities Reported", "No Primary Race/Ethnicity Reported")
Rhode_Island_Data_LONG_2016_2017[,ETHNICITY := as.character(ETHNICITY)]
levels(Rhode_Island_Data_LONG_2016_2017$ELL_STATUS) <- c(NA, "Non-English Language Learners (ELL)", "English Language Learners (ELL)")
levels(Rhode_Island_Data_LONG_2016_2017$FREE_REDUCED_LUNCH_STATUS) <- c(NA, "Not Economically Disadvantaged", "Economically Disadvantaged")
levels(Rhode_Island_Data_LONG_2016_2017$IEP_STATUS) <- c(NA, "Students with 504 Plan", "B", "Students with Disabilities (IEP)", "Students without Disabilities (Non-IEP)", "Students without Disabilities (Non-IEP)")
levels(Rhode_Island_Data_LONG_2016_2017$DISABILITY_TYPE) <- c(NA, Literasee:::trimWhiteSpace(levels(Rhode_Island_Data_LONG_2016_2017$DISABILITY_TYPE)[-1]))

Rhode_Island_Data_LONG_2016_2017[,SCALE_SCORE := as.numeric(SCALE_SCORE)]
Rhode_Island_Data_LONG_2016_2017[,SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)]

levels(Rhode_Island_Data_LONG_2016_2017$ACHIEVEMENT_LEVEL) <- c(NA, paste("Level", levels(Rhode_Island_Data_LONG_2016_2017$ACHIEVEMENT_LEVEL)[-1]))
Rhode_Island_Data_LONG_2016_2017[,ACHIEVEMENT_LEVEL := as.character(ACHIEVEMENT_LEVEL)]

levels(Rhode_Island_Data_LONG_2016_2017$TEST_FORMAT) <- c(NA, "Online", "Paper")

###
###  Combine PSAT and PARCC data and add in vars for all 2017 data
###

# setkey(cohort, ID)
# setkey(Rhode_Island_Data_LONG_2016_2017, ID)
# Rhode_Island_Data_LONG_2016_2017 <- cohort[, list(ID, LATEST_PSAT_DATE, COHORT_YEAR)][Rhode_Island_Data_LONG_2016_2017]

Rhode_Island_Data_LONG_2016_2017 <- rbindlist(list(Rhode_Island_Data_LONG_2016_2017, Rhode_Island_Data_LONG_PSAT_2017), fill=TRUE)

Rhode_Island_Data_LONG_2016_2017[,STATE_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
Rhode_Island_Data_LONG_2016_2017[,DISTRICT_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
Rhode_Island_Data_LONG_2016_2017[,SCHOOL_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]


### CREATION of EMH_LEVEL

Rhode_Island_Data_LONG_2016_2017[,TEMP_GRADE:=GRADE_ENROLLED]
Rhode_Island_Data_LONG_2016_2017[GRADE_ENROLLED=="Other",TEMP_GRADE:="10"]
Rhode_Island_Data_LONG_2016_2017[,TEMP_GRADE:=as.numeric(TEMP_GRADE)]
Rhode_Island_Data_LONG_2016_2017[,MAX_SCHOOL_GRADE:=max(TEMP_GRADE, na.rm=TRUE), keyby=SCHOOL_NUMBER]
Rhode_Island_Data_LONG_2016_2017[MAX_SCHOOL_GRADE %in% as.character(c(3,4,5,6)), EMH_LEVEL:="Elementary"]
Rhode_Island_Data_LONG_2016_2017[MAX_SCHOOL_GRADE %in% as.character(c(7,8)), EMH_LEVEL:="Middle"]
Rhode_Island_Data_LONG_2016_2017[MAX_SCHOOL_GRADE %in% as.character(c(9,10,11,12)), EMH_LEVEL:="High"]
Rhode_Island_Data_LONG_2016_2017[,EMH_LEVEL:=as.factor(EMH_LEVEL)]
Rhode_Island_Data_LONG_2016_2017[,c("TEMP_GRADE", "MAX_SCHOOL_GRADE"):=NULL]

### Resolve duplicates

setkey(Rhode_Island_Data_LONG_2016_2017, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Rhode_Island_Data_LONG_2016_2017, VALID_CASE, CONTENT_AREA, YEAR, ID)
Rhode_Island_Data_LONG_2016_2017[which(duplicated(Rhode_Island_Data_LONG_2016_2017, by=key(Rhode_Island_Data_LONG_2016_2017)))-1, VALID_CASE:="INVALID_CASE"]

Rhode_Island_Data_LONG_2016_2017[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_2016_2017[GRADE=="11", VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_2016_2017[CONTENT_AREA=="ALGEBRA_II", VALID_CASE:="INVALID_CASE"]
setkey(Rhode_Island_Data_LONG_2016_2017, VALID_CASE, CONTENT_AREA, YEAR, ID)


### Save results

setkey(Rhode_Island_Data_LONG_2016_2017, VALID_CASE, CONTENT_AREA, YEAR, ID)
save(Rhode_Island_Data_LONG_2016_2017, file="Data/Rhode_Island_Data_LONG_2016_2017.Rdata")
