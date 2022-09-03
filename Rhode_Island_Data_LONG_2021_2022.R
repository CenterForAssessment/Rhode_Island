####################################################################
###                                                              ###
###   Script for creating Rhode Island LONG Data for 2021_2022   ###
###                                                              ###
####################################################################

###   Load required packages
require(data.table)
require(foreign)
require(readxl)

#######################################################################
### RICAS
#######################################################################

###   Load Data
Rhode_Island_Data_LONG_RICAS_2021_2022 <- fread("Data/Base_Files/RICAS2022.csv", stringsAsFactors=FALSE)

### Preliminary cleanup of ethnicity data 
Rhode_Island_Data_LONG_RICAS_2021_2022[asian=="Y", RACE7:="AS7"]
Rhode_Island_Data_LONG_RICAS_2021_2022[AIAN=="Y", RACE7:="AM7"]
Rhode_Island_Data_LONG_RICAS_2021_2022[BAA=="Y", RACE7:="BL7"]
Rhode_Island_Data_LONG_RICAS_2021_2022[hispanic=="Y", RACE7:="HI7"]
Rhode_Island_Data_LONG_RICAS_2021_2022[NHOPI=="Y", RACE7:="PI7"]
Rhode_Island_Data_LONG_RICAS_2021_2022[white=="Y", RACE7:="WH7"]

### Cleanup data
variables.to.keep_RICAS <- c(
      "sasid", "lastname", "firstname", "grade", "stugrade",
      "resp_discode", "resp_schcode", "resp_disname", "resp_schname", "resp_schlevel",
      "escaleds", "eperflev", "e_ssSEM", "e_theta", "e_thetaSEM", "emode",
      "mscaleds", "mperflev", "m_ssSEM", "m_theta", "m_thetaSEM", "mmode",
      "RACE7", "gender", "ecodis", "ELL", "IEP", "plan504", "enonacc")

variable.names.new_RICAS <- c(
      "ID", "LAST_NAME", "FIRST_NAME", "GRADE", "GRADE_ENROLLED",
      "DISTRICT_NUMBER", "SCHOOL_NUMBER", "DISTRICT_NAME", "SCHOOL_NAME", "EMH_LEVEL",
      "SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL", "SCALE_SCORE_ACTUAL_CSEM", "SCALE_SCORE", "SCALE_SCORE_CSEM", "TEST_FORMAT",
      "ETHNICITY", "GENDER", "FREE_REDUCED_LUNCH_STATUS", "ELL_STATUS", "IEP_STATUS", "enonacc",
      "CONTENT_AREA")

Rhode_Island_Data_LONG_RICAS_2021_2022 <- Rhode_Island_Data_LONG_RICAS_2021_2022[, variables.to.keep_RICAS, with=FALSE]

factor.vars <- c("gender", "ecodis", "ELL", "IEP", "lastname", "firstname", "resp_schlevel", "emode", "mmode", "eperflev", "mperflev")
for(v in factor.vars) Rhode_Island_Data_LONG_RICAS_2021_2022[, (v) := factor(eval(parse(text=v)))]

