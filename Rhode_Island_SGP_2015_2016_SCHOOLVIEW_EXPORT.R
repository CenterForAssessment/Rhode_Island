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

slot.data[SCHOOL_NUMBER %in% bad_schools$SCHOOL_NUMBER, VALID_CASE:="INVALID_CASE"]


### outputSGP

outputSGP(Rhode_Island_SGP, output.type="SchoolView")

### Save results

save(Rhode_Island_SGP, file="Data/SchoolView/Rhode_Island_SGP_2015_2016_SCHOOLVIEW.Rdata")
