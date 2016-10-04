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

Rhode_Island_Data_LONG_2014_2015 <- as.data.table(read.spss("Data/Base_Files/2015_PARCC.sav", to.data.frame=TRUE, use.value.labels=FALSE))
Rhode_Island_Test_Format <- as.data.table(read.spss("Data/Base_Files/2015 Summative File with Test Format.sav", to.data.frame=TRUE, use.value.labels=FALSE))
load("Data/Base_Files/bad_schools.Rdata")


##########################################################
### Clean up 2014-2015 data
##########################################################

variables.to.keep <- c("assessmentYear", "responsibleDistrictIdentifier", "responsibleDistrictName", "responsibleSchoolInstitutionIdentifier",
        "responsibleSchoolInstitutionName", "parccStudentIdentifier", "stateStudentIdentifier", "firstName", "lastName", "sex", "gradeLevelWhenAssessed",
        "hispanicOrLatinoEthnicity", "americanIndianOrAlaskaNative", "asian", "blackOrAfricanAmerican", "nativeHawaiianOrOtherPacificIslander", "white", "twoOrMoreRaces",
        "federalRaceEthnicity", "englishLearner", "giftedAndTalented", "migrantStatus", "economicDisadvantageStatus", "studentWithDisabilities", "primaryDisabilityType",
        "testCode", "assessmentGrade", "subject", "summativeScaleScore", "summativeCsem", "summativePerformanceLevel")

Rhode_Island_Data_LONG_2014_2015 <- Rhode_Island_Data_LONG_2014_2015[,variables.to.keep,with=FALSE]


### Tidy Up data

variable.names.new <- c("YEAR", "DISTRICT_NUMBER", "DISTRICT_NAME", "SCHOOL_NUMBER", "SCHOOL_NAME", "ID_PARCC", "ID", "FIRST_NAME", "LAST_NAME", "GENDER", "GRADE_ENROLLED",
    "hispanicOrLatinoEthnicity", "americanIndianOrAlaskaNative", "asian", "blackOrAfricanAmerican", "nativeHawaiianOrOtherPacificIslander", "white", "twoOrMoreRaces",
    "ETHNICITY", "ELL_STATUS", "GIFTED_AND_TALENTED_STATUS", "MIGRANT_STATUS", "FREE_REDUCED_LUNCH_STATUS", "IEP_STATUS", "DISABILITY_TYPE", "testCode", "GRADE",
    "CONTENT_AREA", "SCALE_SCORE_ACTUAL", "CSEM", "ACHIEVEMENT_LEVEL")

setnames(Rhode_Island_Data_LONG_2014_2015, variable.names.new)

Rhode_Island_Data_LONG_2014_2015[,YEAR:="2014_2015"]
Rhode_Island_Data_LONG_2014_2015[,YEAR:=as.character(YEAR)]

levels(Rhode_Island_Data_LONG_2014_2015$DISTRICT_NUMBER) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2014_2015$DISTRICT_NUMBER), capwords))
Rhode_Island_Data_LONG_2014_2015[,DISTRICT_NUMBER:=as.character(DISTRICT_NUMBER)]

levels(Rhode_Island_Data_LONG_2014_2015$DISTRICT_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2014_2015$DISTRICT_NAME), capwords))

levels(Rhode_Island_Data_LONG_2014_2015$SCHOOL_NUMBER) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2014_2015$SCHOOL_NUMBER), capwords))
Rhode_Island_Data_LONG_2014_2015[,SCHOOL_NUMBER:=as.character(SCHOOL_NUMBER)]
Rhode_Island_Data_LONG_2014_2015[,SCHOOL_NUMBER:=paste(DISTRICT_NUMBER, SCHOOL_NUMBER, sep="_")]

levels(Rhode_Island_Data_LONG_2014_2015$SCHOOL_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2014_2015$SCHOOL_NAME), capwords))

Rhode_Island_Data_LONG_2014_2015[,ID_PARCC:=as.character(ID_PARCC)]