### Tidy up RICAS data
setattr(Rhode_Island_Data_LONG_RICAS_2021_2022$lastname, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_RICAS_2021_2022$lastname), SGP:::capwords)))
setattr(Rhode_Island_Data_LONG_RICAS_2021_2022$firstname, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_RICAS_2021_2022$firstname), SGP:::capwords)))
Rhode_Island_Data_LONG_RICAS_2021_2022[, grade := as.character(as.numeric(grade))]
Rhode_Island_Data_LONG_RICAS_2021_2022[, stugrade := as.character(as.numeric(stugrade))]
Rhode_Island_Data_LONG_RICAS_2021_2022[, resp_discode:=as.character(sapply(Rhode_Island_Data_LONG_RICAS_2021_2022$resp_discode, SGP:::capwords))]
Rhode_Island_Data_LONG_RICAS_2021_2022[, resp_schcode:=as.character(sapply(Rhode_Island_Data_LONG_RICAS_2021_2022$resp_schcode, SGP:::capwords))]
Rhode_Island_Data_LONG_RICAS_2021_2022[, resp_disname:=as.character(sapply(Rhode_Island_Data_LONG_RICAS_2021_2022$resp_disname, SGP:::capwords))]
Rhode_Island_Data_LONG_RICAS_2021_2022[, resp_schname:=as.character(sapply(Rhode_Island_Data_LONG_RICAS_2021_2022$resp_schname, SGP:::capwords))]
setattr(Rhode_Island_Data_LONG_RICAS_2021_2022$resp_schlevel, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_RICAS_2021_2022$resp_schlevel), SGP:::capwords)))
setattr(Rhode_Island_Data_LONG_RICAS_2021_2022$eperflev, "levels", c("Not Meeting Expectations", "Partially Meeting Expectations", "Meeting Expectations", "Exceeding Expectations"))
setattr(Rhode_Island_Data_LONG_RICAS_2021_2022$mperflev, "levels", c("Not Meeting Expectations", "Partially Meeting Expectations", "Meeting Expectations", "Exceeding Expectations"))
Rhode_Island_Data_LONG_RICAS_2021_2022[,RACE7:=as.factor(RACE7)]
setattr(Rhode_Island_Data_LONG_RICAS_2021_2022$RACE7, "levels", c("American Indian or Alaskan Native", "Asian", "Black or African American", "Hispanic or Latino", "Multiple Ethnicities Reported", "Native Hawaiian or Pacific Islander", "White"))
setattr(Rhode_Island_Data_LONG_RICAS_2021_2022$gender, "levels", c("Female", "Male", "Other"))

###   Other Demographic Variables
Rhode_Island_Data_LONG_RICAS_2021_2022[plan504 == "Y", IEP := "Students with 504 Plan"]
Rhode_Island_Data_LONG_RICAS_2021_2022[,plan504:=NULL]
levels(Rhode_Island_Data_LONG_RICAS_2021_2022$IEP) <- c("Students without Disabilities (Non-IEP)", "Students with Disabilities (IEP)", "Students with 504 Plan")

levels(Rhode_Island_Data_LONG_RICAS_2021_2022$ecodis) <- c("Not Economically Disadvantaged", "Economically Disadvantaged")
levels(Rhode_Island_Data_LONG_RICAS_2021_2022$ELL) <- c("Non-English Language Learners (ELL)", "English Language Learners (ELL)")

###   Create LONG file - remove other set of content area scores and establish CONTENT_AREA variable
ela <- copy(Rhode_Island_Data_LONG_RICAS_2021_2022)[, c("mscaleds", "mperflev", "m_ssSEM", "m_theta", "m_thetaSEM", "mmode") := NULL][, CONTENT_AREA := "ELA"]
mat <- copy(Rhode_Island_Data_LONG_RICAS_2021_2022)[, c("escaleds", "eperflev", "e_ssSEM", "e_theta", "e_thetaSEM", "emode") := NULL][, CONTENT_AREA := "MATHEMATICS"]

setnames(ela, variable.names.new_RICAS)
setnames(mat, variable.names.new_RICAS)

Rhode_Island_Data_LONG_RICAS_2021_2022 <- rbindlist(list(ela, mat))

