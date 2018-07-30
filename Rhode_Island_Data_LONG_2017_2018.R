####################################################################
###                                                              ###
###   Script for creating Rhode Island LONG Data for 2017_2018   ###
###                                                              ###
####################################################################

####
##    PSAT/SAT Long Data
####

### Load required packages

require(SGP)
require(data.table)

### Load data

Rhode_Island_Data_PSAT_2018 <- fread("~/Dropbox (SGP)/SGP/Rhode_Island/Data/Base_Files/PSAT10 Final Student Score File 7.3.2018.csv", stringsAsFactors=FALSE)
setnames(Rhode_Island_Data_PSAT_2018, gsub(" ", "_", names(Rhode_Island_Data_PSAT_2018)))

Rhode_Island_Data_SAT_2018 <- fread("~/Dropbox (SGP)/SGP/Rhode_Island/Data/Base_Files/SAT Final Student Score File 7.3.2018.csv", stringsAsFactors=FALSE)
setnames(Rhode_Island_Data_SAT_2018, gsub(" ", "_", names(Rhode_Island_Data_SAT_2018)))
setnames(Rhode_Island_Data_SAT_2018, "STUDENT_LAST_OR_SURNAME", "STUDENT_LAST")


##########################################################
###   Clean up 2018 PSAT data
##########################################################

variables.to.keep <- c("SECONDARY_SCHOOL_STUDENT_ID", "STUDENT_FIRST_NAME", "STUDENT_LAST", "SEX", "DERIVED_AGGREGATE_RACE_ETHNICITY", "ACCOMMODATIONS_USED", # "COLLEGE_BOARD_STUDENT_ID",
        "TOTAL_SCORE", "EVIDENCE_BASED_READING_AND_WRITING_SECTION_SCORE", "MATH_SECTION_SCORE", "COHORT_YEAR", "INVALIDATED_SCORE", "STUDENT_PARTICIPATED_INDICATOR",
        "DISTRICT_CODE", "DISTRICT_NAME", "STATE_ORGANIZATION_CODE", "RESPONSIBLE_ATTENDING_INSTITUTION_NAME") #, "LATEST_PSAT_DATE")

Rhode_Island_Data_PSAT_2018<- Rhode_Island_Data_PSAT_2018[, variables.to.keep, with=FALSE]
Rhode_Island_Data_SAT_2018 <- Rhode_Island_Data_SAT_2018[, variables.to.keep, with=FALSE]


###  Identify VALID_CASEs and merge PSAT & SAT data sets

##  Ignore COHORT_YEAR per Ana K 7/23 email
# Rhode_Island_Data_PSAT_2018[, VALID_CASE := "VALID_CASE"]
# Rhode_Island_Data_PSAT_2018[COHORT_YEAR != "2020", VALID_CASE := "INVALID_CASE"]
#
# Rhode_Island_Data_SAT_2018[, VALID_CASE := "VALID_CASE"]
# Rhode_Island_Data_SAT_2018[COHORT_YEAR != "2019", VALID_CASE := "INVALID_CASE"]

#  Rhode_Island_Data_PSAT_2018[INVALIDATED_SCORE == "Y", VALID_CASE := "INVALID_CASE"]  #  Verify if this is in the Final data.  Ask Ana about it???


variable.names.new <- c("ID", "FIRST_NAME", "LAST_NAME", "GENDER", "ETHNICITY", "IEP_STATUS",
        "PSAT_TOTAL", "ELA_PSAT_10", "MATHEMATICS_PSAT_10", "COHORT_YEAR", "INVALIDATED_SCORE", "STUDENT_PARTICIPATED_INDICATOR",
        "DISTRICT_NUMBER", "DISTRICT_NAME", "SCHOOL_NUMBER", "SCHOOL_NAME", "VALID_CASE")

setnames(Rhode_Island_Data_PSAT_2018, variable.names.new)
setnames(Rhode_Island_Data_SAT_2018, gsub("PSAT", "SAT", variable.names.new))

Rhode_Island_Data_PSAT_SAT <- rbindlist(list(Rhode_Island_Data_PSAT_2018, Rhode_Island_Data_SAT_2018), fill = TRUE)

### Tidy Up data

Rhode_Island_Data_PSAT_SAT[, YEAR := "2017_2018"]
Rhode_Island_Data_PSAT_SAT[, GRADE := "EOCT"]

Rhode_Island_Data_PSAT_SAT[, LAST_NAME := factor(LAST_NAME)]
levels(Rhode_Island_Data_PSAT_SAT$LAST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_PSAT_SAT$LAST_NAME), capwords))