levels(Rhode_Island_Data_LONG_2014_2015$ID) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2014_2015$ID), capwords))
Rhode_Island_Data_LONG_2014_2015[,ID:=as.character(ID)]

levels(Rhode_Island_Data_LONG_2014_2015$FIRST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2014_2015$FIRST_NAME), capwords))

levels(Rhode_Island_Data_LONG_2014_2015$LAST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2014_2015$LAST_NAME), capwords))

levels(Rhode_Island_Data_LONG_2014_2015$GENDER) <- c("Female", "Male")

levels(Rhode_Island_Data_LONG_2014_2015$GRADE_ENROLLED) <- c(as.character(3:12), "Other")
Rhode_Island_Data_LONG_2014_2015[,GRADE_ENROLLED:=as.character(GRADE_ENROLLED)]

levels(Rhode_Island_Data_LONG_2014_2015$GRADE) <- c("EOCT", c("10", "11", as.character(3:9)))
Rhode_Island_Data_LONG_2014_2015[,GRADE:=as.character(GRADE)]

levels(Rhode_Island_Data_LONG_2014_2015$ETHNICITY) <- c("No Primary Race/Ethnicity Reported", "American Indian or Alaskan Native", "Asian", "Black or African American", "Hispanic or Latino", "White", "Native Hawaiian or Pacific Islander", "Multiple Ethnicities Reported")

Rhode_Island_Data_LONG_2014_2015[,c("hispanicOrLatinoEthnicity", "americanIndianOrAlaskaNative", "asian", "blackOrAfricanAmerican", "nativeHawaiianOrOtherPacificIslander", "white", "twoOrMoreRaces"):=NULL]

Rhode_Island_Data_LONG_2014_2015[ELL_STATUS==" ",ELL_STATUS:=factor(NA)]
Rhode_Island_Data_LONG_2014_2015[,ELL_STATUS:=factor(ELL_STATUS)]
levels(Rhode_Island_Data_LONG_2014_2015$ELL_STATUS) <- c("Non-English Language Learners (ELL)", "English Language Learners (ELL)")

Rhode_Island_Data_LONG_2014_2015[GIFTED_AND_TALENTED_STATUS==" ",GIFTED_AND_TALENTED_STATUS:=factor(NA)]
Rhode_Island_Data_LONG_2014_2015[,GIFTED_AND_TALENTED_STATUS:=factor(GIFTED_AND_TALENTED_STATUS)]
levels(Rhode_Island_Data_LONG_2014_2015$GIFTED_AND_TALENTED_STATUS) <- c("Gifted and Talented Status: No", "Gifted and Talented Status: Yes")

Rhode_Island_Data_LONG_2014_2015[MIGRANT_STATUS==" ",MIGRANT_STATUS:=factor(NA)]
Rhode_Island_Data_LONG_2014_2015[,MIGRANT_STATUS:=factor(MIGRANT_STATUS)]
levels(Rhode_Island_Data_LONG_2014_2015$MIGRANT_STATUS) <- c("Migrant Status: No", "Migrant Status: Yes")

Rhode_Island_Data_LONG_2014_2015[FREE_REDUCED_LUNCH_STATUS==" ",FREE_REDUCED_LUNCH_STATUS:=factor(NA)]
Rhode_Island_Data_LONG_2014_2015[,FREE_REDUCED_LUNCH_STATUS:=factor(FREE_REDUCED_LUNCH_STATUS)]
levels(Rhode_Island_Data_LONG_2014_2015$FREE_REDUCED_LUNCH_STATUS) <- c("Economically Disadvantaged", "Not Economically Disadvantaged")

Rhode_Island_Data_LONG_2014_2015[IEP_STATUS==" ",IEP_STATUS:=factor(NA)]
Rhode_Island_Data_LONG_2014_2015[,IEP_STATUS:=factor(IEP_STATUS)]
levels(Rhode_Island_Data_LONG_2014_2015$IEP_STATUS) <- c("Students without Disabilities (Non-IEP)", "Students with Disabilities (IEP)")