###   Tidy Up data
Rhode_Island_Data_LONG_RICAS_2021_2022[, YEAR := "2021_2022"]
Rhode_Island_Data_LONG_RICAS_2021_2022[, VALID_CASE := "VALID_CASE"]
Rhode_Island_Data_LONG_RICAS_2021_2022[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_RICAS_2021_2022[,enonacc := NULL]
levels(Rhode_Island_Data_LONG_RICAS_2021_2022$TEST_FORMAT) <- c("Accomodated", "Online", "Paper")
Rhode_Island_Data_LONG_RICAS_2021_2022[, TEST_FORMAT := as.character(TEST_FORMAT)]
levels(Rhode_Island_Data_LONG_RICAS_2021_2022$EMH_LEVEL) <- c(NA, "Elementary", "Elementary/Middle", "High", "Middle", "PK-12")
Rhode_Island_Data_LONG_RICAS_2021_2022[, EMH_LEVEL := as.character(EMH_LEVEL)]

###  Enrollment (FAY) Variables
Rhode_Island_Data_LONG_RICAS_2021_2022[,STATE_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
Rhode_Island_Data_LONG_RICAS_2021_2022[,DISTRICT_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
Rhode_Island_Data_LONG_RICAS_2021_2022[,SCHOOL_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]

### Resolve duplicates
#setkey(Rhode_Island_Data_LONG_RICAS_2021_2022, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
#setkey(Rhode_Island_Data_LONG_RICAS_2021_2022, VALID_CASE, CONTENT_AREA, YEAR, ID)
#dups <- Rhode_Island_Data_LONG_RICAS_2021_2022[VALID_CASE=="VALID_CASE"][c(which(duplicated(Rhode_Island_Data_LONG_RICAS_2021_2022[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_RICAS_2021_2022)))-1, which(duplicated(Rhode_Island_Data_LONG_RICAS_2021_2022[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_RICAS_2021_2022)))),]
# setkeyv(dups, key(Rhode_Island_Data_LONG_RICAS_2021_2022))  #  0 duplicate cases RICAS data 9/3/22
#Rhode_Island_Data_LONG_RICAS_2021_2022[which(duplicated(Rhode_Island_Data_LONG_RICAS_2021_2022, by=key(Rhode_Island_Data_LONG_RICAS_2021_2022)))-1, VALID_CASE:="INVALID_CASE"]


#######################################################################
### PSAT/SAT
#######################################################################

###   Load Data
Rhode_Island_Data_LONG_PSAT_2021_2022 <- fread("Data/Base_Files/RI_STATE_PSAT10_06242022_forSGP.csv", fill=TRUE, sep=",")
Rhode_Island_Data_LONG_SAT_2021_2022_ORIGINAL <- fread("Data/Base_Files/RI_STATE_SAT_06242022_forSGP.csv", fill=TRUE, sep=",")
Rhode_Island_Data_LONG_SAT_2021_2022_SUPPLEMENTAL <- fread("Data/Base_Files/RI_STATE_ACCT_RPT_SAT SUPPLEMENTAL_07212022.csv", fill=TRUE, sep=",")
Rhode_Island_Data_LONG_SAT_2021_2022 <- rbindlist(list(Rhode_Island_Data_LONG_SAT_2021_2022_ORIGINAL[,ORIGINAL_DATA:=TRUE], Rhode_Island_Data_LONG_SAT_2021_2022_SUPPLEMENTAL[,ORIGINAL_DATA:=FALSE]))

District_Names_2021 <- as.data.table(read.spss("Data/Base_Files/2021Districts.sav"))
School_Names_2021 <- as.data.table(read.spss("Data/Base_Files/2021Schools.sav"))


### Cleanup data
variables.to.keep_PSAT <- c(
      "STATE ORGANIZATION CODE", "RESPONSIBLE DISTRICT CODE",
      "SECONDARY SCHOOL STUDENT ID", "STUDENT LAST", "STUDENT FIRST NAME", "GRADE LEVEL WHEN ASSESSED",
      "EVIDENCE-BASED READING AND WRITING SECTION SCORE", "ELA PROFICIENCY", "MATH SECTION SCORE", "MATH PROFICIENCY",
      "DERIVED AGGREGATE RACE ETHNICITY", "SEX", "EVIDENCE BASED READING AND WRITING PARTICIPATED INDICATOR", "MATH PARTICIPATED INDICATOR", "FORM CODE")

variables.to.keep_SAT <- c(
      "STATE ORGANIZATION CODE", "RESPONSIBLE DISTRICT CODE",
      "SECONDARY SCHOOL STUDENT ID", "STUDENT LAST OR SURNAME", "STUDENT FIRST NAME", "GRADE LEVEL WHEN ASSESSED",
      "EVIDENCE BASED READING AND WRITING SECTION SCORE", "ELA PROFICIENCY", "MATH SECTION SCORE", "MATH PROFICIENCY",
      "DERIVED AGGREGATE RACE ETHNICITY", "SEX", "EVIDENCE BASED READING AND WRITING PARTICIPATED INDICATOR", "MATH PARTICIPATED INDICATOR", "FORM CODE", "ORIGINAL_DATA")

variable.names.new_PSAT_SAT <- c(
      "SCHOOL_NUMBER", "SCHOOL_NAME", "DISTRICT_NUMBER", "DISTRICT_NAME",
      "ID", "LAST_NAME", "FIRST_NAME", "GRADE_ENROLLED",
      "SCALE_SCORE", "ACHIEVEMENT_LEVEL",
      "ETHNICITY", "GENDER",
      "PARTICIPATION", "FORM", "GRADE", "ORIGINAL_DATA", "CONTENT_AREA")

Rhode_Island_Data_LONG_PSAT_2021_2022 <- Rhode_Island_Data_LONG_PSAT_2021_2022[, variables.to.keep_PSAT, with=FALSE][]
Rhode_Island_Data_LONG_SAT_2021_2022 <- Rhode_Island_Data_LONG_SAT_2021_2022[, variables.to.keep_SAT, with=FALSE]

setnames(Rhode_Island_Data_LONG_PSAT_2021_2022, "GRADE LEVEL WHEN ASSESSED", "GRADE_ENROLLED")
setnames(Rhode_Island_Data_LONG_SAT_2021_2022, "GRADE LEVEL WHEN ASSESSED", "GRADE_ENROLLED")
Rhode_Island_Data_LONG_PSAT_2021_2022[,GRADE_ENROLLED:=as.character(as.numeric(GRADE_ENROLLED))]
Rhode_Island_Data_LONG_SAT_2021_2022[,GRADE_ENROLLED:=as.character(as.numeric(GRADE_ENROLLED))]
Rhode_Island_Data_LONG_PSAT_2021_2022[GRADE_ENROLLED=="5", GRADE_ENROLLED:="10"]
Rhode_Island_Data_LONG_PSAT_2021_2022[GRADE_ENROLLED=="6", GRADE_ENROLLED:="11"]
Rhode_Island_Data_LONG_SAT_2021_2022[GRADE_ENROLLED=="5", GRADE_ENROLLED:="10"]
Rhode_Island_Data_LONG_SAT_2021_2022[GRADE_ENROLLED=="6", GRADE_ENROLLED:="11"]
Rhode_Island_Data_LONG_PSAT_2021_2022[,GRADE:="10"]
Rhode_Island_Data_LONG_SAT_2021_2022[,GRADE:="11"]

setnames(Rhode_Island_Data_LONG_PSAT_2021_2022, "EVIDENCE-BASED READING AND WRITING SECTION SCORE", "EVIDENCE BASED READING AND WRITING SECTION SCORE")
setnames(Rhode_Island_Data_LONG_SAT_2021_2022, "STUDENT LAST OR SURNAME", "STUDENT LAST")
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022 <- rbindlist(list(Rhode_Island_Data_LONG_PSAT_2021_2022, Rhode_Island_Data_LONG_SAT_2021_2022), fill=TRUE)
setnames(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022, c("RESPONSIBLE DISTRICT CODE", "STATE ORGANIZATION CODE"), c("DistrictCode", "SchoolCode"))
setnames(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022, gsub(" ", "_", names(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022))) 

Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[,DistrictCode:=strtail(paste0("0", DistrictCode), 2)]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[,SchoolCode:=strtail(paste0("0", SchoolCode), 5)]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[DistrictCode=="NA", DistrictCode:=as.character(NA)]
District_Names_2021[,DistrictName:=as.character(sapply(DistrictName, SGP:::capwords))]
School_Names_2021 <- School_Names_2021[,Sname:=as.character(sapply(Sname, SGP:::capwords))][,c("resp_schcode", "Sname"), with=FALSE]
setnames(School_Names_2021, c("resp_schcode", "Sname"), c("SchoolCode", "SchoolName"))
setkey(District_Names_2021, DistrictCode)
setkey(School_Names_2021, SchoolCode)
setkey(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022, DistrictCode)
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022 <- District_Names_2021[Rhode_Island_Data_LONG_PSAT_SAT_2021_2022]
setkey(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022, SchoolCode)
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022 <- School_Names_2021[Rhode_Island_Data_LONG_PSAT_SAT_2021_2022]
setnames(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022, "FORM_CODE", 'FORM')

factor.vars <- c("STUDENT_LAST", "STUDENT_FIRST_NAME", "ELA_PROFICIENCY", "MATH_PROFICIENCY")
for(v in factor.vars) Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[, (v) := factor(eval(parse(text=v)))]

setattr(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022$STUDENT_LAST, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022$STUDENT_LAST), SGP:::capwords)))
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022$STUDENT_FIRST_NAME, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022$STUDENT_FIRST_NAME), SGP:::capwords)))
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[ELA_PROFICIENCY==44, ELA_PROFICIENCY:=NA]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[,ELA_PROFICIENCY:=as.factor(as.character(ELA_PROFICIENCY))]
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022$ELA_PROFICIENCY, "levels", c("Not Meeting Expectations", "Partially Meeting Expectations", "Meeting Expectations", "Exceeding Expectations"))
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022$MATH_PROFICIENCY, "levels", c("Not Meeting Expectations", "Partially Meeting Expectations", "Meeting Expectations", "Exceeding Expectations"))

