#####################################################################################
###
### Rhode Island special SCHOOLVIEW export script for 2015-2016
###
#####################################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load data

load("Data/Rhode_Island_SGP.Rdata")
load("Data/Base_Files/bad_schools.Rdata")


### Change SGPstateData for MATHEMATICS adding ALGEBRA_I & GEOMETRY as MATHEMATICS GRADE 9 and GRADE 10

#SGPstateData[['RI']][['Achievement']][['Cutscores']][['MATHEMATICS']][['GRADE_11']] <- SGPstateData[['RI']][['Achievement']][['Cutscores']][['ALGEBRA_I']][['GRADE_EOCT']]
#SGPstateData[['RI']][['Achievement']][['Cutscores']][['MATHEMATICS']][['GRADE_12']] <- SGPstateData[['RI']][['Achievement']][['Cutscores']][['GEOMETRY']][['GRADE_EOCT']]
#SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['MATHEMATICS']][['knots_11']] <- SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['ALGEBRA_I']][['knots_EOCT']]
#SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['MATHEMATICS']][['boundaries_11']] <- SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['ALGEBRA_I']][['boundaries_EOCT']]
#SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['MATHEMATICS']][['loss.hoss_11']] <- SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['ALGEBRA_I']][['loss.hoss_EOCT']]
#SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['MATHEMATICS']][['knots_12']] <- SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['GEOMETRY']][['knots_EOCT']]
#SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['MATHEMATICS']][['boundaries_12']] <- SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['GEOMETRY']][['boundaries_EOCT']]
#SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['MATHEMATICS']][['loss.hoss_12']] <- SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['GEOMETRY']][['loss.hoss_EOCT']]


### Recode CONTENT_AREA and GRADE variables for ALGEBRA_I and GEOMETRY

#slot.data <- copy(Rhode_Island_SGP@Data)
#slot.data[,CONTENT_AREA_ORIGINAL:=CONTENT_AREA]
#slot.data[CONTENT_AREA=="ALGEBRA_I", c("CONTENT_AREA", "GRADE"):=list("MATHEMATICS", "11")]
#slot.data[CONTENT_AREA=="GEOMETRY", c("CONTENT_AREA", "GRADE"):=list("MATHEMATICS", "12")]
#slot.data[!CONTENT_AREA %in% c("ELA", "MATHEMATICS"), VALID_CASE:="INVALID_CASE"]
#setkey(slot.data, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SGP)
#setkey(slot.data, VALID_CASE, CONTENT_AREA, YEAR, ID)
#slot.data[which(duplicated(slot.data, by=key(slot.data)))-1, VALID_CASE:="INVALID_CASE"]
#setkey(bad_schools, YEAR, DISTRICT_NUMBER, SCHOOL_NUMBER)
#setkey(slot.data, YEAR, DISTRICT_NUMBER, SCHOOL_NUMBER)
#slot.data[bad_schools, VALID_CASE:="INVALID_CASE"]
#setkey(slot.data, VALID_CASE, CONTENT_AREA, YEAR, ID)

### Recode CONTENT_AREA and GRADE variables for ALGEBRA_I

slot.data <- copy(Rhode_Island_SGP@Data)
slot.data[,CONTENT_AREA_ORIGINAL:=CONTENT_AREA]
slot.data[CONTENT_AREA=="ALGEBRA_I" & GRADE_ENROLLED=="8", c("CONTENT_AREA", "GRADE"):=list("MATHEMATICS", "8")]
slot.data[!CONTENT_AREA %in% c("ELA", "MATHEMATICS"), VALID_CASE:="INVALID_CASE"]
slot.data[!GRADE %in% 3:8, VALID_CASE:="INVALID_CASE"]
setkey(slot.data, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SGP)
setkey(slot.data, VALID_CASE, CONTENT_AREA, YEAR, ID)
slot.data[which(duplicated(slot.data, by=key(slot.data)))-1, VALID_CASE:="INVALID_CASE"]
setkey(bad_schools, YEAR, DISTRICT_NUMBER, SCHOOL_NUMBER)
setkey(slot.data, YEAR, DISTRICT_NUMBER, SCHOOL_NUMBER)
slot.data[bad_schools, VALID_CASE:="INVALID_CASE"]
setkey(slot.data, VALID_CASE, CONTENT_AREA, YEAR, ID)

