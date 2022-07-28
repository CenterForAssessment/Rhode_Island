####################################################################
###                                                              ###
###   Script for creating Rhode Island LONG Data for 2020_2021   ###
###                                                              ###
####################################################################

###   Load required packages
require(data.table)
require(foreign)

#######################################################################
### RICAS
#######################################################################

###   Load Data
#Rhode_Island_Data_LONG_RICAS_2020_2021 <- fread("Data/Base_Files/RICAS2021_prediscrepancy.csv", stringsAsFactors=FALSE)
#Rhode_Island_Data_LONG_RICAS_2020_2021 <- fread("Data/Base_Files/RICAS2021.csv", stringsAsFactors=FALSE)
Rhode_Island_Data_LONG_RICAS_2020_2021 <- as.data.table(read.spss("Data/Base_Files/2021RICASwDemo.sav", to.data.frame=TRUE, trim.factor.names=TRUE))

### Cleanup data
variables.to.keep_RICAS <- c(
      "sasid", "lastname", "firstname", "grade", "stugrade",
      "resp_discode", "resp_schcode", "resp_disname", "resp_schname", "resp_schlevel",
      "escaleds", "eperflev", "e_ssSEM", "e_theta", "e_thetaSEM", "emode",
      "mscaleds", "mperflev", "m_ssSEM", "m_theta", "m_thetaSEM", "mmode",
      "RACE7", "gender", "ecodis", "ELL", "IEP", "plan504", "enonacc", "ELAParticipation", "MathParticipation")

variable.names.new_RICAS <- c(
      "ID", "LAST_NAME", "FIRST_NAME", "GRADE", "GRADE_ENROLLED",
      "DISTRICT_NUMBER", "SCHOOL_NUMBER", "DISTRICT_NAME", "SCHOOL_NAME", "EMH_LEVEL",
      "SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL", "SCALE_SCORE_ACTUAL_CSEM", "SCALE_SCORE", "SCALE_SCORE_CSEM", "TEST_FORMAT",
      "ETHNICITY", "GENDER", "FREE_REDUCED_LUNCH_STATUS", "ELL_STATUS", "IEP_STATUS", "enonacc",
      "PARTICIPATION", "CONTENT_AREA")

Rhode_Island_Data_LONG_RICAS_2020_2021 <- Rhode_Island_Data_LONG_RICAS_2020_2021[, variables.to.keep_RICAS, with=FALSE]

factor.vars <- c("gender", "ecodis", "ELL", "IEP", "lastname", "firstname", "resp_schlevel", "emode", "mmode", "eperflev", "mperflev")
for(v in factor.vars) Rhode_Island_Data_LONG_RICAS_2020_2021[, (v) := factor(eval(parse(text=v)))]

### Tidy up RICAS data
setattr(Rhode_Island_Data_LONG_RICAS_2020_2021$lastname, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_RICAS_2020_2021$lastname), SGP:::capwords)))
setattr(Rhode_Island_Data_LONG_RICAS_2020_2021$firstname, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_RICAS_2020_2021$firstname), SGP:::capwords)))
Rhode_Island_Data_LONG_RICAS_2020_2021[, grade := as.character(as.numeric(grade))]
Rhode_Island_Data_LONG_RICAS_2020_2021[, stugrade := as.character(as.numeric(stugrade))]
Rhode_Island_Data_LONG_RICAS_2020_2021[, resp_discode:=as.character(sapply(Rhode_Island_Data_LONG_RICAS_2020_2021$resp_discode, SGP:::capwords))]
Rhode_Island_Data_LONG_RICAS_2020_2021[, resp_schcode:=as.character(sapply(Rhode_Island_Data_LONG_RICAS_2020_2021$resp_schcode, SGP:::capwords))]
Rhode_Island_Data_LONG_RICAS_2020_2021[, resp_disname:=as.character(sapply(Rhode_Island_Data_LONG_RICAS_2020_2021$resp_disname, SGP:::capwords))]
Rhode_Island_Data_LONG_RICAS_2020_2021[, resp_schname:=as.character(sapply(Rhode_Island_Data_LONG_RICAS_2020_2021$resp_schname, SGP:::capwords))]
setattr(Rhode_Island_Data_LONG_RICAS_2020_2021$resp_schlevel, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_RICAS_2020_2021$resp_schlevel), SGP:::capwords)))
setattr(Rhode_Island_Data_LONG_RICAS_2020_2021$eperflev, "levels", c("Not Meeting Expectations", "Partially Meeting Expectations", "Meeting Expectations", "Exceeding Expectations"))
setattr(Rhode_Island_Data_LONG_RICAS_2020_2021$mperflev, "levels", c("Not Meeting Expectations", "Partially Meeting Expectations", "Meeting Expectations", "Exceeding Expectations"))
Rhode_Island_Data_LONG_RICAS_2020_2021[,RACE7:=as.factor(RACE7)]
setattr(Rhode_Island_Data_LONG_RICAS_2020_2021$RACE7, "levels", c("American Indian or Alaskan Native", "Asian", "Black or African American", "Hispanic or Latino", "Multiple Ethnicities Reported", "Native Hawaiian or Pacific Islander", "White"))
setattr(Rhode_Island_Data_LONG_RICAS_2020_2021$gender, "levels", c("Female", "Male", "Other"))