###   Create LONG file - remove other set of content area scores and establish CONTENT_AREA variable
ela <- copy(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022)[, c("MATH_SECTION_SCORE", "MATH_PROFICIENCY", "MATH_PARTICIPATED_INDICATOR") := NULL]
mat <- copy(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022)[, c("EVIDENCE_BASED_READING_AND_WRITING_SECTION_SCORE", "ELA_PROFICIENCY", "EVIDENCE_BASED_READING_AND_WRITING_PARTICIPATED_INDICATOR") := NULL]
ela[GRADE=="10", CONTENT_AREA:="ELA_PSAT_10"]
ela[GRADE=="11", CONTENT_AREA:="ELA_SAT"]
mat[GRADE=="10", CONTENT_AREA:="MATHEMATICS_PSAT_10"]
mat[GRADE=="11", CONTENT_AREA:="MATHEMATICS_SAT"]

### Fix up ETHNICITY 
ela[,DERIVED_AGGREGATE_RACE_ETHNICITY:=as.factor(DERIVED_AGGREGATE_RACE_ETHNICITY)]
mat[,DERIVED_AGGREGATE_RACE_ETHNICITY:=as.factor(DERIVED_AGGREGATE_RACE_ETHNICITY)]
setattr(ela$DERIVED_AGGREGATE_RACE_ETHNICITY, "levels", c("No Primary Race/Ethnicity Reported", "American Indian or Alaska Native", "Asian", "Black or African American", "Hispanic or Latino", "Native Hawaiian or Pacific Islander", "White", "Other", "Multiple Ethnicities Reported"))
setattr(mat$DERIVED_AGGREGATE_RACE_ETHNICITY, "levels", c("No Primary Race/Ethnicity Reported", "American Indian or Alaska Native", "Asian", "Black or African American", "Hispanic or Latino", "Native Hawaiian or Pacific Islander", "White", "Other", "Multiple Ethnicities Reported"))