### Put slot.data into @Data

Rhode_Island_SGP@Data <- slot.data
setkey(Rhode_Island_SGP@Data, VALID_CASE, CONTENT_AREA, YEAR, ID)


### summarizeSGP

Rhode_Island_SGP <- summarizeSGP(
			Rhode_Island_SGP,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SUMMARY=6)))


###
### Save results
###

save(Rhode_Island_SGP, file="Data/SchoolView/Rhode_Island_SGP_2015_2016_SCHOOLVIEW.Rdata")


###
### Undo ALGEBRA_I as MATHEMATICS GRADE 8 for export
###

SGPstateData[['RI']][['Achievement']][['Cutscores']][['MATHEMATICS']][['GRADE_9']] <- SGPstateData[['RI']][['Achievement']][['Cutscores']][['ALGEBRA_I']][['GRADE_EOCT']]
SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['MATHEMATICS']][['knots_9']] <- SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['ALGEBRA_I']][['knots_EOCT']]
SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['MATHEMATICS']][['boundaries_9']] <- SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['ALGEBRA_I']][['boundaries_EOCT']]
SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['MATHEMATICS']][['loss.hoss_9']] <- SGPstateData[['RI']][['Achievement']][['Knots_Boundaries']][['ALGEBRA_I']][['loss.hoss_EOCT']]

slot.data <- copy(Rhode_Island_SGP@Data)
slot.data[CONTENT_AREA_ORIGINAL=="ALGEBRA_I" & GRADE_ENROLLED=="8", c("CONTENT_AREA", "GRADE"):=list("MATHEMATICS", "9")]
Rhode_Island_SGP@Data <- slot.data
setkey(Rhode_Island_SGP@Data, VALID_CASE, CONTENT_AREA, YEAR, ID)


###
### outputSGP
###

outputSGP(Rhode_Island_SGP, output.type="SchoolView")


### Clean up OUTPUT

tmp.files <- c("SCHOOL.dat", "SCHOOL_ETHNICITY.dat", "SCHOOL_GRADE.dat", "SCHOOL_STUDENTGROUP.dat")
for (tmp.iter in tmp.files) {
	tmp <- fread(file.path("Data/SchoolView/TEXT", tmp.iter), colClasses="character")
	tmp[,SCHOOL_NUMBER:=strtail(SCHOOL_NUMBER, -3)]
	write.table(tmp, file=file.path("Data/SchoolView/TEXT", tmp.iter), sep="|", row.names=FALSE, quote=FALSE, na="")
}

load("Data/SchoolView/RDATA/STUDENT_GROWTH.Rdata")
STUDENT_GROWTH[,SCHOOL_NUMBER:=strtail(SCHOOL_NUMBER, -3)]
STUDENT_GROWTH <- STUDENT_GROWTH[!is.na(as.numeric(STATE_ASSIGNED_ID))]
STUDENT_GROWTH <- STUDENT_GROWTH[CONTENT_AREA==2 & GRADE_LEVEL_CY=="9", GRADE_LEVEL_CY:="8"]
STUDENT_GROWTH <- STUDENT_GROWTH[CONTENT_AREA==2 & GRADE_LEVEL_PY1=="9", GRADE_LEVEL_PY1:="8"]
save(STUDENT_GROWTH, file="Data/SchoolView/RDATA/STUDENT_GROWTH.Rdata")
unlink("Data/SchoolView/TEXT/STUDENT_GROWTH.dat.zip")
write.table(STUDENT_GROWTH, file="Data/SchoolView/TEXT/STUDENT_GROWTH.dat", sep="|", row.names=FALSE, quote=FALSE, na="")
