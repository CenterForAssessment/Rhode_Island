####################################################################
###                                                              ###
###   Script for creating Rhode Island LONG Data for 2025-2026   ###
###                                                              ###
####################################################################

###   Load required packages
require(data.table)
require(foreign)
require(openxlsx)

#######################################################################
### RICAS
#######################################################################

###   Load Data
Rhode_Island_Data_LONG_RICAS_2025_2026 <- fread("Data/Base_Files/RICAS2026.csv", stringsAsFactors=FALSE, encoding="Latin-1")

### Preliminary cleanup of ethnicity data 
Rhode_Island_Data_LONG_RICAS_2025_2026[asian=="Y", RACE7:="AS7"]
Rhode_Island_Data_LONG_RICAS_2025_2026[AIAN=="Y", RACE7:="AM7"]
Rhode_Island_Data_LONG_RICAS_2025_2026[BAA=="Y", RACE7:="BL7"]
Rhode_Island_Data_LONG_RICAS_2025_2026[hispanic=="Y", RACE7:="HI7"]
Rhode_Island_Data_LONG_RICAS_2025_2026[NHOPI=="Y", RACE7:="PI7"]
Rhode_Island_Data_LONG_RICAS_2025_2026[white=="Y", RACE7:="WH7"]
Rhode_Island_Data_LONG_RICAS_2025_2026[tworaces=="Y", RACE7:="M7"]

### Cleanup data
variables.to.keep_RICAS <- c(
      "sasid", "lastname", "firstname", "grade", "stugrade",
      "resp_discode", "resp_schcode", "resp_disname", "resp_schname",
      "escaleds", "eperflev", "e_ssSEM", "e_theta", "e_thetaSEM", "emode",
      "mscaleds", "mperflev", "m_ssSEM", "m_theta", "m_thetaSEM", "mmode",
      "RACE7", "gender", "ecodis", "ELL", "IEP", "plan504", "enonacc")
#      "RACE7", "gender", "ecodis", "ELL", "IEP", "plan504", "enonacc", "UPDATE_FLAG")

variable.names.new_RICAS <- c(
      "ID", "LAST_NAME", "FIRST_NAME", "GRADE", "GRADE_ENROLLED",
      "DISTRICT_NUMBER", "SCHOOL_NUMBER", "DISTRICT_NAME", "SCHOOL_NAME",
      "SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL", "SCALE_SCORE_ACTUAL_CSEM", "SCALE_SCORE", "SCALE_SCORE_CSEM", "TEST_FORMAT",
      "ETHNICITY", "GENDER", "FREE_REDUCED_LUNCH_STATUS", "ELL_STATUS", "IEP_STATUS", "enonacc",
      "CONTENT_AREA")
#      "UPDATE_FLAG", "CONTENT_AREA")

Rhode_Island_Data_LONG_RICAS_2025_2026 <- Rhode_Island_Data_LONG_RICAS_2025_2026[, variables.to.keep_RICAS, with=FALSE]

factor.vars <- c("gender", "ecodis", "ELL", "IEP", "lastname", "firstname", "emode", "mmode", "eperflev", "mperflev")
for(v in factor.vars) Rhode_Island_Data_LONG_RICAS_2025_2026[, (v) := factor(eval(parse(text=v)))]

