########################################################################################################
### R script to create formatted results by incorporated SGP and SGP_STANDARD_ERROR into original files
########################################################################################################

### Load packages

require(data.table)


#######################
### PSAT/SAT Data
#######################

### Load Data

load("Data/Rhode_Island_SGP_WIDE_Data.Rdata")

Rhode_Island_Data_SAT_2019 <- fread("Data/Base_Files/SAT-07-18-2019_REVIEWED.csv", stringsAsFactors=FALSE)
setnames(Rhode_Island_Data_SAT_2019, "SECONDARY SCHOOL STUDENT ID", "SECONDARY_SCHOOL_STUDENT_ID")
Rhode_Island_Data_SAT_2019[,"SECONDARY_SCHOOL_STUDENT_ID":=as.character(SECONDARY_SCHOOL_STUDENT_ID)]
tmp.dt.to.merge <- Rhode_Island_SGP_WIDE_Data[,c("ID", "SGP.2018_2019.ELA_SAT", "SGP_STANDARD_ERROR.2018_2019.ELA_SAT", "SGP.2018_2019.MATHEMATICS_SAT", "SGP_STANDARD_ERROR.2018_2019.MATHEMATICS_SAT"), with=FALSE]
setnames(tmp.dt.to.merge, c("SECONDARY_SCHOOL_STUDENT_ID", "SGP_ela", "SGP_ela_SE", "SGP_math", "SGP_math_SE"))
setcolorder(tmp.dt.to.merge, c(1, 4, 2, 5, 3))
tmp.dt.to.merge <- tmp.dt.to.merge[!is.na(SGP_math) | !is.na(SGP_ela)]
setkeyv(tmp.dt.to.merge, "SECONDARY_SCHOOL_STUDENT_ID")
Rhode_Island_Data_SAT_2019[,c("SGP_math", "SGP_ela", "SGP_math_SE", "SGP_ela_SE"):=NULL]
setkeyv(Rhode_Island_Data_SAT_2019, "SECONDARY_SCHOOL_STUDENT_ID")
Rhode_Island_SGP_LONG_Data_2018_2019_SAT_FORMATTED <- tmp.dt.to.merge[Rhode_Island_Data_SAT_2019]
setnames(Rhode_Island_SGP_LONG_Data_2018_2019_SAT_FORMATTED, "SECONDARY_SCHOOL_STUDENT_ID", "SECONDARY SCHOOL STUDENT ID")
setcolorder(Rhode_Island_SGP_LONG_Data_2018_2019_SAT_FORMATTED, names(fread("Data/Base_Files/SAT-07-18-2019_REVIEWED.csv", stringsAsFactors=FALSE)))
save(Rhode_Island_SGP_LONG_Data_2018_2019_SAT_FORMATTED, file="Data/Rhode_Island_SGP_LONG_Data_2018_2019_SAT_FORMATTED.Rdata")
fwrite(Rhode_Island_SGP_LONG_Data_2018_2019_SAT_FORMATTED, file="Data/Rhode_Island_SGP_LONG_Data_2018_2019_SAT_FORMATTED.txt", sep="|")


######################
### RICAS Data
######################

### Load Data

load("Data/Rhode_Island_SGP_WIDE_Data.Rdata")

Rhode_Island_Data_RICAS_2019 <- fread("Data/Base_Files/RICAS2019-PRE-DISCREPANCY-MegaFile-2019-08-08.csv", stringsAsFactors=FALSE)
Rhode_Island_Data_RICAS_2019[,sasid:=as.character(sasid)]
Rhode_Island_Data_RICAS_2019[,e_sgp:=as.integer(e_sgp)]
Rhode_Island_Data_RICAS_2019[,e_sgpSE:=as.numeric(e_sgpSE)]
Rhode_Island_Data_RICAS_2019[,m_sgp:=as.integer(m_sgp)]
Rhode_Island_Data_RICAS_2019[,m_sgpSE:=as.numeric(m_sgpSE)]
tmp.dt.to.merge <- Rhode_Island_SGP_WIDE_Data[,c("ID", "SGP.2018_2019.ELA", "SGP_STANDARD_ERROR.2018_2019.ELA", "SGP.2018_2019.MATHEMATICS", "SGP_STANDARD_ERROR.2018_2019.MATHEMATICS", "SCALE_SCORE_ACTUAL.2018_2019.ELA", "SCALE_SCORE_ACTUAL.2018_2019.MATHEMATICS"), with=FALSE]

#################################################################
##### Convert perfect scores (560) on RICAS to SGPs of 99
#################################################################

tmp.dt.to.merge[SCALE_SCORE_ACTUAL.2018_2019.ELA==560 & !is.na(SGP.2018_2019.ELA), SGP.2018_2019.ELA:=99]
tmp.dt.to.merge[SCALE_SCORE_ACTUAL.2018_2019.MATHEMATICS==560 & !is.na(SGP.2018_2019.MATHEMATICS), SGP.2018_2019.MATHEMATICS:=99]

tmp.dt.to.merge[,c("SCALE_SCORE_ACTUAL.2018_2019.ELA", "SCALE_SCORE_ACTUAL.2018_2019.MATHEMATICS"):=NULL]

#################################################################

setnames(tmp.dt.to.merge, c("sasid", "e_sgp", "e_sgpSE", "m_sgp", "m_sgpSE"))
tmp.dt.to.merge <- tmp.dt.to.merge[!is.na(e_sgp) | !is.na(m_sgp)]
setkeyv(tmp.dt.to.merge, "sasid")
setkeyv(Rhode_Island_Data_RICAS_2019, "sasid")
Rhode_Island_Data_RICAS_2019[tmp.dt.to.merge$sasid, c("e_sgp", "e_sgpSE", "m_sgp", "m_sgpSE"):=tmp.dt.to.merge[,c("e_sgp", "e_sgpSE", "m_sgp", "m_sgpSE"), with=FALSE]]
Rhode_Island_SGP_LONG_2018_2019_RICAS_FORMATTED <- Rhode_Island_Data_RICAS_2019
#save(Rhode_Island_SGP_LONG_2018_2019_RICAS_FORMATTED, file="Data/Rhode_Island_SGP_LONG_2018_2019_RICAS_FORMATTED.Rdata")
#fwrite(Rhode_Island_SGP_LONG_2018_2019_RICAS_FORMATTED, file="Data/Rhode_Island_SGP_LONG_2018_2019_RICAS_FORMATTED.txt", sep="|")