Rhode_Island_Data_PSAT_SAT[, FIRST_NAME := factor(FIRST_NAME)]
levels(Rhode_Island_Data_PSAT_SAT$FIRST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_PSAT_SAT$FIRST_NAME), capwords))

Rhode_Island_Data_PSAT_SAT[, GENDER := factor(GENDER)]
levels(Rhode_Island_Data_PSAT_SAT$GENDER) <- c("Female", "Male", NA)

# https://secure-media.collegeboard.org/digitalServices/pdf/ap/ap-guide-to-race-ethnicity-reporting-schools-districts-2016.pdf
Rhode_Island_Data_PSAT_SAT[, ETHNICITY := factor(ETHNICITY)]
levels(Rhode_Island_Data_PSAT_SAT$ETHNICITY) <- c("No Primary Race/Ethnicity Reported", "American Indian or Alaskan Native", "Asian", "Black or African American", "Hispanic or Latino", "Native Hawaiian or Pacific Islander", "White", "Multiple Ethnicities Reported")

Rhode_Island_Data_PSAT_SAT[, IEP_STATUS := factor(IEP_STATUS)]
levels(Rhode_Island_Data_PSAT_SAT$IEP_STATUS) <- c("Students without Disabilities (Non-IEP)", "Students with Disabilities (IEP)")


###  Combine content areas into single LONG file

Rhode_Island_Data_LONG_SAT_2017_2018 <- rbindlist(list(
      Rhode_Island_Data_PSAT_SAT[, SCALE_SCORE := MATHEMATICS_PSAT_10][!is.na(SCALE_SCORE), list(VALID_CASE, ID, YEAR, GRADE, FIRST_NAME, LAST_NAME, GENDER, ETHNICITY, SCALE_SCORE)][, CONTENT_AREA := "MATHEMATICS_PSAT_10"],
      Rhode_Island_Data_PSAT_SAT[, SCALE_SCORE := ELA_PSAT_10][!is.na(SCALE_SCORE), list(VALID_CASE, ID, YEAR, GRADE, FIRST_NAME, LAST_NAME, GENDER, ETHNICITY, SCALE_SCORE)][, CONTENT_AREA := "ELA_PSAT_10"],
      Rhode_Island_Data_PSAT_SAT[, SCALE_SCORE := MATHEMATICS_SAT][!is.na(SCALE_SCORE), list(VALID_CASE, ID, YEAR, GRADE, FIRST_NAME, LAST_NAME, GENDER, ETHNICITY, SCALE_SCORE)][, CONTENT_AREA := "MATHEMATICS_SAT"],
      Rhode_Island_Data_PSAT_SAT[, SCALE_SCORE := ELA_SAT][!is.na(SCALE_SCORE), list(VALID_CASE, ID, YEAR, GRADE, FIRST_NAME, LAST_NAME, GENDER, ETHNICITY, SCALE_SCORE)][, CONTENT_AREA := "ELA_SAT"]#,
      # Rhode_Island_Data_PSAT_SAT[, SCALE_SCORE := PSAT_TOTAL][,list(ID, YEAR, FIRST_NAME, LAST_NAME, GENDER, ETHNICITY, SCALE_SCORE)][, CONTENT_AREA := "PSAT_TOTAL"]
))

Rhode_Island_Data_LONG_SAT_2017_2018 <- Rhode_Island_Data_LONG_SAT_2017_2018[!is.na(ID)]


###  Duplicates in prelimimary data!