### Tidy up RICAS data
setattr(Rhode_Island_Data_LONG_RICAS_2025_2026$lastname, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_RICAS_2025_2026$lastname), SGP:::capwords)))
setattr(Rhode_Island_Data_LONG_RICAS_2025_2026$firstname, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_RICAS_2025_2026$firstname), SGP:::capwords)))
Rhode_Island_Data_LONG_RICAS_2025_2026[, grade := as.character(as.numeric(grade))]
Rhode_Island_Data_LONG_RICAS_2025_2026[, stugrade := as.character(as.numeric(stugrade))]
Rhode_Island_Data_LONG_RICAS_2025_2026[, resp_discode:=as.character(sapply(Rhode_Island_Data_LONG_RICAS_2025_2026$resp_discode, SGP:::capwords))]
Rhode_Island_Data_LONG_RICAS_2025_2026[, resp_schcode:=as.character(sapply(Rhode_Island_Data_LONG_RICAS_2025_2026$resp_schcode, SGP:::capwords))]
Rhode_Island_Data_LONG_RICAS_2025_2026[, resp_disname:=as.character(sapply(Rhode_Island_Data_LONG_RICAS_2025_2026$resp_disname, SGP:::capwords))]
Rhode_Island_Data_LONG_RICAS_2025_2026[, resp_schname:=as.character(sapply(Rhode_Island_Data_LONG_RICAS_2025_2026$resp_schname, SGP:::capwords))]
setattr(Rhode_Island_Data_LONG_RICAS_2025_2026$eperflev, "levels", c("Not Meeting Expectations", "Partially Meeting Expectations", "Meeting Expectations", "Exceeding Expectations"))
setattr(Rhode_Island_Data_LONG_RICAS_2025_2026$mperflev, "levels", c("Not Meeting Expectations", "Partially Meeting Expectations", "Meeting Expectations", "Exceeding Expectations"))
Rhode_Island_Data_LONG_RICAS_2025_2026[,RACE7:=as.factor(RACE7)]
setattr(Rhode_Island_Data_LONG_RICAS_2025_2026$RACE7, "levels", c("American Indian or Alaskan Native", "Asian", "Black or African American", "Hispanic or Latino", "Multiple Ethnicities Reported", "Native Hawaiian or Pacific Islander", "White"))
setattr(Rhode_Island_Data_LONG_RICAS_2025_2026$gender, "levels", c("Female", "Male", "Other"))

###   Other Demographic Variables
Rhode_Island_Data_LONG_RICAS_2025_2026[plan504 == "Y", IEP := "Students with 504 Plan"]
Rhode_Island_Data_LONG_RICAS_2025_2026[,plan504:=NULL]
levels(Rhode_Island_Data_LONG_RICAS_2025_2026$IEP) <- c("Students without Disabilities (Non-IEP)", "Students with Disabilities (IEP)", "Students with 504 Plan")

levels(Rhode_Island_Data_LONG_RICAS_2025_2026$ecodis) <- c("Not Economically Disadvantaged", "Economically Disadvantaged")
levels(Rhode_Island_Data_LONG_RICAS_2025_2026$ELL) <- c("Non-English Language Learners (ELL)", "English Language Learners (ELL)")

###   Create LONG file - remove other set of content area scores and establish CONTENT_AREA variable
ela <- copy(Rhode_Island_Data_LONG_RICAS_2025_2026)[, c("mscaleds", "mperflev", "m_ssSEM", "m_theta", "m_thetaSEM", "mmode") := NULL][, CONTENT_AREA := "ELA"]
mat <- copy(Rhode_Island_Data_LONG_RICAS_2025_2026)[, c("escaleds", "eperflev", "e_ssSEM", "e_theta", "e_thetaSEM", "emode") := NULL][, CONTENT_AREA := "MATHEMATICS"]

setnames(ela, variable.names.new_RICAS)
setnames(mat, variable.names.new_RICAS)

Rhode_Island_Data_LONG_RICAS_2025_2026 <- rbindlist(list(ela, mat))