Rhode_Island_Data_LONG_2014_2015[DISABILITY_TYPE=="   ",DISABILITY_TYPE:=factor(NA)]
Rhode_Island_Data_LONG_2014_2015[,DISABILITY_TYPE:=factor(DISABILITY_TYPE)]
levels(Rhode_Island_Data_LONG_2014_2015$DISABILITY_TYPE) <- sapply(levels(Rhode_Island_Data_LONG_2014_2015$DISABILITY_TYPE), capwords)

Rhode_Island_Data_LONG_2014_2015[,testCode:=NULL]

levels(Rhode_Island_Data_LONG_2014_2015$CONTENT_AREA) <- toupper(as.character(sapply(levels(Rhode_Island_Data_LONG_2014_2015$CONTENT_AREA), capwords)))
levels(Rhode_Island_Data_LONG_2014_2015$CONTENT_AREA) <- gsub(" ", "_", levels(Rhode_Island_Data_LONG_2014_2015$CONTENT_AREA))
Rhode_Island_Data_LONG_2014_2015[,CONTENT_AREA:=as.character(CONTENT_AREA)]
Rhode_Island_Data_LONG_2014_2015[CONTENT_AREA=="ENGLISH_LANGUAGE_ARTS/LITERACY", CONTENT_AREA:="ELA"]

Rhode_Island_Data_LONG_2014_2015[,SCALE_SCORE_ACTUAL:=as.numeric(as.character(SCALE_SCORE_ACTUAL))]

Rhode_Island_Data_LONG_2014_2015[,CSEM:=as.numeric(as.character(CSEM))]

Rhode_Island_Data_LONG_2014_2015[ACHIEVEMENT_LEVEL==" ",ACHIEVEMENT_LEVEL:=factor(NA)]
Rhode_Island_Data_LONG_2014_2015[,ACHIEVEMENT_LEVEL:=factor(ACHIEVEMENT_LEVEL)]
levels(Rhode_Island_Data_LONG_2014_2015$ACHIEVEMENT_LEVEL) <- paste("Level", levels(Rhode_Island_Data_LONG_2014_2015$ACHIEVEMENT_LEVEL))
Rhode_Island_Data_LONG_2014_2015[,ACHIEVEMENT_LEVEL:=as.character(ACHIEVEMENT_LEVEL)]