setnames(ela, variable.names.new_PSAT_SAT)
setnames(mat, variable.names.new_PSAT_SAT)

Rhode_Island_Data_LONG_PSAT_SAT_2021_2022 <- rbindlist(list(ela, mat))
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[GRADE %in% c("10", "11"), GRADE:="EOCT"]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[,ID:=as.character(ID)]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[,ACHIEVEMENT_LEVEL:=as.character(ACHIEVEMENT_LEVEL)]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

# ###   Tidy Up data
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[, YEAR:="2021_2022"]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[, VALID_CASE:="VALID_CASE"]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[, EMH_LEVEL := "High"]

# ###  Enrollment (FAY) Variables
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[,STATE_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[,DISTRICT_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[,SCHOOL_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]

Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[PARTICIPATION=="", PARTICIPATION:="N"]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[PARTICIPATION=="N", STATE_ENROLLMENT_STATUS:="Enrolled State: No"]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[PARTICIPATION=="N", DISTRICT_ENROLLMENT_STATUS:="Enrolled District: No"]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[PARTICIPATION=="N", SCHOOL_ENROLLMENT_STATUS:="Enrolled School: No"]
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022[PARTICIPATION=="N", VALID_CASE:="INVALID_CASE"]


### Create CSEM lookup from Excel file
SHEET_1 <- read_excel("Data/Base_Files/SATSuite_CSEMRequest_2022SchoolDayAdmin_RI_updated_1.xlsx", sheet=1, skip=2)
SHEET_2 <- read_excel("Data/Base_Files/SATSuite_CSEMRequest_2022SchoolDayAdmin_RI_updated_1.xlsx", sheet=2, skip=2)
SHEET_3 <- read_excel("Data/Base_Files/SATSuite_CSEMRequest_2022SchoolDayAdmin_RI_updated_1.xlsx", sheet=3, skip=2)

SHEET_1_FORMS_1 <- c(12007029, 12006982, 12007011, 12007059) 
SHEET_1_FORMS_2 <- c(12006962, 12007000, 12006992, 12007058, 12007030)
SHEET_1_FORMS_3 <- c(12007109, 12007136, 12007157, 12007110, 12007125, 12007158, 12007111, 12007126, 12007150, 12007096, 12007160, 12007185)
SHEET_1_FORMS_4 <- c(12007084, 12007086, 12007090, 12007104, 12007105, 12007107, 12007121, 12007123, 12007135, 12007140, 12007147, 12007152, 12007167, 12007171, 12007183, 12007189, 12007193, 12007137, 12007159, 12007139)
SHEET_1_FORMS_5 <- c(12007399, 12007426, 12007385, 12007362)
SHEET_1_FORMS_6 <- c(12007375, 12007414, 12007368, 12007400)
SHEET_1_FORMS_7 <- c(12007358, 12007421, 12007420, 12007350, 12007409, 12007396)

SHEET_2_FORMS_1 <- c(12007151, 12007178, 12007195, 12007131)
SHEET_2_FORMS_2 <- c(12007194, 12007153, 12007116, 12007117)
SHEET_2_FORMS_3 <- c(12007365, 12007359, 12007372, 12007360)
SHEET_2_FORMS_4 <- c(12007423, 12007436, 12007352, 12007366)

SHEET_3_FORMS_1 <- c(12007225, 12007231, 12007253, 12007219)
SHEET_3_FORMS_2 <- c(12007217, 12007224, 12007230,  12007234, 12007235, 12007239, 12007243, 12007247, 12007248, 12007251, 12007244, 12007240)
SHEET_3_FORMS_3 <- c(12007212, 12007213, 12007215, 12007221, 12007216, 12007228, 12007223, 12007229)
SHEET_3_FORMS_4 <- c(12007211, 12007214, 12007222, 12007238)
SHEET_3_FORMS_5 <- c(12007236, 12007210, 12007226, 12007209, 12007208, 12007255, 12007241, 12007245)

SHEET_1_FORMS_1_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_1[['Scale Score']], 2*length(SHEET_1_FORMS_1)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_1)), rep("ELA_SAT", nrow(SHEET_1))), length(SHEET_1_FORMS_1)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_1[[2]], SHEET_1[[3]]), length(SHEET_1_FORMS_1)),
                        FORM=rep(SHEET_1_FORMS_1, each=2*nrow(SHEET_1))
                        )

