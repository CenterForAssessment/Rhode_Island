##############################################################
###
### Script for creating Rhode_Island_Data_LONG_2015_2016
###
##############################################################

### Load SGP and data.table

require(SGP)
require(data.table)


### Load data

Rhode_Island_Data_LONG_2015_2016 <- fread("Data/Base_Files/2016_PARCC_071416.csv")
load("Data/Base_Files/bad_schools.Rdata")


##########################################################
### Clean up 2015-2016 data
##########################################################

variables.to.keep <- c("AssessmentYear", "ResponsibleDistrictCode", "ResponsibleDistrictName", "ResponsibleSchoolCode",
        "ResponsibleSchoolName", "StateStudentIdentifier", "TestFormat", "FirstName", "LastOrSurname", "Sex", "GradeLevelWhenAssessed",
        "HispanicOrLatinoEthnicity", "AmericanIndianOrAlaskaNative ", "Asian", "BlackOrAfricanAmerican", "NativeHawaiianOrOtherPacificIslander", "White", "TwoOrMoreRaces",
        "FederalRaceEthnicity", "EnglishLearnerEL", "GiftedandTalented", "MigrantStatus", "EconomicDisadvantageStatus", "StudentWithDisabilities ", "PrimaryDisabilityType",
        "TestCode", "AssessmentGrade", "Subject", "TestScaleScore", "IRTTheta", "TestPerformanceLevel")

Rhode_Island_Data_LONG_2015_2016 <- Rhode_Island_Data_LONG_2015_2016[,variables.to.keep,with=FALSE]


### Tidy Up data

variable.names.new <- c("YEAR", "DISTRICT_NUMBER", "DISTRICT_NAME", "SCHOOL_NUMBER", "SCHOOL_NAME", "ID", "TEST_FORMAT", "FIRST_NAME", "LAST_NAME", "GENDER", "GRADE_ENROLLED",
    "hispanicOrLatinoEthnicity", "americanIndianOrAlaskaNative", "asian", "blackOrAfricanAmerican", "nativeHawaiianOrOtherPacificIslander", "white", "twoOrMoreRaces",
    "ETHNICITY", "ELL_STATUS", "GIFTED_AND_TALENTED_STATUS", "MIGRANT_STATUS", "FREE_REDUCED_LUNCH_STATUS", "IEP_STATUS", "DISABILITY_TYPE", "testCode", "GRADE",
    "CONTENT_AREA", "SCALE_SCORE_ACTUAL", "SCALE_SCORE", "ACHIEVEMENT_LEVEL")

setnames(Rhode_Island_Data_LONG_2015_2016, variable.names.new)

Rhode_Island_Data_LONG_2015_2016[,YEAR:="2015_2016"]

Rhode_Island_Data_LONG_2015_2016[,DISTRICT_NAME:=as.factor(DISTRICT_NAME)]
levels(Rhode_Island_Data_LONG_2015_2016$DISTRICT_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2015_2016$DISTRICT_NAME), capwords))

Rhode_Island_Data_LONG_2015_2016[,SCHOOL_NAME:=as.factor(SCHOOL_NAME)]
levels(Rhode_Island_Data_LONG_2015_2016$SCHOOL_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2015_2016$SCHOOL_NAME), capwords))

Rhode_Island_Data_LONG_2015_2016[,SCHOOL_NUMBER:=paste(DISTRICT_NUMBER, SCHOOL_NUMBER, sep="_")]

Rhode_Island_Data_LONG_2015_2016[,FIRST_NAME:=as.factor(FIRST_NAME)]
levels(Rhode_Island_Data_LONG_2015_2016$FIRST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2015_2016$FIRST_NAME), capwords))

Rhode_Island_Data_LONG_2015_2016[,LAST_NAME:=as.factor(LAST_NAME)]
levels(Rhode_Island_Data_LONG_2015_2016$LAST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2015_2016$LAST_NAME), capwords))

Rhode_Island_Data_LONG_2015_2016[,GENDER:=as.factor(GENDER)]
levels(Rhode_Island_Data_LONG_2015_2016$GENDER) <- c("Female", "Male")

