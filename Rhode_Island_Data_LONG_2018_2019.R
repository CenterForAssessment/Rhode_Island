####################################################################
###                                                              ###
###   Script for creating Rhode Island LONG Data for 2018_2019   ###
###                                                              ###
####################################################################

##########################################################
####
##    PSAT/SAT Long Data
####
##########################################################

###   Load required packages
require(data.table)

###   Load data & CSEMS
Rhode_Island_Data_PSAT_2019 <- fread("Data/Base_Files/PSAT-7-18-2019-10-12_REVIEWED.csv", stringsAsFactors=FALSE)
setnames(Rhode_Island_Data_PSAT_2019, gsub(" ", "_", names(Rhode_Island_Data_PSAT_2019)))

Rhode_Island_Data_SAT_2019 <- fread("Data/Base_Files/SAT-07-18-2019_REVIEWED.csv", stringsAsFactors=FALSE)
setnames(Rhode_Island_Data_SAT_2019, gsub(" ", "_", names(Rhode_Island_Data_SAT_2019)))
setnames(Rhode_Island_Data_SAT_2019, "STUDENT_LAST_OR_SURNAME", "STUDENT_LAST")

Rhode_Island_CSEM_PSAT_FORM_1 <- fread("Data/Base_Files/RIDE_CSEMs_June2019_PSAT_FORM_1.csv")
Rhode_Island_CSEM_SAT_FORM_1 <- fread("Data/Base_Files/RIDE_CSEMs_June2019_SAT_FORM_1.csv")
Rhode_Island_CSEM_SAT_FORM_2 <- fread("Data/Base_Files/RIDE_CSEMs_June2019_SAT_FORM_1.csv")
Rhode_Island_CSEM_SAT_FORM_3 <- fread("Data/Base_Files/RIDE_CSEMs_June2019_SAT_FORM_3.csv")

Rhode_Island_CSEM_PSAT_FORM_1_NUMBERS <- fread("Data/Base_Files/RIDE_FORM_1_June2019_PSAT.csv")
Rhode_Island_CSEM_SAT_FORM_1_NUMBERS <- fread("Data/Base_Files/RIDE_FORM_1_June2019_SAT.csv")
Rhode_Island_CSEM_SAT_FORM_2_NUMBERS <- fread("Data/Base_Files/RIDE_FORM_2_June2019_SAT.csv")
Rhode_Island_CSEM_SAT_FORM_3_NUMBERS <- fread("Data/Base_Files/RIDE_FORM_3_June2019_SAT.csv")

##   Establish Valid 'Participants' - adapted from SPSS code sent by Rachel P. 8/16/18
#    PSAT
Rhode_Island_Data_PSAT_2019[, participant_ela := "Y"]
Rhode_Island_Data_PSAT_2019[attempt_ela == "N" | RIDE_invalidation_ela == "Y", participant_ela := "N"]
Rhode_Island_Data_PSAT_2019[attempt_math == "N" | RIDE_invalidation_math == "Y", participant_math := "N"]

#    SAT
Rhode_Island_Data_SAT_2019[, participant_ela := "Y"]
Rhode_Island_Data_SAT_2019[attempt_ela == "N" | RIDE_invalidation_ela == "Y", participant_ela := "N"]
Rhode_Island_Data_SAT_2019[attempt_math == "N" | RIDE_invalidation_math == "Y", participant_math := "N"]


##########################################################
###   Clean up 2018 P/SAT data
##########################################################

variables.to.keep <- c("SECONDARY_SCHOOL_STUDENT_ID", "STUDENT_FIRST_NAME", "STUDENT_LAST", "SEX", "DERIVED_AGGREGATE_RACE_ETHNICITY", "ACCOMMODATIONS_USED",
        "TOTAL_SCORE", "EVIDENCE_BASED_READING_AND_WRITING_SECTION_SCORE", "MATH_SECTION_SCORE", "COHORT_YEAR", "INVALIDATED_SCORE", "STUDENT_PARTICIPATED_INDICATOR",
        "DISTRICT_CODE", "DISTRICT_NAME", "STATE_ORGANIZATION_CODE", "RESPONSIBLE_ATTENDING_INSTITUTION_NAME", "FORM_CODE", "participant_ela", "participant_math")