SHEET_1_FORMS_2_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_1[['Scale Score']], 2*length(SHEET_1_FORMS_2)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_1)), rep("ELA_SAT", nrow(SHEET_1))), length(SHEET_1_FORMS_2)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_1[[4]], SHEET_1[[5]]), length(SHEET_1_FORMS_2)),
                        FORM=rep(SHEET_1_FORMS_2, each=2*nrow(SHEET_1))
                        )
SHEET_1_FORMS_3_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_1[['Scale Score']], 2*length(SHEET_1_FORMS_3)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_1)), rep("ELA_SAT", nrow(SHEET_1))), length(SHEET_1_FORMS_3)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_1[[6]], SHEET_1[[7]]), length(SHEET_1_FORMS_3)),
                        FORM=rep(SHEET_1_FORMS_3, each=2*nrow(SHEET_1))
                        )

SHEET_1_FORMS_4_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_1[['Scale Score']], 2*length(SHEET_1_FORMS_4)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_1)), rep("ELA_SAT", nrow(SHEET_1))), length(SHEET_1_FORMS_4)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_1[[8]], SHEET_1[[9]]), length(SHEET_1_FORMS_4)),
                        FORM=rep(SHEET_1_FORMS_4, each=2*nrow(SHEET_1))
                        )

SHEET_1_FORMS_5_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_1[['Scale Score']], 2*length(SHEET_1_FORMS_5)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_1)), rep("ELA_SAT", nrow(SHEET_1))), length(SHEET_1_FORMS_5)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_1[[10]], SHEET_1[[11]]), length(SHEET_1_FORMS_5)),
                        FORM=rep(SHEET_1_FORMS_5, each=2*nrow(SHEET_1))
                        )

