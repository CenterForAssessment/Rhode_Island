####################################################################
###                                                              ###
###   Script for creating Rhode Island LONG Data for 2020_2021   ###
###                                                              ###
####################################################################

##########################################################
####
##    RICAS Long Data
####
##########################################################

###   Load required packages
require(data.table)

###   Load Data
#Rhode_Island_Data_LONG_RICAS_2020_2021 <- fread("Data/Base_Files/RICAS2021_prediscrepancy.csv", stringsAsFactors=FALSE)
Rhode_Island_Data_LONG_RICAS_2020_2021 <- fread("Data/Base_Files/RICAS2021.csv", stringsAsFactors=FALSE)

### Cleanup data
variables.to.keep <- c( # paste(unlist(names(Rhode_Island_Data_LONG_RICAS_2020_2021)[c(1:62)]), collapse="', '")
      "sasid", "lastname", "firstname", "mi", "grade", "stugrade",
      "resp_discode", "resp_schcode", "resp_disname", "resp_schname", "resp_schlevel",
      "escaleds", "eperflev", "e_ssSEM", "e_theta", "e_thetaSEM", "emode",
      "mscaleds", "mperflev", "m_ssSEM", "m_theta", "m_thetaSEM", "mmode",
      "AIAN", "asian", "BAA", "hispanic", "NHOPI", "white", "tworaces",
      "gender", "ecodis", "ELL", "IEP", "plan504", "enonacc")

variable.names.new <- c(
      "ID", "LAST_NAME", "FIRST_NAME", "MIDDLE_INITIAL", "GRADE", "GRADE_ENROLLED",
      "DISTRICT_NUMBER", "SCHOOL_NUMBER", "DISTRICT_NAME", "SCHOOL_NAME", "EMH_LEVEL",
      "SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL", "SCALE_SCORE_ACTUAL_CSEM", "SCALE_SCORE", "SCALE_SCORE_CSEM", "TEST_FORMAT",
      "GENDER", "FREE_REDUCED_LUNCH_STATUS", "ELL_STATUS", "IEP_STATUS", "enonacc",
      "ETHNICITY", "CONTENT_AREA") #  These two added later

Rhode_Island_Data_LONG_RICAS_2020_2021 <- Rhode_Island_Data_LONG_RICAS_2020_2021[, variables.to.keep, with=FALSE]

factor.vars <- c("gender", "ecodis", "ELL", "IEP", "lastname", "firstname", "resp_schlevel", "emode", "mmode", "eperflev", "mperflev")
for(v in factor.vars) Rhode_Island_Data_LONG_RICAS_2020_2021[, (v) := factor(eval(parse(text=v)))]

#ACHIEVEMENT_LEVEL, TEST_FORMAT, EMH_LEVEL
###   Create single ETHNICITY variable
Rhode_Island_Data_LONG_RICAS_2020_2021[, ETHNICITY := as.character(NA)]
Rhode_Island_Data_LONG_RICAS_2020_2021[, grade := as.character(grade)]
Rhode_Island_Data_LONG_RICAS_2020_2021[AIAN == "Y", ETHNICITY := "American Indian or Alaskan Native"]
Rhode_Island_Data_LONG_RICAS_2020_2021[asian == "Y", ETHNICITY := "Asian"]
Rhode_Island_Data_LONG_RICAS_2020_2021[BAA == "Y", ETHNICITY := "Black or African American"]
Rhode_Island_Data_LONG_RICAS_2020_2021[hispanic == "Y", ETHNICITY := "Hispanic or Latino"]
Rhode_Island_Data_LONG_RICAS_2020_2021[NHOPI == "Y", ETHNICITY := "Native Hawaiian or Pacific Islander"]
Rhode_Island_Data_LONG_RICAS_2020_2021[white == "Y", ETHNICITY := "White"]
Rhode_Island_Data_LONG_RICAS_2020_2021[tworaces == "Y", ETHNICITY := "Multiple Ethnicities Reported"]
Rhode_Island_Data_LONG_RICAS_2020_2021[is.na(ETHNICITY), ETHNICITY := "No Primary Race/Ethnicity Reported"]

Rhode_Island_Data_LONG_RICAS_2020_2021[, c("AIAN", "asian", "BAA", "hispanic", "NHOPI", "white", "tworaces") := NULL] # enonacc

###   Other Demographic Variables
Rhode_Island_Data_LONG_RICAS_2020_2021[plan504 == "Y", IEP := "Students with 504 Plan"]
Rhode_Island_Data_LONG_RICAS_2020_2021[, plan504 := NULL]
levels(Rhode_Island_Data_LONG_RICAS_2020_2021$IEP) <- c("Students without Disabilities (Non-IEP)", "Students with Disabilities (IEP)", "Students with 504 Plan")

levels(Rhode_Island_Data_LONG_RICAS_2020_2021$gender) <- c(NA, "Female", "Male", "Other")
levels(Rhode_Island_Data_LONG_RICAS_2020_2021$ecodis) <- c("Not Economically Disadvantaged", "Economically Disadvantaged")
levels(Rhode_Island_Data_LONG_RICAS_2020_2021$ELL) <- c("Non-English Language Learners (ELL)", "English Language Learners (ELL)")