###   Other Demographic Variables
Rhode_Island_Data_LONG_RICAS_2020_2021[plan504 == "Y", IEP := "Students with 504 Plan"]
Rhode_Island_Data_LONG_RICAS_2020_2021[,plan504:=NULL]
levels(Rhode_Island_Data_LONG_RICAS_2020_2021$IEP) <- c("Students without Disabilities (Non-IEP)", "Students with Disabilities (IEP)", "Students with 504 Plan")

levels(Rhode_Island_Data_LONG_RICAS_2020_2021$ecodis) <- c("Not Economically Disadvantaged", "Economically Disadvantaged")
levels(Rhode_Island_Data_LONG_RICAS_2020_2021$ELL) <- c("Non-English Language Learners (ELL)", "English Language Learners (ELL)")

###   Create LONG file - remove other set of content area scores and establish CONTENT_AREA variable
ela <- copy(Rhode_Island_Data_LONG_RICAS_2020_2021)[, c("mscaleds", "mperflev", "m_ssSEM", "m_theta", "m_thetaSEM", "mmode", "MathParticipation") := NULL][, CONTENT_AREA := "ELA"]
mat <- copy(Rhode_Island_Data_LONG_RICAS_2020_2021)[, c("escaleds", "eperflev", "e_ssSEM", "e_theta", "e_thetaSEM", "emode", "ELAParticipation") := NULL][, CONTENT_AREA := "MATHEMATICS"]

setnames(ela, variable.names.new_RICAS)
setnames(mat, variable.names.new_RICAS)

Rhode_Island_Data_LONG_RICAS_2020_2021 <- rbindlist(list(ela, mat))