SHEET_1_FORMS_6_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_1[['Scale Score']], 2*length(SHEET_1_FORMS_6)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_1)), rep("ELA_SAT", nrow(SHEET_1))), length(SHEET_1_FORMS_6)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_1[[12]], SHEET_1[[13]]), length(SHEET_1_FORMS_6)),
                        FORM=rep(SHEET_1_FORMS_6, each=2*nrow(SHEET_1))
                        )

SHEET_1_FORMS_7_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_1[['Scale Score']], 2*length(SHEET_1_FORMS_7)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_1)), rep("ELA_SAT", nrow(SHEET_1))), length(SHEET_1_FORMS_7)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_1[[14]], SHEET_1[[15]]), length(SHEET_1_FORMS_7)),
                        FORM=rep(SHEET_1_FORMS_7, each=2*nrow(SHEET_1))
                        )

SHEET_2_FORMS_1_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_2[['Scale Score']], 2*length(SHEET_2_FORMS_1)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_2)), rep("ELA_SAT", nrow(SHEET_2))), length(SHEET_2_FORMS_1)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_2[[2]], SHEET_2[[3]]), length(SHEET_2_FORMS_1)),
                        FORM=rep(SHEET_2_FORMS_1, each=2*nrow(SHEET_2))
                        )

SHEET_2_FORMS_2_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_2[['Scale Score']], 2*length(SHEET_2_FORMS_2)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_2)), rep("ELA_SAT", nrow(SHEET_2))), length(SHEET_2_FORMS_2)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_2[[2]], SHEET_2[[3]]), length(SHEET_2_FORMS_2)),
                        FORM=rep(SHEET_2_FORMS_2, each=2*nrow(SHEET_2))
                        )

SHEET_2_FORMS_3_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_2[['Scale Score']], 2*length(SHEET_2_FORMS_3)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_2)), rep("ELA_SAT", nrow(SHEET_2))), length(SHEET_2_FORMS_3)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_2[[2]], SHEET_2[[3]]), length(SHEET_2_FORMS_3)),
                        FORM=rep(SHEET_2_FORMS_3, each=2*nrow(SHEET_2))
                        )

SHEET_2_FORMS_4_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_2[['Scale Score']], 2*length(SHEET_2_FORMS_4)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_2)), rep("ELA_SAT", nrow(SHEET_2))), length(SHEET_2_FORMS_4)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_2[[2]], SHEET_2[[3]]), length(SHEET_2_FORMS_4)),
                        FORM=rep(SHEET_2_FORMS_4, each=2*nrow(SHEET_2))
                        )

SHEET_3_FORMS_1_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_3[['Scale Score']], 2*length(SHEET_3_FORMS_1)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_3)), rep("ELA_SAT", nrow(SHEET_3))), length(SHEET_3_FORMS_1)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_3[[2]], SHEET_3[[3]]), length(SHEET_3_FORMS_1)),
                        FORM=rep(SHEET_3_FORMS_1, each=2*nrow(SHEET_3))
                        )

SHEET_3_FORMS_2_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_3[['Scale Score']], 2*length(SHEET_3_FORMS_2)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_3)), rep("ELA_SAT", nrow(SHEET_3))), length(SHEET_3_FORMS_2)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_3[[2]], SHEET_3[[3]]), length(SHEET_3_FORMS_2)),
                        FORM=rep(SHEET_3_FORMS_2, each=2*nrow(SHEET_3))
                        )

SHEET_3_FORMS_3_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_3[['Scale Score']], 2*length(SHEET_3_FORMS_3)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_3)), rep("ELA_SAT", nrow(SHEET_3))), length(SHEET_3_FORMS_3)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_3[[2]], SHEET_3[[3]]), length(SHEET_3_FORMS_3)),
                        FORM=rep(SHEET_3_FORMS_3, each=2*nrow(SHEET_3))
                        )