Rhode_Island_Data_LONG_2015_2016[,GRADE_ENROLLED:=as.character(as.numeric(GRADE_ENROLLED))]

Rhode_Island_Data_LONG_2015_2016[,GRADE:=as.factor(GRADE)]
levels(Rhode_Island_Data_LONG_2015_2016$GRADE) <- c("EOCT", c("10", "11", as.character(3:9)))
Rhode_Island_Data_LONG_2015_2016[,GRADE:=as.character(GRADE)]

Rhode_Island_Data_LONG_2015_2016[,ETHNICITY:=as.factor(ETHNICITY)]
levels(Rhode_Island_Data_LONG_2015_2016$ETHNICITY) <- c("No Primary Race/Ethnicity Reported", "American Indian or Alaskan Native", "Asian", "Black or African American", "Hispanic or Latino", "White", "Native Hawaiian or Pacific Islander", "Multiple Ethnicities Reported")

Rhode_Island_Data_LONG_2015_2016[,c("hispanicOrLatinoEthnicity", "americanIndianOrAlaskaNative", "asian", "blackOrAfricanAmerican", "nativeHawaiianOrOtherPacificIslander", "white", "twoOrMoreRaces"):=NULL]

Rhode_Island_Data_LONG_2015_2016[ELL_STATUS=="",ELL_STATUS:=NA]
Rhode_Island_Data_LONG_2015_2016[,ELL_STATUS:=as.factor(ELL_STATUS)]
levels(Rhode_Island_Data_LONG_2015_2016$ELL_STATUS) <- c("Non-English Language Learners (ELL)", "English Language Learners (ELL)")

Rhode_Island_Data_LONG_2015_2016[GIFTED_AND_TALENTED_STATUS=="",GIFTED_AND_TALENTED_STATUS:=NA]
Rhode_Island_Data_LONG_2015_2016[,GIFTED_AND_TALENTED_STATUS:=factor(GIFTED_AND_TALENTED_STATUS)]
levels(Rhode_Island_Data_LONG_2015_2016$GIFTED_AND_TALENTED_STATUS) <- c("Gifted and Talented Status: No", "Gifted and Talented Status: Yes")

Rhode_Island_Data_LONG_2015_2016[MIGRANT_STATUS=="",MIGRANT_STATUS:=NA]
Rhode_Island_Data_LONG_2015_2016[,MIGRANT_STATUS:=factor(MIGRANT_STATUS)]
levels(Rhode_Island_Data_LONG_2015_2016$MIGRANT_STATUS) <- c("Migrant Status: No", "Migrant Status: Yes")

Rhode_Island_Data_LONG_2015_2016[FREE_REDUCED_LUNCH_STATUS=="",FREE_REDUCED_LUNCH_STATUS:=NA]
Rhode_Island_Data_LONG_2015_2016[,FREE_REDUCED_LUNCH_STATUS:=factor(FREE_REDUCED_LUNCH_STATUS)]
levels(Rhode_Island_Data_LONG_2015_2016$FREE_REDUCED_LUNCH_STATUS) <- c("Economically Disadvantaged", "Not Economically Disadvantaged")

Rhode_Island_Data_LONG_2015_2016[IEP_STATUS=="",IEP_STATUS:=NA]
Rhode_Island_Data_LONG_2015_2016[,IEP_STATUS:=factor(IEP_STATUS)]
levels(Rhode_Island_Data_LONG_2015_2016$IEP_STATUS) <- c("Students with 504 Plan", "Students with Disabilities (IEP)", "Students without Disabilities (Non-IEP)")

Rhode_Island_Data_LONG_2015_2016[DISABILITY_TYPE=="",DISABILITY_TYPE:=NA]
Rhode_Island_Data_LONG_2015_2016[,DISABILITY_TYPE:=factor(DISABILITY_TYPE)]
levels(Rhode_Island_Data_LONG_2015_2016$DISABILITY_TYPE) <- sapply(levels(Rhode_Island_Data_LONG_2015_2016$DISABILITY_TYPE), capwords)

Rhode_Island_Data_LONG_2015_2016[,testCode:=NULL]