###   Tidy Up data
Rhode_Island_Data_LONG_RICAS_2020_2021[, YEAR := "2020_2021"]
Rhode_Island_Data_LONG_RICAS_2020_2021[, VALID_CASE := "VALID_CASE"]
Rhode_Island_Data_LONG_RICAS_2020_2021[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_RICAS_2020_2021[,enonacc := NULL]
levels(Rhode_Island_Data_LONG_RICAS_2020_2021$TEST_FORMAT) <- c("Accomodated", "Online", "Paper")
Rhode_Island_Data_LONG_RICAS_2020_2021[, TEST_FORMAT := as.character(TEST_FORMAT)]
levels(Rhode_Island_Data_LONG_RICAS_2020_2021$EMH_LEVEL) <- c(NA, "Elementary", "Elementary/Middle", "High", "Middle", "PK-12")
Rhode_Island_Data_LONG_RICAS_2020_2021[, EMH_LEVEL := as.character(EMH_LEVEL)]

###  Enrollment (FAY) Variables
Rhode_Island_Data_LONG_RICAS_2020_2021[,STATE_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
Rhode_Island_Data_LONG_RICAS_2020_2021[,DISTRICT_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
Rhode_Island_Data_LONG_RICAS_2020_2021[,SCHOOL_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]

Rhode_Island_Data_LONG_RICAS_2020_2021[PARTICIPATION==0, STATE_ENROLLMENT_STATUS:="Enrolled State: No"]
Rhode_Island_Data_LONG_RICAS_2020_2021[PARTICIPATION==0, DISTRICT_ENROLLMENT_STATUS:="Enrolled District: No"]
Rhode_Island_Data_LONG_RICAS_2020_2021[PARTICIPATION==0, SCHOOL_ENROLLMENT_STATUS:="Enrolled School: No"]

### Resolve duplicates
setkey(Rhode_Island_Data_LONG_RICAS_2020_2021, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
setkey(Rhode_Island_Data_LONG_RICAS_2020_2021, VALID_CASE, CONTENT_AREA, YEAR, ID)
#dups <- Rhode_Island_Data_LONG_RICAS_2020_2021[VALID_CASE=="VALID_CASE"][c(which(duplicated(Rhode_Island_Data_LONG_RICAS_2020_2021[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_RICAS_2020_2021)))-1, which(duplicated(Rhode_Island_Data_LONG_RICAS_2020_2021[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_RICAS_2020_2021)))),]
#setkeyv(dups, key(Rhode_Island_Data_LONG_RICAS_2020_2021))  #  0 duplicate cases RICAS data 8/11/21
#Rhode_Island_Data_LONG_RICAS_2020_2021[which(duplicated(Rhode_Island_Data_LONG_RICAS_2020_2021, by=key(Rhode_Island_Data_LONG_RICAS_2020_2021)))-1, VALID_CASE:="INVALID_CASE"]


#######################################################################
### PSAT/SAT
#######################################################################

###   Load Data
Rhode_Island_Data_LONG_PSAT_2020_2021 <- as.data.table(read.spss("Data/Base_Files/2021PSATwDemo.sav", to.data.frame=TRUE, trim.factor.names=TRUE))
Rhode_Island_Data_LONG_SAT_2020_2021 <- as.data.table(read.spss("Data/Base_Files/2021SATwDemo.sav", to.data.frame=TRUE, trim.factor.names=TRUE))
District_Names_2021 <- as.data.table(read.spss("Data/Base_Files/2021Districts.sav"))
School_Names_2021 <- as.data.table(read.spss("Data/Base_Files/2021Schools.sav"))


### Cleanup data
variables.to.keep_PSAT_SAT <- c(
      "sasid", "lastname", "firstname", "grade",
      "RESPONSIBLEDISTRICTCODE", "Responsible_schcode",
      "EBRWScore", "ELA_Level", "MATHScore", "Math_Level",
      "RACE7", "sexD", "lunchdata", "lep", "iepData", "sec504data", "ELAParticipation", "MathParticipation")

variable.names.new_PSAT_SAT <- c(
      "SCHOOL_NUMBER", "SCHOOL_NAME", "DISTRICT_NUMBER", "DISTRICT_NAME",
      "ID", "LAST_NAME", "FIRST_NAME",
      "SCALE_SCORE", "ACHIEVEMENT_LEVEL",
      "ETHNICITY", "GENDER", "FREE_REDUCED_LUNCH_STATUS", "ELL_STATUS", "IEP_STATUS",
      "PARTICIPATION", "GRADE_ENROLLED", "GRADE", "CONTENT_AREA")

Rhode_Island_Data_LONG_PSAT_2020_2021 <- Rhode_Island_Data_LONG_PSAT_2020_2021[, variables.to.keep_PSAT_SAT, with=FALSE][]
Rhode_Island_Data_LONG_SAT_2020_2021 <- Rhode_Island_Data_LONG_SAT_2020_2021[, variables.to.keep_PSAT_SAT, with=FALSE]

Rhode_Island_Data_LONG_PSAT_2020_2021[,GRADE_ENROLLED:=as.character(as.numeric(grade))]
Rhode_Island_Data_LONG_SAT_2020_2021[,GRADE_ENROLLED:=as.character(as.numeric(grade))]
Rhode_Island_Data_LONG_PSAT_2020_2021[,GRADE:="10"][,grade:=NULL]
Rhode_Island_Data_LONG_SAT_2020_2021[,GRADE:="11"][,grade:=NULL]

Rhode_Island_Data_LONG_PSAT_SAT_2020_2021 <- rbindlist(list(Rhode_Island_Data_LONG_PSAT_2020_2021, Rhode_Island_Data_LONG_SAT_2020_2021))
setnames(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021, c("RESPONSIBLEDISTRICTCODE", "Responsible_schcode"), c("DistrictCode", "SchoolCode"))

### Tidy up PSAT/SAT Data
District_Names_2021[,DistrictName:=as.character(sapply(DistrictName, SGP:::capwords))]
School_Names_2021 <- School_Names_2021[,Sname:=as.character(sapply(Sname, SGP:::capwords))][,c("resp_schcode", "Sname"), with=FALSE]
setnames(School_Names_2021, c("resp_schcode", "Sname"), c("SchoolCode", "SchoolName"))
setkey(District_Names_2021, DistrictCode)
setkey(School_Names_2021, SchoolCode)
setkey(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021, DistrictCode)
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021 <- District_Names_2021[Rhode_Island_Data_LONG_PSAT_SAT_2020_2021]
setkey(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021, SchoolCode)
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021 <- School_Names_2021[Rhode_Island_Data_LONG_PSAT_SAT_2020_2021]

factor.vars <- c("lastname", "firstname", "ELA_Level", "Math_Level", "RACE7", "sexD", "lunchdata", "lep", "iepData", "sec504data")
for(v in factor.vars) Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[, (v) := factor(eval(parse(text=v)))]

setattr(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021$lastname, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021$lastname), SGP:::capwords)))
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021$firstname, "levels", as.character(sapply(levels(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021$firstname), SGP:::capwords)))
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021$ELA_Level, "levels", c("Not Meeting Expectations", "Partially Meeting Expectations", "Meeting Expectations", "Exceeding Expectations"))
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021$Math_Level, "levels", c("Not Meeting Expectations", "Partially Meeting Expectations", "Meeting Expectations", "Exceeding Expectations"))
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021$RACE7, "levels", c("American Indian or Alaskan Native", "Asian", "Black or African American", "Hispanic or Latino", "Multiple Ethnicities Reported", "Native Hawaiian or Pacific Islander", "White"))
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021$sexD, "levels", c("Female", "Male", "Other"))
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021$lunchdata, "levels", c("Not Economically Disadvantaged", "Economically Disadvantaged"))
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021$lep, "levels", c("Non-English Language Learners (ELL)", "English Language Learners (ELL)"))
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[sec504data == "Y", iepData := "Students with 504 Plan"]
setattr(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021$iep, "levels", c("Students without Disabilities (Non-IEP)", "Students with Disabilities (IEP)", "Students with 504 Plan"))
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[,sec504data:=NULL]