Rhode_Island_Data_PSAT_2019<- Rhode_Island_Data_PSAT_2019[, variables.to.keep, with=FALSE]
Rhode_Island_Data_SAT_2019 <- Rhode_Island_Data_SAT_2019[, variables.to.keep, with=FALSE]

variable.names.new <- c("ID", "FIRST_NAME", "LAST_NAME", "GENDER", "ETHNICITY", "IEP_STATUS",
        "PSAT_TOTAL", "ELA_PSAT_10", "MATHEMATICS_PSAT_10", "COHORT_YEAR", "INVALIDATED_SCORE", "STUDENT_PARTICIPATED_INDICATOR",
        "DISTRICT_NUMBER", "DISTRICT_NAME", "SCHOOL_NUMBER", "SCHOOL_NAME", "FORM_CODE", "participant_ela", "participant_math")

setnames(Rhode_Island_Data_PSAT_2019, variable.names.new)
setnames(Rhode_Island_Data_SAT_2019, gsub("PSAT|PSAT_10", "SAT", variable.names.new))

Rhode_Island_Data_PSAT_SAT <- rbindlist(list(Rhode_Island_Data_PSAT_2019, Rhode_Island_Data_SAT_2019), fill = TRUE)


###   Create Required SGP Variables

Rhode_Island_Data_PSAT_SAT[, YEAR := "2018_2019"]
Rhode_Island_Data_PSAT_SAT[, GRADE := "EOCT"]


###   Tidy Up RIDE Provided Variables

Rhode_Island_Data_PSAT_SAT[, LAST_NAME := factor(LAST_NAME)]
levels(Rhode_Island_Data_PSAT_SAT$LAST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_PSAT_SAT$LAST_NAME), SGP::capwords))

Rhode_Island_Data_PSAT_SAT[, FIRST_NAME := factor(FIRST_NAME)]
levels(Rhode_Island_Data_PSAT_SAT$FIRST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_PSAT_SAT$FIRST_NAME), SGP::capwords))

Rhode_Island_Data_PSAT_SAT[GENDER=="U", GENDER:=NA]
Rhode_Island_Data_PSAT_SAT[, GENDER := factor(GENDER)]
levels(Rhode_Island_Data_PSAT_SAT$GENDER) <- c("Female", "Male")

# https://secure-media.collegeboard.org/digitalServices/pdf/ap/ap-guide-to-race-ethnicity-reporting-schools-districts-2016.pdf
Rhode_Island_Data_PSAT_SAT[, ETHNICITY := factor(ETHNICITY)]
levels(Rhode_Island_Data_PSAT_SAT$ETHNICITY) <- c("No Primary Race/Ethnicity Reported", "American Indian or Alaskan Native", "Asian", "Black or African American", "Hispanic or Latino", "Native Hawaiian or Pacific Islander", "White", "Multiple Ethnicities Reported")

Rhode_Island_Data_PSAT_SAT[, IEP_STATUS := factor(IEP_STATUS)]
levels(Rhode_Island_Data_PSAT_SAT$IEP_STATUS) <- c("Students without Disabilities (Non-IEP)", "Students with Disabilities (IEP)")


###  Combine content areas into single LONG file

final.vars.to.keep <- c("ID", "YEAR", "GRADE", "FIRST_NAME", "LAST_NAME", "GENDER", "ETHNICITY", "SCALE_SCORE", "FORM_CODE", "participant_ela", "participant_math")

Rhode_Island_Data_LONG_SAT_2018_2019 <- rbindlist(list(
      Rhode_Island_Data_PSAT_SAT[, SCALE_SCORE := MATHEMATICS_PSAT_10][!is.na(SCALE_SCORE), final.vars.to.keep, with = FALSE][, CONTENT_AREA := "MATHEMATICS_PSAT_10"],
      Rhode_Island_Data_PSAT_SAT[, SCALE_SCORE := ELA_PSAT_10][!is.na(SCALE_SCORE), final.vars.to.keep, with = FALSE][, CONTENT_AREA := "ELA_PSAT_10"],
      Rhode_Island_Data_PSAT_SAT[, SCALE_SCORE := MATHEMATICS_SAT][!is.na(SCALE_SCORE), final.vars.to.keep, with = FALSE][, CONTENT_AREA := "MATHEMATICS_SAT"],
      Rhode_Island_Data_PSAT_SAT[, SCALE_SCORE := ELA_SAT][!is.na(SCALE_SCORE), final.vars.to.keep, with = FALSE][, CONTENT_AREA := "ELA_SAT"]#,
      # Rhode_Island_Data_PSAT_SAT[, SCALE_SCORE := PSAT_TOTAL][,list(ID, YEAR, FIRST_NAME, LAST_NAME, GENDER, ETHNICITY, SCALE_SCORE)][, CONTENT_AREA := "PSAT_TOTAL"]
))