###   Student Names
levels(Rhode_Island_Data_LONG_RICAS_2020_2021$lastname) <- as.character(sapply(levels(Rhode_Island_Data_LONG_RICAS_2020_2021$lastname), SGP::capwords))
levels(Rhode_Island_Data_LONG_RICAS_2020_2021$firstname) <- as.character(sapply(levels(Rhode_Island_Data_LONG_RICAS_2020_2021$firstname), SGP::capwords))


###   Create LONG file - remove other set of content area scores and establish CONTENT_AREA variable
ela <- copy(Rhode_Island_Data_LONG_RICAS_2020_2021)[, c("mscaleds", "mperflev", "m_ssSEM", "m_theta", "m_thetaSEM", "mmode") := NULL][, CONTENT_AREA := "ELA"]
mat <- copy(Rhode_Island_Data_LONG_RICAS_2020_2021)[, c("escaleds", "eperflev", "e_ssSEM", "e_theta", "e_thetaSEM", "emode") := NULL][, CONTENT_AREA := "MATHEMATICS"]

setnames(ela, variable.names.new)
setnames(mat, variable.names.new)

Rhode_Island_Data_LONG_RICAS_2020_2021 <- rbindlist(list(ela, mat))


###   Tidy Up data

Rhode_Island_Data_LONG_RICAS_2020_2021[, ID := as.character(ID)]
Rhode_Island_Data_LONG_RICAS_2020_2021[, YEAR := "2020_2021"]
Rhode_Island_Data_LONG_RICAS_2020_2021[, VALID_CASE := "VALID_CASE"]

Rhode_Island_Data_LONG_RICAS_2020_2021[is.na(ID), VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_RICAS_2020_2021[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_RICAS_2020_2021[DISTRICT_NUMBER=="D23334", VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_RICAS_2020_2021[,enonacc := NULL]

levels(Rhode_Island_Data_LONG_RICAS_2020_2021$ACHIEVEMENT_LEVEL) <- c("Not Meeting Expectations", "Partially Meeting Expectations", "Meeting Expectations", "Exceeding Expectations")
Rhode_Island_Data_LONG_RICAS_2020_2021[,ACHIEVEMENT_LEVEL := as.character(ACHIEVEMENT_LEVEL)]

levels(Rhode_Island_Data_LONG_RICAS_2020_2021$TEST_FORMAT) <- c("Accomodated", "Online", "Paper")
Rhode_Island_Data_LONG_RICAS_2020_2021[, TEST_FORMAT := as.character(TEST_FORMAT)]

levels(Rhode_Island_Data_LONG_RICAS_2020_2021$EMH_LEVEL) <- c(NA, "Elementary", "Elementary/Middle", "High", "Middle", "PK-12")
Rhode_Island_Data_LONG_RICAS_2020_2021[, EMH_LEVEL := as.character(EMH_LEVEL)]


###  Enrollment (FAY) Variables
Rhode_Island_Data_LONG_RICAS_2020_2021[,STATE_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
Rhode_Island_Data_LONG_RICAS_2020_2021[,DISTRICT_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
Rhode_Island_Data_LONG_RICAS_2020_2021[,SCHOOL_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]

Rhode_Island_Data_LONG_RICAS_2020_2021[DISTRICT_NUMBER == "D88888", DISTRICT_ENROLLMENT_STATUS := "Enrolled District: No"]
Rhode_Island_Data_LONG_RICAS_2020_2021[SCHOOL_NUMBER == "88888", SCHOOL_ENROLLMENT_STATUS := "Enrolled School: No"]


### Resolve duplicates
setkey(Rhode_Island_Data_LONG_RICAS_2020_2021, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Rhode_Island_Data_LONG_RICAS_2020_2021, VALID_CASE, CONTENT_AREA, YEAR, ID)
#dups <- Rhode_Island_Data_LONG_RICAS_2020_2021[VALID_CASE=="VALID_CASE"][c(which(duplicated(Rhode_Island_Data_LONG_RICAS_2020_2021[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_RICAS_2020_2021)))-1, which(duplicated(Rhode_Island_Data_LONG_RICAS_2020_2021[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_RICAS_2020_2021)))),]
#setkeyv(dups, key(Rhode_Island_Data_LONG_RICAS_2020_2021))  #  0 duplicate cases RICAS data 8/11/21
#Rhode_Island_Data_LONG_RICAS_2020_2021[which(duplicated(Rhode_Island_Data_LONG_RICAS_2020_2021, by=key(Rhode_Island_Data_LONG_RICAS_2020_2021)))-1, VALID_CASE:="INVALID_CASE"]


### Save results
setkey(Rhode_Island_Data_LONG_RICAS_2020_2021, VALID_CASE, CONTENT_AREA, YEAR, ID)
save(Rhode_Island_Data_LONG_RICAS_2020_2021, file="Data/Rhode_Island_Data_LONG_RICAS_2020_2021.Rdata")