Rhode_Island_Data_LONG_2015_2016[,CONTENT_AREA:=factor(CONTENT_AREA)]
levels(Rhode_Island_Data_LONG_2015_2016$CONTENT_AREA) <- toupper(as.character(sapply(levels(Rhode_Island_Data_LONG_2015_2016$CONTENT_AREA), capwords)))
levels(Rhode_Island_Data_LONG_2015_2016$CONTENT_AREA) <- gsub(" ", "_", levels(Rhode_Island_Data_LONG_2015_2016$CONTENT_AREA))
Rhode_Island_Data_LONG_2015_2016[,CONTENT_AREA:=as.character(CONTENT_AREA)]
Rhode_Island_Data_LONG_2015_2016[CONTENT_AREA=="ENGLISH_LANGUAGE_ARTS/LITERACY", CONTENT_AREA:="ELA"]

Rhode_Island_Data_LONG_2015_2016[,SCALE_SCORE_ACTUAL:=as.numeric(SCALE_SCORE_ACTUAL)]

Rhode_Island_Data_LONG_2015_2016[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

Rhode_Island_Data_LONG_2015_2016[ACHIEVEMENT_LEVEL=="",ACHIEVEMENT_LEVEL:=NA]
Rhode_Island_Data_LONG_2015_2016[,ACHIEVEMENT_LEVEL:=factor(ACHIEVEMENT_LEVEL)]
levels(Rhode_Island_Data_LONG_2015_2016$ACHIEVEMENT_LEVEL) <- paste("Level", levels(Rhode_Island_Data_LONG_2015_2016$ACHIEVEMENT_LEVEL))
Rhode_Island_Data_LONG_2015_2016[,ACHIEVEMENT_LEVEL:=as.character(ACHIEVEMENT_LEVEL)]

Rhode_Island_Data_LONG_2015_2016[,TEST_FORMAT:=factor(TEST_FORMAT)]
levels(Rhode_Island_Data_LONG_2015_2016$TEST_FORMAT) <- c("Online", "Paper")

Rhode_Island_Data_LONG_2015_2016[,STATE_ENROLLMENT_STATUS:=factor(2, levels=1:2, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
Rhode_Island_Data_LONG_2015_2016[,DISTRICT_ENROLLMENT_STATUS:=factor(2, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
Rhode_Island_Data_LONG_2015_2016[,SCHOOL_ENROLLMENT_STATUS:=factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]

setkey(bad_schools, DISTRICT_NUMBER, SCHOOL_NUMBER)
setkey(Rhode_Island_Data_LONG_2015_2016, DISTRICT_NUMBER, SCHOOL_NUMBER)
Rhode_Island_Data_LONG_2015_2016[bad_schools, SCHOOL_ENROLLMENT_STATUS:="Enrolled School: No"]

Rhode_Island_Data_LONG_2015_2016[,VALID_CASE:="VALID_CASE"]

### TEMPORARY CREATION of EMH_LEVEL

Rhode_Island_Data_LONG_2015_2016[GRADE_ENROLLED %in% as.character(c(3,4,5)), EMH_LEVEL:="Elementary"]
Rhode_Island_Data_LONG_2015_2016[GRADE_ENROLLED %in% as.character(c(6,7,8)), EMH_LEVEL:="Middle"]
Rhode_Island_Data_LONG_2015_2016[GRADE_ENROLLED %in% as.character(c(9,10,11,12)), EMH_LEVEL:="High"]
Rhode_Island_Data_LONG_2015_2016[,EMH_LEVEL:=as.factor(EMH_LEVEL)]


### Resolve duplicates

setkey(Rhode_Island_Data_LONG_2015_2016, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Rhode_Island_Data_LONG_2015_2016, VALID_CASE, CONTENT_AREA, YEAR, ID)
Rhode_Island_Data_LONG_2015_2016[which(duplicated(Rhode_Island_Data_LONG_2015_2016))-1, VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_2015_2016[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]
setkey(Rhode_Island_Data_LONG_2015_2016, VALID_CASE, CONTENT_AREA, YEAR, ID)


### Save results

save(Rhode_Island_Data_LONG_2015_2016, file="Data/Rhode_Island_Data_LONG_2015_2016.Rdata")