###  Identify VALID_CASEs by full test participation

Rhode_Island_Data_LONG_SAT_2018_2019[, VALID_CASE := "VALID_CASE"]
Rhode_Island_Data_LONG_SAT_2018_2019[participant_ela == "N" & CONTENT_AREA %in% c("ELA_PSAT_10", "ELA_SAT"), VALID_CASE := "INVALID_CASE"]
Rhode_Island_Data_LONG_SAT_2018_2019[participant_math == "N" & CONTENT_AREA %in% c("MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"), VALID_CASE := "INVALID_CASE"]

table(Rhode_Island_Data_LONG_SAT_2018_2019[, VALID_CASE, CONTENT_AREA], exclude=NULL)
Rhode_Island_Data_LONG_SAT_2018_2019[VALID_CASE == "INVALID_CASE", as.list(summary(SCALE_SCORE)), keyby="CONTENT_AREA"] # All LOSS scores

Rhode_Island_Data_LONG_SAT_2018_2019[, c("participant_ela", "participant_math") := NULL]


### Change class of some variables

Rhode_Island_Data_LONG_SAT_2018_2019[,ID:=as.character(ID)]


### Prepare PSAT/SAT CSEMs and merge into LONG data

# FORM 1 SAT
tmp.list <- list()
CSEM_SAT_FORM_1 <- data.table(YEAR="2018_2019",
                              CONTENT_AREA=c(rep("MATHEMATICS_SAT", dim(Rhode_Island_CSEM_SAT_FORM_1)[1]), rep("ELA_SAT", dim(Rhode_Island_CSEM_SAT_FORM_1)[1])),
                              SCALE_SCORE=rep(Rhode_Island_CSEM_SAT_FORM_1[[1]], 2),
                              SCALE_SCORE_CSEM=c(Rhode_Island_CSEM_SAT_FORM_1[[2]], Rhode_Island_CSEM_SAT_FORM_1[[3]]))

for (iter in Rhode_Island_CSEM_SAT_FORM_1_NUMBERS[[1]]) {
    CSEM_SAT_FORM_1$FORM_CODE <- as.character(iter)
    tmp.list[[as.character(iter)]] <- CSEM_SAT_FORM_1
}

CSEM_SAT_FORM_1 <- rbindlist(tmp.list)[!is.na(SCALE_SCORE)]

# FORM 2 SAT
tmp.list <- list()
CSEM_SAT_FORM_2 <- data.table(YEAR="2018_2019",
                              CONTENT_AREA=c(rep("MATHEMATICS_SAT", dim(Rhode_Island_CSEM_SAT_FORM_2)[1]), rep("ELA_SAT", dim(Rhode_Island_CSEM_SAT_FORM_2)[1])),
                              SCALE_SCORE=rep(Rhode_Island_CSEM_SAT_FORM_2[[1]], 2),
                              SCALE_SCORE_CSEM=c(Rhode_Island_CSEM_SAT_FORM_2[[2]], Rhode_Island_CSEM_SAT_FORM_2[[3]]))

for (iter in Rhode_Island_CSEM_SAT_FORM_2_NUMBERS[[1]]) {
    CSEM_SAT_FORM_2$FORM_CODE <- as.character(iter)
    tmp.list[[as.character(iter)]] <- CSEM_SAT_FORM_2
}

CSEM_SAT_FORM_2 <- rbindlist(tmp.list)[!is.na(SCALE_SCORE)]

# FORM 3 SAT
tmp.list <- list()
CSEM_SAT_FORM_3 <- data.table(YEAR="2018_2019",
                              CONTENT_AREA=c(rep("MATHEMATICS_SAT", dim(Rhode_Island_CSEM_SAT_FORM_3)[1]), rep("ELA_SAT", dim(Rhode_Island_CSEM_SAT_FORM_3)[1])),
                              SCALE_SCORE=rep(Rhode_Island_CSEM_SAT_FORM_3[[1]], 2),
                              SCALE_SCORE_CSEM=c(Rhode_Island_CSEM_SAT_FORM_3[[2]], Rhode_Island_CSEM_SAT_FORM_3[[3]]))