###   Tidy Up data
Rhode_Island_Data_LONG_RICAS_2025_2026[, YEAR := "2025_2026"]
Rhode_Island_Data_LONG_RICAS_2025_2026[, VALID_CASE := "VALID_CASE"]
Rhode_Island_Data_LONG_RICAS_2025_2026[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_RICAS_2025_2026[,enonacc := NULL]
levels(Rhode_Island_Data_LONG_RICAS_2025_2026$TEST_FORMAT) <- c("Online", "Paper")
Rhode_Island_Data_LONG_RICAS_2025_2026[, TEST_FORMAT := as.character(TEST_FORMAT)]
Rhode_Island_Data_LONG_RICAS_2025_2026[, ID:=as.character(ID)]

###  Enrollment (FAY) Variables
Rhode_Island_Data_LONG_RICAS_2025_2026[,STATE_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
Rhode_Island_Data_LONG_RICAS_2025_2026[,DISTRICT_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
Rhode_Island_Data_LONG_RICAS_2025_2026[,SCHOOL_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]

### Copy SCALE_SCORE_ACTUAL to SCALE_SCORE_RICAS
Rhode_Island_Data_LONG_RICAS_2025_2026[,SCALE_SCORE_RICAS:=SCALE_SCORE_ACTUAL]
setkey(Rhode_Island_Data_LONG_RICAS_2025_2026, VALID_CASE, CONTENT_AREA, YEAR, ID)

### Resolve duplicates
setkey(Rhode_Island_Data_LONG_RICAS_2025_2026, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Rhode_Island_Data_LONG_RICAS_2025_2026, VALID_CASE, CONTENT_AREA, YEAR, ID)
dups <- Rhode_Island_Data_LONG_RICAS_2025_2026[VALID_CASE=="VALID_CASE"][c(which(duplicated(Rhode_Island_Data_LONG_RICAS_2025_2026[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_RICAS_2025_2026)))-1, which(duplicated(Rhode_Island_Data_LONG_RICAS_2025_2026[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_RICAS_2025_2026)))),]
#setkeyv(dups, key(Rhode_Island_Data_LONG_RICAS_2025_2026)) ### 0 dups 2024 
#Rhode_Island_Data_LONG_RICAS_2025_2026[which(duplicated(Rhode_Island_Data_LONG_RICAS_2025_2026, by=key(Rhode_Island_Data_LONG_RICAS_2025_2026)))-1, VALID_CASE:="INVALID_CASE"]

#######################################################################
### PSAT/SAT
#######################################################################

###   Load Data
Rhode_Island_Data_LONG_PSAT_2025_2026 <- fread("Data/Base_Files/RI_STATE_ACCT_RPT_PSAT10_05292026.csv", fill=TRUE, sep=",")
Rhode_Island_Data_LONG_SAT_2025_2026 <- fread("Data/Base_Files/RI_STATE_ACCT_RPT_SAT_05292026.csv", fill=TRUE, sep=",")

District_Names_2021 <- as.data.table(read.spss("Data/Base_Files/2021Districts.sav"))
School_Names_2021 <- as.data.table(read.spss("Data/Base_Files/2021Schools.sav"))

### Cleanup data
variables.to.keep_PSAT <- c(
      "RESPONSIBLE_SCHCODE", "RESPONSIBLE_DISTCODE",
      "SASID", "STUDENT LAST", "STUDENT FIRST", "GRADE_LEVEL_CB",
      "EBRW_TOTAL_SCORE", "ELA_PERFLEVEL", "MATH_TOTAL_SCORE", "MATH_PERFLEVEL",
      "DERIVED AGGREGATE RACE ETHNICITY", "SEX", "ATTEMPT_ELA", "ATTEMPT_MATH", "ELA_scalescoreSE", "Math_scalescoreSE")

variables.to.keep_SAT <- c(
      "RESPONSIBLE_SCHCODE", "RESPONSIBLE_DISTCODE",
      "SASID", "STUDENT LAST", "STUDENT FIRST", "GRADE_LEVEL_CB",
      "EBRW_TOTAL_SCORE", "ELA_PERFLEVEL", "MATH_TOTAL_SCORE", "MATH_PERFLEVEL",
      "DERIVED AGGREGATE RACE ETHNICITY", "SEX", "ATTEMPT_ELA", "ATTEMPT_MATH", "ELA_scalescoreSE", "Math_scalescoreSE")

variable.names.new_PSAT_SAT <- c(
      "SCHOOL_NUMBER", "SCHOOL_NAME", "DISTRICT_NUMBER", "DISTRICT_NAME",
      "ID", "LAST_NAME", "FIRST_NAME", "GRADE_ENROLLED",
      "SCALE_SCORE", "ACHIEVEMENT_LEVEL",
      "ETHNICITY", "GENDER",
      "PARTICIPATION", "SCALE_SCORE_CSEM", "GRADE", "CONTENT_AREA")

Rhode_Island_Data_LONG_PSAT_2025_2026 <- Rhode_Island_Data_LONG_PSAT_2025_2026[, variables.to.keep_PSAT, with=FALSE]
Rhode_Island_Data_LONG_SAT_2025_2026 <- Rhode_Island_Data_LONG_SAT_2025_2026[, variables.to.keep_SAT, with=FALSE]

setnames(Rhode_Island_Data_LONG_PSAT_2025_2026, "GRADE_LEVEL_CB", "GRADE_ENROLLED")
setnames(Rhode_Island_Data_LONG_SAT_2025_2026, "GRADE_LEVEL_CB", "GRADE_ENROLLED")
Rhode_Island_Data_LONG_PSAT_2025_2026[,GRADE_ENROLLED:=as.character(as.numeric(GRADE_ENROLLED))]
Rhode_Island_Data_LONG_SAT_2025_2026[,GRADE_ENROLLED:=as.character(as.numeric(GRADE_ENROLLED))]
Rhode_Island_Data_LONG_PSAT_2025_2026[GRADE_ENROLLED=="5", GRADE_ENROLLED:="10"]
Rhode_Island_Data_LONG_PSAT_2025_2026[GRADE_ENROLLED=="6", GRADE_ENROLLED:="11"]
Rhode_Island_Data_LONG_SAT_2025_2026[GRADE_ENROLLED=="5", GRADE_ENROLLED:="10"]
Rhode_Island_Data_LONG_SAT_2025_2026[GRADE_ENROLLED=="6", GRADE_ENROLLED:="11"]
Rhode_Island_Data_LONG_PSAT_2025_2026[,GRADE:="10"]
Rhode_Island_Data_LONG_SAT_2025_2026[,GRADE:="11"]

Rhode_Island_Data_LONG_PSAT_SAT_2025_2026 <- rbindlist(list(Rhode_Island_Data_LONG_PSAT_2025_2026, Rhode_Island_Data_LONG_SAT_2025_2026), fill=TRUE)
setnames(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026, c("RESPONSIBLE_DISTCODE", "RESPONSIBLE_SCHCODE"), c("DistrictCode", "SchoolCode"))
setnames(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026, gsub(" ", "_", names(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026))) 

Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[,DistrictCode:=strTail(paste0("0", DistrictCode), 2)]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[,SchoolCode:=strTail(paste0("0", SchoolCode), 5)]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[DistrictCode=="NA", DistrictCode:=as.character(NA)]
District_Names_2021[,DistrictName:=as.character(sapply(DistrictName, SGP:::capwords))]
School_Names_2021 <- School_Names_2021[,Sname:=as.character(sapply(Sname, SGP:::capwords))][,c("resp_schcode", "Sname"), with=FALSE]
setnames(School_Names_2021, c("resp_schcode", "Sname"), c("SchoolCode", "SchoolName"))
setkey(District_Names_2021, DistrictCode)
setkey(School_Names_2021, SchoolCode)
setkey(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026, DistrictCode)
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026 <- District_Names_2021[Rhode_Island_Data_LONG_PSAT_SAT_2025_2026]
setkey(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026, SchoolCode)
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026 <- School_Names_2021[Rhode_Island_Data_LONG_PSAT_SAT_2025_2026]

factor.vars <- c("STUDENT_LAST", "STUDENT_FIRST", "ELA_PERFLEVEL", "MATH_PERFLEVEL", "SEX")
for(v in factor.vars) Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[, (v) := factor(eval(parse(text=v)))]
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026$STUDENT_LAST, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026$STUDENT_LAST), SGP:::capwords)))
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026$STUDENT_FIRST, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026$STUDENT_FIRST), SGP:::capwords)))
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[,ELA_PERFLEVEL:=as.factor(as.character(ELA_PERFLEVEL))]
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026$ELA_PERFLEVEL, "levels", c("Not Meeting Expectations", "Partially Meeting Expectations", "Meeting Expectations", "Exceeding Expectations"))
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026$MATH_PERFLEVEL, "levels", c("Not Meeting Expectations", "Partially Meeting Expectations", "Meeting Expectations", "Exceeding Expectations"))
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026$SEX, "levels", c("Other", "Female", "Male"))