setkey(Rhode_Island_Data_LONG_SAT_2017_2018, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE)
setkey(Rhode_Island_Data_LONG_SAT_2017_2018, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# dups <- Rhode_Island_Data_LONG_SAT_2017_2018[c(which(duplicated(Rhode_Island_Data_LONG_SAT_2017_2018, by=key(Rhode_Island_Data_LONG_SAT_2017_2018)))-1, which(duplicated(Rhode_Island_Data_LONG_SAT_2017_2018, by=key(Rhode_Island_Data_LONG_SAT_2017_2018)))),]
# setkeyv(dups, key(Rhode_Island_Data_LONG_SAT_2017_2018))
Rhode_Island_Data_LONG_SAT_2017_2018[which(duplicated(Rhode_Island_Data_LONG_SAT_2017_2018, by=key(Rhode_Island_Data_LONG_SAT_2017_2018)))-1, VALID_CASE := "INVALID_CASE"]
table(Rhode_Island_Data_LONG_SAT_2017_2018$VALID_CASE)


### Save results

setkey(Rhode_Island_Data_LONG_SAT_2017_2018, VALID_CASE, CONTENT_AREA, YEAR, ID)
save(Rhode_Island_Data_LONG_SAT_2017_2018, file="Data/Rhode_Island_Data_LONG_SAT_2017_2018.Rdata")


##########################################################
###   Clean up 2017-2018 PARCC data
##########################################################

variables.to.keep <- c("ResponsibleDistrictCode", "ResponsibleSchoolCode",
        "StateStudentIdentifier", "TestFormat", "FirstName", "LastOrSurname", "Sex", "GradeLevelWhenAssessed",
        "FederalRaceEthnicity", "EnglishLearnerEL", "EconomicDisadvantageStatus", "StudentWithDisabilities", "PrimaryDisabilityType",
        "TestCode", "TestScaleScore", "IRTTheta", "TestPerformanceLevel") # No "GiftedandTalented", "MigrantStatus",  - maybe one of the "StateField*" vars ?

Rhode_Island_Data_LONG_2017_2018 <- Rhode_Island_Data_LONG_2017_2018[, variables.to.keep, with=FALSE]

variable.names.new <- c("DISTRICT_NUMBER", "SCHOOL_NUMBER", "ID", "TEST_FORMAT", "FIRST_NAME", "LAST_NAME", "GENDER", "GRADE_ENROLLED",
    "ETHNICITY", "ELL_STATUS", "FREE_REDUCED_LUNCH_STATUS", "IEP_STATUS", "DISABILITY_TYPE", "TestCode",
    "SCALE_SCORE_ACTUAL", "SCALE_SCORE", "ACHIEVEMENT_LEVEL") # "GIFTED_AND_TALENTED_STATUS", "MIGRANT_STATUS",

setnames(Rhode_Island_Data_LONG_2017_2018, variable.names.new)

### Tidy Up data

Rhode_Island_Data_LONG_2017_2018[, ID := as.character(ID)]
Rhode_Island_Data_LONG_2017_2018[, YEAR := "2017_2018"]
Rhode_Island_Data_LONG_2017_2018[, VALID_CASE := "VALID_CASE"]

####  CONTENT_AREA from TestCode
Rhode_Island_Data_LONG_2017_2018[, CONTENT_AREA := factor(TestCode)]
levels(Rhode_Island_Data_LONG_2017_2018$CONTENT_AREA) <- c("AAELA", "AAMAT", "ALGEBRA_I", "ALGEBRA_II", rep("ELA", 7), "GEOMETRY", rep("MATHEMATICS", 6))
Rhode_Island_Data_LONG_2017_2018[, CONTENT_AREA := as.character(CONTENT_AREA)]

####  GRADE from TestCode
Rhode_Island_Data_LONG_2017_2018[, GRADE := gsub("ELA|MAT", "", TestCode)]
Rhode_Island_Data_LONG_2017_2018[, GRADE := as.character(as.numeric(GRADE))]
Rhode_Island_Data_LONG_2017_2018[which(is.na(GRADE)), GRADE := "EOCT"]
Rhode_Island_Data_LONG_2017_2018[, GRADE := as.character(GRADE)]
# table(Rhode_Island_Data_LONG_2017_2018[, GRADE, TestCode])

Rhode_Island_Data_LONG_2017_2018[, TestCode := NULL]

Rhode_Island_Data_LONG_2017_2018[, SCHOOL_NUMBER:=paste(DISTRICT_NUMBER, SCHOOL_NUMBER, sep="_")]

levels(Rhode_Island_Data_LONG_2017_2018$FIRST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2017_2018$FIRST_NAME), capwords))
levels(Rhode_Island_Data_LONG_2017_2018$LAST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2017_2018$LAST_NAME), capwords))

levels(Rhode_Island_Data_LONG_2017_2018$GENDER) <- c("Female", "Male")
levels(Rhode_Island_Data_LONG_2017_2018$ETHNICITY) <- c("American Indian or Alaskan Native", "Asian", "Black or African American", "Hispanic or Latino", "Native Hawaiian or Pacific Islander", "White", "Multiple Ethnicities Reported", "No Primary Race/Ethnicity Reported")
Rhode_Island_Data_LONG_2017_2018[,ETHNICITY := as.character(ETHNICITY)]
levels(Rhode_Island_Data_LONG_2017_2018$ELL_STATUS) <- c(NA, "Non-English Language Learners (ELL)", "English Language Learners (ELL)")
levels(Rhode_Island_Data_LONG_2017_2018$FREE_REDUCED_LUNCH_STATUS) <- c(NA, "Not Economically Disadvantaged", "Economically Disadvantaged")
levels(Rhode_Island_Data_LONG_2017_2018$IEP_STATUS) <- c(NA, "Students with 504 Plan", "B", "Students with Disabilities (IEP)", "Students without Disabilities (Non-IEP)", "Students without Disabilities (Non-IEP)")
levels(Rhode_Island_Data_LONG_2017_2018$DISABILITY_TYPE) <- c(NA, Literasee:::trimWhiteSpace(levels(Rhode_Island_Data_LONG_2017_2018$DISABILITY_TYPE)[-1]))