SHEET_3_FORMS_4_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_3[['Scale Score']], 2*length(SHEET_3_FORMS_4)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_3)), rep("ELA_SAT", nrow(SHEET_3))), length(SHEET_3_FORMS_4)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_3[[2]], SHEET_3[[3]]), length(SHEET_3_FORMS_4)),
                        FORM=rep(SHEET_3_FORMS_4, each=2*nrow(SHEET_3))
                        )

SHEET_3_FORMS_5_LONG <- data.table(
                        SCALE_SCORE=rep(SHEET_3[['Scale Score']], 2*length(SHEET_3_FORMS_5)),
                        CONTENT_AREA=rep(c(rep("MATHEMATICS_SAT", nrow(SHEET_3)), rep("ELA_SAT", nrow(SHEET_3))), length(SHEET_3_FORMS_5)),
                        SCALE_SCORE_CSEM=rep(c(SHEET_3[[2]], SHEET_3[[3]]), length(SHEET_3_FORMS_5)),
                        FORM=rep(SHEET_3_FORMS_5, each=2*nrow(SHEET_3))
                        )

CSEM_Data <- rbindlist(list(SHEET_1_FORMS_1_LONG, SHEET_1_FORMS_2_LONG, SHEET_1_FORMS_3_LONG, SHEET_1_FORMS_4_LONG, SHEET_1_FORMS_5_LONG, SHEET_1_FORMS_6_LONG, SHEET_1_FORMS_7_LONG,
                        SHEET_2_FORMS_1_LONG, SHEET_2_FORMS_2_LONG, SHEET_2_FORMS_3_LONG, SHEET_2_FORMS_4_LONG,
                        SHEET_3_FORMS_1_LONG, SHEET_3_FORMS_2_LONG, SHEET_3_FORMS_3_LONG, SHEET_3_FORMS_4_LONG, SHEET_3_FORMS_5_LONG)
                        )

### Merge CSEM_Data with Rhode_Island_Data_LONG_PSAT_SAT_2021_2022
setkey(CSEM_Data, CONTENT_AREA, SCALE_SCORE, FORM)
setkey(Rhode_Island_Data_LONG_PSAT_SAT_2021_2022, CONTENT_AREA, SCALE_SCORE, FORM)
Rhode_Island_Data_LONG_PSAT_SAT_2021_2022 <- CSEM_Data[Rhode_Island_Data_LONG_PSAT_SAT_2021_2022]


### rbind RICAS and PSAT/SAT data
Rhode_Island_Data_LONG_2021_2022 <- rbindlist(list(Rhode_Island_Data_LONG_RICAS_2021_2022, Rhode_Island_Data_LONG_PSAT_SAT_2021_2022), fill=TRUE)

### Invalidate original case 
Rhode_Island_Data_LONG_2021_2022[ORIGINAL_DATA==TRUE & ID=="1000277800", VALID_CASE:="INVALID_CASE"]

### Resolve duplicates
#setkey(Rhode_Island_Data_LONG_2021_2022, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
#setkey(Rhode_Island_Data_LONG_2021_2022, VALID_CASE, CONTENT_AREA, YEAR, ID)
#dups <- Rhode_Island_Data_LONG_2021_2022[VALID_CASE=="VALID_CASE"][c(which(duplicated(Rhode_Island_Data_LONG_2021_2022[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_2021_2022)))-1, which(duplicated(Rhode_Island_Data_LONG_2021_2022[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_2021_2022)))),]
#setkeyv(dups, key(Rhode_Island_Data_LONG_2021_2022))  #  0 duplicate cases RICAS/PSAT/SAT data 9/2/22
#Rhode_Island_Data_LONG_2021_2022[which(duplicated(Rhode_Island_Data_LONG_2021_2022, by=key(Rhode_Island_Data_LONG_2021_2022)))-1, VALID_CASE:="INVALID_CASE"]

### Save results
setkey(Rhode_Island_Data_LONG_2021_2022, VALID_CASE, CONTENT_AREA, YEAR, ID)
save(Rhode_Island_Data_LONG_2021_2022, file="Data/Rhode_Island_Data_LONG_2021_2022.Rdata")
