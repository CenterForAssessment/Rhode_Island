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


### Recode CONTENT_AREA and GRADE variables for ALGEBRA_I and GEOMETRY

slot.data <- copy(Rhode_Island_SGP@Data)
slot.data[,CONTENT_AREA_ORIGINAL:=CONTENT_AREA]
slot.data[CONTENT_AREA=="ALGEBRA_I", c("CONTENT_AREA", "GRADE"):=list("MATHEMATICS", "9")]
slot.data[CONTENT_AREA=="GEOMETRY", c("CONTENT_AREA", "GRADE"):=list("MATHEMATICS", "10")]
slot.data[!CONTENT_AREA %in% c("ELA", "MATHEMATICS"), VALID_CASE:="INVALID_CASE"]
setkey(slot.data, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE, SGP)
setkey(slot.data, VALID_CASE, CONTENT_AREA, YEAR, ID)
slot.data[which(duplicated(slot.data, by=key(slot.data)))-1, VALID_CASE:="INVALID_CASE"]


### Put slot.data bad into @Data

Rhode_Island_SGP@Data <- slot.data
setkey(Rhode_Island_SGP@Data, VALID_CASE, CONTENT_AREA, YEAR, ID)


### summarizeSGP

Rhode_Island_SGP <- summarizeSGP(
			Rhode_Island_SGP,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SUMMARY=4)))


### Remove students from schools not suitable for reporting

setkey(bad_schools, YEAR, DISTRICT_NUMBER, SCHOOL_NUMBER)
setkey(slot.data, YEAR, DISTRICT_NUMBER, SCHOOL_NUMBER)
slot.data[bad_schools, VALID_CASE:="INVALID_CASE"]
Rhode_Island_SGP@Data <- slot.data
setkey(Rhode_Island_SGP@Data, VALID_CASE, CONTENT_AREA, YEAR, ID)


### outputSGP

outputSGP(Rhode_Island_SGP, output.type="SchoolView")


### Clean up SCHOOL_NUMBER

tmp.files <- c("SCHOOL.dat", "SCHOOL_ETHNICITY.dat", "SCHOOL_GRADE.dat", "SCHOOL_STUDENTGROUP.dat")
for (tmp.iter in tmp.files) {
	tmp <- fread(file.path("Data/SchoolView/TEXT", tmp.iter), colClasses="character")
	tmp[,SCHOOL_NUMBER:=strtail(SCHOOL_NUMBER, -3)]
	write.table(tmp, file=file.path("Data/SchoolView/TEXT", tmp.iter), sep="|", row.names=FALSE, quote=FALSE)
}

load("Data/SchoolView/RDATA/STUDENT_GROWTH.Rdata")
STUDENT_GROWTH[,SCHOOL_NUMBER:=strtail(SCHOOL_NUMBER, -3)]
save(STUDENT_GROWTH, file="Data/SchoolView/RDATA/STUDENT_GROWTH.Rdata")
unlink("Data/SchoolView/TEXT/STUDENT_GROWTH.dat.zip")
write.table(STUDENT_GROWTH, file="Data/SchoolView/TEXT/STUDENT_GROWTH.dat", sep="|", row.names=FALSE, quote=FALSE)


###
### Save results

save(Rhode_Island_SGP, file="Data/SchoolView/Rhode_Island_SGP_2015_2016_SCHOOLVIEW.Rdata")