for (iter in Rhode_Island_CSEM_SAT_FORM_3_NUMBERS[[1]]) {
    CSEM_SAT_FORM_3$FORM_CODE <- as.character(iter)
    tmp.list[[as.character(iter)]] <- CSEM_SAT_FORM_3
}

CSEM_SAT_FORM_3 <- rbindlist(tmp.list)[!is.na(SCALE_SCORE)]

# FORM 1 PSAT
tmp.list <- list()
CSEM_PSAT_FORM_1 <- data.table(YEAR="2018_2019",
                              CONTENT_AREA=c(rep("MATHEMATICS_PSAT_10", dim(Rhode_Island_CSEM_PSAT_FORM_1)[1]), rep("ELA_PSAT_10", dim(Rhode_Island_CSEM_PSAT_FORM_1)[1])),
                              SCALE_SCORE=rep(Rhode_Island_CSEM_PSAT_FORM_1[[1]], 2),
                              SCALE_SCORE_CSEM=c(Rhode_Island_CSEM_PSAT_FORM_1[[2]], Rhode_Island_CSEM_PSAT_FORM_1[[3]]))

for (iter in Rhode_Island_CSEM_PSAT_FORM_1_NUMBERS[[1]]) {
    CSEM_PSAT_FORM_1$FORM_CODE <- as.character(iter)
    tmp.list[[as.character(iter)]] <- CSEM_PSAT_FORM_1
}

CSEM_PSAT_FORM_1 <- rbindlist(tmp.list)[!is.na(SCALE_SCORE)]

#Merge all CSEM files together

CSEM_PSAT_SAT <- rbindlist(list(CSEM_SAT_FORM_1, CSEM_SAT_FORM_2, CSEM_SAT_FORM_3, CSEM_PSAT_FORM_1))[,VALID_CASE:="VALID_CASE"]



###  Identify VALID_CASEs
##   Ignore COHORT_YEAR per Ana K 7/23/18 email
# Rhode_Island_Data_LONG_SAT_2018_2019[, VALID_CASE := "VALID_CASE"]
# Rhode_Island_Data_LONG_SAT_2018_2019[COHORT_YEAR != "2020", VALID_CASE := "INVALID_CASE"]
# Rhode_Island_Data_LONG_SAT_2018_2019[, VALID_CASE := "VALID_CASE"]
# Rhode_Island_Data_LONG_SAT_2018_2019[COHORT_YEAR != "2019", VALID_CASE := "INVALID_CASE"]


###   Create ACHIEVEMENT_LEVEL Variable

Rhode_Island_Data_LONG_SAT_2018_2019 <- SGP:::getAchievementLevel(
	Rhode_Island_Data_LONG_SAT_2018_2019, state="RI",
	achievement.level.name="ACHIEVEMENT_LEVEL", scale.score.name="SCALE_SCORE")


###  Duplicates in prelimimary data!

setkey(Rhode_Island_Data_LONG_SAT_2018_2019, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID, SCALE_SCORE)
setkey(Rhode_Island_Data_LONG_SAT_2018_2019, VALID_CASE, YEAR, CONTENT_AREA, GRADE, ID)
# dups <- Rhode_Island_Data_LONG_SAT_2018_2019[c(which(duplicated(Rhode_Island_Data_LONG_SAT_2018_2019, by=key(Rhode_Island_Data_LONG_SAT_2018_2019)))-1, which(duplicated(Rhode_Island_Data_LONG_SAT_2018_2019, by=key(Rhode_Island_Data_LONG_SAT_2018_2019)))),]
# setkeyv(dups, key(Rhode_Island_Data_LONG_SAT_2018_2019))
Rhode_Island_Data_LONG_SAT_2018_2019[which(duplicated(Rhode_Island_Data_LONG_SAT_2018_2019, by=key(Rhode_Island_Data_LONG_SAT_2018_2019)))-1, VALID_CASE := "INVALID_CASE"]
table(Rhode_Island_Data_LONG_SAT_2018_2019$VALID_CASE)

### Merge in CSEMs