###   Create LONG file - remove other set of content area scores and establish CONTENT_AREA variable
ela <- copy(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026)[, c("MATH_TOTAL_SCORE", "MATH_PERFLEVEL", "ATTEMPT_MATH", "Math_scalescoreSE") := NULL]
mat <- copy(Rhode_Island_Data_LONG_PSAT_SAT_2025_2026)[, c("EBRW_TOTAL_SCORE", "ELA_PERFLEVEL", "ATTEMPT_ELA", "ELA_scalescoreSE") := NULL]
ela[GRADE=="10", CONTENT_AREA:="ELA_PSAT_10"]
ela[GRADE=="11", CONTENT_AREA:="ELA_SAT"]
mat[GRADE=="10", CONTENT_AREA:="MATHEMATICS_PSAT_10"]
mat[GRADE=="11", CONTENT_AREA:="MATHEMATICS_SAT"]

### Fix up ETHNICITY 
ela[,DERIVED_AGGREGATE_RACE_ETHNICITY:=as.factor(DERIVED_AGGREGATE_RACE_ETHNICITY)]
mat[,DERIVED_AGGREGATE_RACE_ETHNICITY:=as.factor(DERIVED_AGGREGATE_RACE_ETHNICITY)]
setattr(ela$DERIVED_AGGREGATE_RACE_ETHNICITY, "levels", c("No Primary Race/Ethnicity Reported", "American Indian or Alaska Native", "Asian", "Black or African American", "Hispanic or Latino", "Native Hawaiian or Pacific Islander", "White", "Two or More Races"))
setattr(mat$DERIVED_AGGREGATE_RACE_ETHNICITY, "levels", c("No Primary Race/Ethnicity Reported", "American Indian or Alaska Native", "Asian", "Black or African American", "Hispanic or Latino", "Native Hawaiian or Pacific Islander", "White", "Two or More Races"))