Rhode_Island_Data_LONG_2014_2015[,STATE_ENROLLMENT_STATUS:=factor(2, levels=1:2, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
Rhode_Island_Data_LONG_2014_2015[,DISTRICT_ENROLLMENT_STATUS:=factor(2, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
Rhode_Island_Data_LONG_2014_2015[,SCHOOL_ENROLLMENT_STATUS:=factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]

setkey(bad_schools, DISTRICT_NUMBER, SCHOOL_NUMBER)
setkey(Rhode_Island_Data_LONG_2014_2015, DISTRICT_NUMBER, SCHOOL_NUMBER)
Rhode_Island_Data_LONG_2014_2015[bad_schools, SCHOOL_ENROLLMENT_STATUS:="Enrolled School: No"]

Rhode_Island_Data_LONG_2014_2015[,VALID_CASE:="VALID_CASE"]


### Resolve duplicates

setkey(Rhode_Island_Data_LONG_2014_2015, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE_ACTUAL)
setkey(Rhode_Island_Data_LONG_2014_2015, VALID_CASE, CONTENT_AREA, YEAR, ID)
Rhode_Island_Data_LONG_2014_2015[which(duplicated(Rhode_Island_Data_LONG_2014_2015))-1, VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_2014_2015[is.na(SCALE_SCORE_ACTUAL), VALID_CASE:="INVALID_CASE"]


### Add in TestFormat Variable

variables.to.keep <- c("stateStudentIdentifier", "subject", "TestFormat")
Rhode_Island_Test_Format <- Rhode_Island_Test_Format[,variables.to.keep,with=FALSE]
setnames(Rhode_Island_Test_Format, c("ID", "CONTENT_AREA", "TEST_FORMAT"))

Rhode_Island_Test_Format[,VALID_CASE:="VALID_CASE"]
levels(Rhode_Island_Test_Format$ID) <- as.character(sapply(levels(Rhode_Island_Test_Format$ID), capwords))
Rhode_Island_Test_Format[,ID:=as.character(ID)]
levels(Rhode_Island_Test_Format$CONTENT_AREA) <- c("ALGEBRA_I", "ALGEBRA_II", "ELA", "GEOMETRY", "INTEGRATED_MATHEMATICS_I", "MATHEMATICS")
Rhode_Island_Test_Format[,CONTENT_AREA:=as.character(CONTENT_AREA)]
levels(Rhode_Island_Test_Format$TEST_FORMAT) <- c("Online", "Paper")
setkey(Rhode_Island_Test_Format, VALID_CASE, CONTENT_AREA, ID)
Rhode_Island_Test_Format[which(duplicated(Rhode_Island_Test_Format))-1, VALID_CASE:="INVALID_CASE"]
Rhode_Island_Test_Format <- Rhode_Island_Test_Format[VALID_CASE=="VALID_CASE"]
setkey(Rhode_Island_Test_Format, VALID_CASE, CONTENT_AREA, ID)
setkey(Rhode_Island_Data_LONG_2014_2015, VALID_CASE, CONTENT_AREA, ID)
Rhode_Island_Data_LONG_2014_2015 <- Rhode_Island_Test_Format[Rhode_Island_Data_LONG_2014_2015]
setkey(Rhode_Island_Data_LONG_2014_2015, VALID_CASE, CONTENT_AREA, YEAR, ID)


### ADD IN THETA

tmp.PARCC <- as.data.table(read.csv("Data/Base_Files/PARCC_RI_2014-2015_SGPO_D20160513.csv", stringsAsFactors=FALSE))
tmp.PARCC.subset <- tmp.PARCC[Period=="Spring", c("PARCCStudentIdentifier", "TestCode", "IRTTheta"), with=FALSE]
setnames(tmp.PARCC.subset, c("ID_PARCC", "CONTENT_AREA", "SCALE_SCORE"))
tmp.PARCC.subset[,CONTENT_AREA:=as.factor(CONTENT_AREA)]
levels(tmp.PARCC.subset$CONTENT_AREA) <- c("ALGEBRA_I", "ALGEBRA_II", rep("ELA", 9), "GEOMETRY", rep("MATHEMATICS", 6), "INTEGRATED_MATHEMATICS_1")
tmp.PARCC.subset[,CONTENT_AREA:=as.character(CONTENT_AREA)]
tmp.PARCC.subset[,YEAR:="2014_2015"]
tmp.PARCC.subset[,VALID_CASE:="VALID_CASE"]
setkey(tmp.PARCC.subset, VALID_CASE, CONTENT_AREA, YEAR, ID_PARCC)
setkey(Rhode_Island_Data_LONG_2014_2015, VALID_CASE, CONTENT_AREA, YEAR, ID_PARCC)

Rhode_Island_Data_LONG_2014_2015 <- tmp.PARCC.subset[Rhode_Island_Data_LONG_2014_2015]
setkey(Rhode_Island_Data_LONG_2014_2015, VALID_CASE, CONTENT_AREA, YEAR, ID)
Rhode_Island_Data_LONG_2014_2015[,ID_PARCC:=NULL]

### TEMPORARY CREATION of EMH_LEVEL

Rhode_Island_Data_LONG_2014_2015[GRADE_ENROLLED %in% as.character(c(3,4,5)), EMH_LEVEL:="Elementary"]
Rhode_Island_Data_LONG_2014_2015[GRADE_ENROLLED %in% as.character(c(6,7,8)), EMH_LEVEL:="Middle"]
Rhode_Island_Data_LONG_2014_2015[GRADE_ENROLLED %in% as.character(c(9,10,11,12)), EMH_LEVEL:="High"]
Rhode_Island_Data_LONG_2014_2015[,EMH_LEVEL:=as.factor(EMH_LEVEL)]


### Save results

save(Rhode_Island_Data_LONG_2014_2015, file="Data/Rhode_Island_Data_LONG_2014_2015.Rdata")