###   Create LONG file - remove other set of content area scores and establish CONTENT_AREA variable
ela <- copy(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021)[, c("MATHScore", "Math_Level", "MathParticipation") := NULL]
mat <- copy(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021)[, c("EBRWScore", "ELA_Level", "ELAParticipation") := NULL]
ela[GRADE=="10", CONTENT_AREA:="ELA_PSAT_10"]
ela[GRADE=="11", CONTENT_AREA:="ELA_SAT"]
mat[GRADE=="10", CONTENT_AREA:="MATHEMATICS_PSAT_10"]
mat[GRADE=="11", CONTENT_AREA:="MATHEMATICS_SAT"]

setnames(ela, variable.names.new_PSAT_SAT)
setnames(mat, variable.names.new_PSAT_SAT)

Rhode_Island_Data_LONG_PSAT_SAT_2020_2021 <- rbindlist(list(ela, mat))
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[GRADE %in% c("10", "11"), GRADE:="EOCT"]

###   Tidy Up data
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[, YEAR := "2020_2021"]
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[, VALID_CASE := "VALID_CASE"]
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[, EMH_LEVEL := "High"]

###  Enrollment (FAY) Variables
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[,STATE_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[,DISTRICT_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[,SCHOOL_ENROLLMENT_STATUS := factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]

Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[PARTICIPATION==0, STATE_ENROLLMENT_STATUS:="Enrolled State: No"]
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[PARTICIPATION==0, DISTRICT_ENROLLMENT_STATUS:="Enrolled District: No"]
Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[PARTICIPATION==0, SCHOOL_ENROLLMENT_STATUS:="Enrolled School: No"]

### rbind RICAS and PSAT/SAT data
Rhode_Island_Data_LONG_2020_2021 <- rbindlist(list(Rhode_Island_Data_LONG_RICAS_2020_2021, Rhode_Island_Data_LONG_PSAT_SAT_2020_2021), fill=TRUE)

### Resolve duplicates
#setkey(Rhode_Island_Data_LONG_2020_2021, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SCALE_SCORE)
#setkey(Rhode_Island_Data_LONG_2020_2021, VALID_CASE, CONTENT_AREA, YEAR, ID)
#dups <- Rhode_Island_Data_LONG_2020_2021[VALID_CASE=="VALID_CASE"][c(which(duplicated(Rhode_Island_Data_LONG_2020_2021[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_2020_2021)))-1, which(duplicated(Rhode_Island_Data_LONG_2020_2021[VALID_CASE=="VALID_CASE"], by=key(Rhode_Island_Data_LONG_2020_2021)))),]
#setkeyv(dups, key(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021))  #  0 duplicate cases RICAS/PSAT/SAT data 10/21/21
#Rhode_Island_Data_LONG_PSAT_SAT_2020_2021[which(duplicated(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021, by=key(Rhode_Island_Data_LONG_PSAT_SAT_2020_2021)))-1, VALID_CASE:="INVALID_CASE"]

### Save results
setkey(Rhode_Island_Data_LONG_RICAS_2020_2021, VALID_CASE, CONTENT_AREA, YEAR, ID)
save(Rhode_Island_Data_LONG_2020_2021, file="Data/Rhode_Island_Data_LONG_2020_2021.Rdata")