Rhode_Island_Data_LONG_SAT_2018_2019[,FORM_CODE:=as.character(FORM_CODE)]
setkey(CSEM_PSAT_SAT, VALID_CASE, CONTENT_AREA, YEAR, FORM_CODE, SCALE_SCORE)
setkey(Rhode_Island_Data_LONG_SAT_2018_2019, VALID_CASE, CONTENT_AREA, YEAR, FORM_CODE, SCALE_SCORE)
Rhode_Island_Data_LONG_SAT_2018_2019 <- CSEM_PSAT_SAT[Rhode_Island_Data_LONG_SAT_2018_2019]
#Rhode_Island_Data_LONG_SAT_2018_2019[,FORM_CODE:=NULL]
Rhode_Island_Data_LONG_SAT_2018_2019[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]
Rhode_Island_Data_LONG_SAT_2018_2019[,SCALE_SCORE_CSEM:=as.numeric(SCALE_SCORE_CSEM)]


### set key results

setkey(Rhode_Island_Data_LONG_SAT_2018_2019, VALID_CASE, CONTENT_AREA, YEAR, ID)


##########################################################
####
##    RICAS Long Data
####
##########################################################

###   Load data
Rhode_Island_Data_LONG_RICAS_2018_2019 <- NULL
#Rhode_Island_Data_LONG_RICAS_2018_2019 <- fread("~/Dropbox (SGP)/SGP/Rhode_Island/Data/Base_Files/RICAS2018 082318.csv", stringsAsFactors=FALSE)

#variables.to.keep <- c( # paste(unlist(names(Rhode_Island_Data_LONG_RICAS_2018_2019)[c(1:62)]), collapse="', '")
#      "sasid", "lastname", "firstname", "mi", "grade", "stugrade",
#      "resp_discode", "resp_schcode", "resp_disname", "resp_schname", "resp_schlevel",
#      "escaleds", "eperflev", "e_ssSEM", "e_theta", "e_thetaSEM", "emode",
#      "mscaleds", "mperflev", "m_ssSEM", "m_theta", "m_thetaSEM", "mmode",
#      "AIAN", "asian", "BAA", "hispanic", "NHOPI", "white", "tworaces",
#      "gender", "ecodis", "ELL", "IEP", "plan504", "enonacc")

#variable.names.new <- c(
#      "ID", "LAST_NAME", "FIRST_NAME", "MIDDLE_INITIAL", "GRADE", "GRADE_ENROLLED",
#      "DISTRICT_NUMBER", "SCHOOL_NUMBER", "DISTRICT_NAME", "SCHOOL_NAME", "EMH_LEVEL",
#      "SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL", "SCALE_SCORE_ACTUAL_CSEM", "SCALE_SCORE", "SCALE_SCORE_CSEM", "TEST_FORMAT",
#      "GENDER", "FREE_REDUCED_LUNCH_STATUS", "ELL_STATUS", "IEP_STATUS", "enonacc",
#      "ETHNICITY", "CONTENT_AREA") #  These two added later

#Rhode_Island_Data_LONG_RICAS_2018_2019 <- Rhode_Island_Data_LONG_RICAS_2018_2019[, variables.to.keep, with=FALSE]

#factor.vars <- c("gender", "ecodis", "ELL", "IEP", "lastname", "firstname", "resp_schlevel", "emode", "mmode", "eperflev", "mperflev")
#for(v in factor.vars) Rhode_Island_Data_LONG_RICAS_2018_2019[, (v) := factor(eval(parse(text=v)))]

#ACHIEVEMENT_LEVEL, TEST_FORMAT, EMH_LEVEL
###   Create single ETHNICITY variable
#Rhode_Island_Data_LONG_RICAS_2018_2019[, ETHNICITY := as.character(NA)]
#Rhode_Island_Data_LONG_RICAS_2018_2019[AIAN == "Y", ETHNICITY := "American Indian or Alaskan Native"]
#Rhode_Island_Data_LONG_RICAS_2018_2019[asian == "Y", ETHNICITY := "Asian"]
#Rhode_Island_Data_LONG_RICAS_2018_2019[BAA == "Y", ETHNICITY := "Black or African American"]
#Rhode_Island_Data_LONG_RICAS_2018_2019[hispanic == "Y", ETHNICITY := "Hispanic or Latino"]
#Rhode_Island_Data_LONG_RICAS_2018_2019[NHOPI == "Y", ETHNICITY := "Native Hawaiian or Pacific Islander"]
#Rhode_Island_Data_LONG_RICAS_2018_2019[white == "Y", ETHNICITY := "White"]
#Rhode_Island_Data_LONG_RICAS_2018_2019[tworaces == "Y", ETHNICITY := "Multiple Ethnicities Reported"]
#Rhode_Island_Data_LONG_RICAS_2018_2019[is.na(ETHNICITY), ETHNICITY := "No Primary Race/Ethnicity Reported"]