Rhode_Island_Data_LONG_2017_2018[,SCALE_SCORE := as.numeric(SCALE_SCORE)]
Rhode_Island_Data_LONG_2017_2018[,SCALE_SCORE_ACTUAL := as.numeric(SCALE_SCORE_ACTUAL)]

levels(Rhode_Island_Data_LONG_2017_2018$ACHIEVEMENT_LEVEL) <- c(NA, paste("Level", levels(Rhode_Island_Data_LONG_2017_2018$ACHIEVEMENT_LEVEL)[-1]))
Rhode_Island_Data_LONG_2017_2018[,ACHIEVEMENT_LEVEL := as.character(ACHIEVEMENT_LEVEL)]

levels(Rhode_Island_Data_LONG_2017_2018$TEST_FORMAT) <- c(NA, "Online", "Paper")

###
###  Combine PSAT and PARCC data and add in vars for all 2017 data
###

# setkey(cohort, ID)
# setkey(Rhode_Island_Data_LONG_2017_2018, ID)
# Rhode_Island_Data_LONG_2017_2018 <- cohort[, list(ID, LATEST_PSAT_DATE, COHORT_YEAR)][Rhode_Island_Data_LONG_2017_2018]

Rhode_Island_Data_LONG_2017_2018 <- rbindlist(list(Rhode_Island_Data_LONG_2017_2018, Rhode_Island_Data_LONG_SAT_2017_2018), fill=TRUE)

Rhode_Island_Data_LONG_2017_2018[,STATE_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
Rhode_Island_Data_LONG_2017_2018[,DISTRICT_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
Rhode_Island_Data_LONG_2017_2018[,SCHOOL_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]


### CREATION of EMH_LEVEL

Rhode_Island_Data_LONG_2017_2018[,TEMP_GRADE:=GRADE_ENROLLED]
Rhode_Island_Data_LONG_2017_2018[GRADE_ENROLLED=="Other",TEMP_GRADE:="10"]
Rhode_Island_Data_LONG_2017_2018[,TEMP_GRADE:=as.numeric(TEMP_GRADE)]
Rhode_Island_Data_LONG_2017_2018[,MAX_SCHOOL_GRADE:=max(TEMP_GRADE, na.rm=TRUE), keyby=SCHOOL_NUMBER]
Rhode_Island_Data_LONG_2017_2018[MAX_SCHOOL_GRADE %in% as.character(c(3,4,5,6)), EMH_LEVEL:="Elementary"]
Rhode_Island_Data_LONG_2017_2018[MAX_SCHOOL_GRADE %in% as.character(c(7,8)), EMH_LEVEL:="Middle"]
Rhode_Island_Data_LONG_2017_2018[MAX_SCHOOL_GRADE %in% as.character(c(9,10,11,12)), EMH_LEVEL:="High"]
Rhode_Island_Data_LONG_2017_2018[,EMH_LEVEL:=as.factor(EMH_LEVEL)]
Rhode_Island_Data_LONG_2017_2018[,c("TEMP_GRADE", "MAX_SCHOOL_GRADE"):=NULL]

### Resolve duplicates

setkey(Rhode_Island_Data_LONG_2017_2018, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Rhode_Island_Data_LONG_2017_2018, VALID_CASE, CONTENT_AREA, YEAR, ID)
Rhode_Island_Data_LONG_2017_2018[which(duplicated(Rhode_Island_Data_LONG_2017_2018, by=key(Rhode_Island_Data_LONG_2017_2018)))-1, VALID_CASE:="INVALID_CASE"]

Rhode_Island_Data_LONG_2017_2018[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_2017_2018[GRADE=="11", VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_2017_2018[CONTENT_AREA=="ALGEBRA_II", VALID_CASE:="INVALID_CASE"]
setkey(Rhode_Island_Data_LONG_2017_2018, VALID_CASE, CONTENT_AREA, YEAR, ID)


### Save results

setkey(Rhode_Island_Data_LONG_2017_2018, VALID_CASE, CONTENT_AREA, YEAR, ID)
save(Rhode_Island_Data_LONG_2017_2018, file="Data/Rhode_Island_Data_LONG_2017_2018.Rdata")
