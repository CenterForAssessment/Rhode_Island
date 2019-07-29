########################################################################################################
### R script to create formatted results by incorporated SGP and SGP_STANDARD_ERROR into original SAT file
########################################################################################################

Rhode_Island_Data_SAT_2019 <- fread("Data/Base_Files/SAT-07-18-2019_REVIEWED.csv", stringsAsFactors=FALSE)
setnames(Rhode_Island_Data_SAT_2019, "SECONDARY SCHOOL STUDENT ID", "SECONDARY_SCHOOL_STUDENT_ID")
Rhode_Island_Data_SAT_2019[,"SECONDARY_SCHOOL_STUDENT_ID":=as.character(SECONDARY_SCHOOL_STUDENT_ID)]
load("Data/Rhode_Island_SGP_WIDE_Data.Rdata")
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