#Rhode_Island_Data_LONG_RICAS_2018_2019[, c("AIAN", "asian", "BAA", "hispanic", "NHOPI", "white", "tworaces") := NULL] # enonacc

###   Other Demographic Variables
#Rhode_Island_Data_LONG_RICAS_2018_2019[plan504 == "Y", IEP := "Students with 504 Plan"]
#Rhode_Island_Data_LONG_RICAS_2018_2019[, plan504 := NULL]
#levels(Rhode_Island_Data_LONG_RICAS_2018_2019$IEP) <- c("Students without Disabilities (Non-IEP)", "Students with Disabilities (IEP)", "Students with 504 Plan")

#levels(Rhode_Island_Data_LONG_RICAS_2018_2019$gender) <- c(NA, "Female", "Male")
#levels(Rhode_Island_Data_LONG_RICAS_2018_2019$ecodis) <- c("Not Economically Disadvantaged", "Economically Disadvantaged")
#levels(Rhode_Island_Data_LONG_RICAS_2018_2019$ELL) <- c("Non-English Language Learners (ELL)", "English Language Learners (ELL)")

###   Student Names
#levels(Rhode_Island_Data_LONG_RICAS_2018_2019$lastname) <- as.character(sapply(levels(Rhode_Island_Data_LONG_RICAS_2018_2019$lastname), SGP::capwords))
#levels(Rhode_Island_Data_LONG_RICAS_2018_2019$firstname) <- as.character(sapply(levels(Rhode_Island_Data_LONG_RICAS_2018_2019$firstname), SGP::capwords))


###   Create LONG file - remove other set of content area scores and establish CONTENT_AREA variable
#ela <- copy(Rhode_Island_Data_LONG_RICAS_2018_2019)[, c("mscaleds", "mperflev", "m_ssSEM", "m_theta", "m_thetaSEM", "mmode") := NULL][, CONTENT_AREA := "ELA"]
#mat <- copy(Rhode_Island_Data_LONG_RICAS_2018_2019)[, c("escaleds", "eperflev", "e_ssSEM", "e_theta", "e_thetaSEM", "emode") := NULL][, CONTENT_AREA := "MATHEMATICS"]

#setnames(ela, variable.names.new)
#setnames(mat, variable.names.new)

#Rhode_Island_Data_LONG_RICAS_2018_2019 <- rbindlist(list(ela, mat))


###   Tidy Up data

#Rhode_Island_Data_LONG_RICAS_2018_2019[, ID := as.character(ID)]
#Rhode_Island_Data_LONG_RICAS_2018_2019[, YEAR := "2018_2019"]
#Rhode_Island_Data_LONG_RICAS_2018_2019[, VALID_CASE := "VALID_CASE"]

#Rhode_Island_Data_LONG_RICAS_2018_2019[is.na(ID), VALID_CASE:="INVALID_CASE"]
#Rhode_Island_Data_LONG_RICAS_2018_2019[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]
#Rhode_Island_Data_LONG_RICAS_2018_2019[enonacc == 5, VALID_CASE:="INVALID_CASE"]
#Rhode_Island_Data_LONG_RICAS_2018_2019[,enonacc := NULL]
# Rhode_Island_Data_LONG_RICAS_2018_2019[SCHOOL_NUMBER == "23334", VALID_CASE:="INVALID_CASE"]  #  Already INVALID_CASEs - missing sasid/ID

#levels(Rhode_Island_Data_LONG_RICAS_2018_2019$ACHIEVEMENT_LEVEL) <- c("Not Meeting", "Partially Meeting", "Meeting", "Exceeding")
#Rhode_Island_Data_LONG_RICAS_2018_2019[,ACHIEVEMENT_LEVEL := as.character(ACHIEVEMENT_LEVEL)]

#levels(Rhode_Island_Data_LONG_RICAS_2018_2019$TEST_FORMAT) <- c("Online", "Paper", NA, "Online")
#Rhode_Island_Data_LONG_RICAS_2018_2019[, TEST_FORMAT := as.character(TEST_FORMAT)]