setnames(ela, variable.names.new_PSAT_SAT)
setnames(mat, variable.names.new_PSAT_SAT)

Rhode_Island_Data_LONG_PSAT_SAT_2025_2026 <- rbindlist(list(ela, mat))
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[GRADE %in% c("10", "11"), GRADE:="EOCT"]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[,ID:=as.character(ID)]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[,ACHIEVEMENT_LEVEL:=as.character(ACHIEVEMENT_LEVEL)]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

# ###   Tidy Up data
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[, YEAR:="2025_2026"]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[, VALID_CASE:="VALID_CASE"]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[, EMH_LEVEL := "High"]

# ###  Enrollment (FAY) Variables
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[,STATE_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[,DISTRICT_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[,SCHOOL_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]

Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[PARTICIPATION=="", PARTICIPATION:="N"]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[PARTICIPATION=="N", STATE_ENROLLMENT_STATUS:="Enrolled State: No"]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[PARTICIPATION=="N", DISTRICT_ENROLLMENT_STATUS:="Enrolled District: No"]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[PARTICIPATION=="N", SCHOOL_ENROLLMENT_STATUS:="Enrolled School: No"]
Rhode_Island_Data_LONG_PSAT_SAT_2025_2026[PARTICIPATION=="N", VALID_CASE:="INVALID_CASE"]

### rbind RICAS and PSAT/SAT data
#Rhode_Island_Data_LONG_2025_2026 <- Rhode_Island_Data_LONG_PSAT_SAT_2025_2026 ### TEMPORARY UNTIL RICAS data arrives
Rhode_Island_Data_LONG_2025_2026 <- rbindlist(list(Rhode_Island_Data_LONG_RICAS_2025_2026, Rhode_Island_Data_LONG_PSAT_SAT_2025_2026), fill=TRUE)

### Resolve duplicates
#setkey(Rhode_Island_Data_LONG_2025_2026, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
#setkey(Rhode_Island_Data_LONG_2025_2026, VALID_CASE, CONTENT_AREA, YEAR, ID)
#dups <- Rhode_Island_Data_LONG_2025_2026[VALID_CASE=="VALID_CASE"][c(which(duplicated(Rhode_Island_Data_LONG_2025_2026[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_2025_2026)))-1, which(duplicated(Rhode_Island_Data_LONG_2025_2026[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_2025_2026)))),]
#setkeyv(dups, key(Rhode_Island_Data_LONG_2025_2026))  #  0 duplicate cases RICAS/PSAT/SAT data 9/2/22
#Rhode_Island_Data_LONG_2025_2026[which(duplicated(Rhode_Island_Data_LONG_2025_2026, by=key(Rhode_Island_Data_LONG_2025_2026)))-1, VALID_CASE:="INVALID_CASE"]

### Save results
setkey(Rhode_Island_Data_LONG_2025_2026, VALID_CASE, CONTENT_AREA, YEAR, ID)
save(Rhode_Island_Data_LONG_2025_2026, file="Data/Rhode_Island_Data_LONG_2025_2026.Rdata")