#levels(Rhode_Island_Data_LONG_RICAS_2018_2019$EMH_LEVEL) <- c(NA, "Elementary", "Elementary/Middle", "Middle", "Middle/High", "PK-12")
#Rhode_Island_Data_LONG_RICAS_2018_2019[, EMH_LEVEL := as.character(EMH_LEVEL)]


###  Enrollment (FAY) Variables
#Rhode_Island_Data_LONG_RICAS_2018_2019[,STATE_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
#Rhode_Island_Data_LONG_RICAS_2018_2019[,DISTRICT_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
#Rhode_Island_Data_LONG_RICAS_2018_2019[,SCHOOL_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]

#Rhode_Island_Data_LONG_RICAS_2018_2019[DISTRICT_NUMBER == "D88888", DISTRICT_ENROLLMENT_STATUS := "Enrolled District: No"]
#Rhode_Island_Data_LONG_RICAS_2018_2019[SCHOOL_NUMBER == "88888", SCHOOL_ENROLLMENT_STATUS := "Enrolled School: No"]


### Resolve duplicates
#setkey(Rhode_Island_Data_LONG_RICAS_2018_2019, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
#setkey(Rhode_Island_Data_LONG_RICAS_2018_2019, VALID_CASE, CONTENT_AREA, YEAR, ID)
# dups <- Rhode_Island_Data_LONG_RICAS_2018_2019[c(which(duplicated(Rhode_Island_Data_LONG_RICAS_2018_2019, by=key(Rhode_Island_Data_LONG_RICAS_2018_2019)))-1, which(duplicated(Rhode_Island_Data_LONG_RICAS_2018_2019, by=key(Rhode_Island_Data_LONG_RICAS_2018_2019)))),]
# setkeyv(dups, key(Rhode_Island_Data_LONG_RICAS_2018_2019))  #  300 duplicate cases (150) in first RICAS draft 8/23/18
#Rhode_Island_Data_LONG_RICAS_2018_2019[which(duplicated(Rhode_Island_Data_LONG_RICAS_2018_2019, by=key(Rhode_Island_Data_LONG_RICAS_2018_2019)))-1, VALID_CASE:="INVALID_CASE"]


### Save results
#setkey(Rhode_Island_Data_LONG_RICAS_2018_2019, VALID_CASE, CONTENT_AREA, YEAR, ID)
#save(Rhode_Island_Data_LONG_RICAS_2018_2019, file="Data/Rhode_Island_Data_LONG_RICAS_2018_2019.Rdata")


##########################################################
###   Compile PARCC and RICAS CSEM Data
##########################################################

###   Merge in CSEM data for PARCC Tests
#load("~/Dropbox (SGP)/SGP/PARCC/PARCC/Data/Base_Files/PARCC_THETA_CSEM_LOOKUP.rda")
#PARCC_THETA_CSEM_LOOKUP <- PARCC_THETA_CSEM_LOOKUP[YEAR %in% c("2015_2016.2", "2016_2017.2")]
#PARCC_THETA_CSEM_LOOKUP[, YEAR := gsub("[.]2", "", YEAR)]

#RICAS_CSEM_LOOKUP <- unique(Rhode_Island_Data_LONG_RICAS_2018_2019[VALID_CASE=="VALID_CASE", list(YEAR, CONTENT_AREA, GRADE, VALID_CASE, SCALE_SCORE, SCALE_SCORE_CSEM)])[,VALID_CASE := NULL]
#setkey(RICAS_CSEM_LOOKUP)

#RICAS_PARCC_CSEM <- rbind(PARCC_THETA_CSEM_LOOKUP, RICAS_CSEM_LOOKUP)

#save(RICAS_PARCC_CSEM, file="~/Dropbox (SGP)/Github_Repos/Packages/SGPstateData/CSEM/Rhode_Island/RICAS_PARCC_CSEM.Rdata")
# SGPstateData[["RI"]][["Assessment_Program_Information"]][["CSEM"]] <- RICAS_PARCC_CSEM #  SIMEX and SGP Standard Errors


### Save results

Rhode_Island_Data_LONG_2018_2019 <- rbindlist(list(Rhode_Island_Data_LONG_SAT_2018_2019, Rhode_Island_Data_LONG_RICAS_2018_2019))

save(Rhode_Island_Data_LONG_2018_2019, file="Data/Rhode_Island_Data_LONG_2018_2019.Rdata")
