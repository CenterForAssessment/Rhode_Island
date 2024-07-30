################################################################################
###
### One time script to prepare attendance data and incorporate into SGP object
###
################################################################################

### Load packages
require(data.table)
require(openxlsx)
require(SGP)

### Load data
load("Data/Rhode_Island_SGP.Rdata")
attendance_data.2021_2022 <- as.data.table(read.xlsx("Data/Base_Files/Center for Assessment Attendance data request 6.13.24.xlsx", sheet=1))
attendance_data.2022_2023 <- as.data.table(read.xlsx("Data/Base_Files/Center for Assessment Attendance data request 6.13.24.xlsx", sheet=2))

### Tidy up attendance_data
attendance_data <- rbindlist(list(attendance_data.2021_2022, attendance_data.2022_2023))
setnames(attendance_data, c("YEAR", "ID", "LAST_NAME", "FIRST_NAME", "GRADE", "TOWN", "DISTRICT_NAME", "SCHOOL_NUMBER", "SCHOOL_NAME", "SCHOOL_CODE_OUT", "ADM_CALCULATED", "ABS_TOTAL", "ABSENTEEISM"))

attendance_data[YEAR=="2021-22", YEAR:="2021_2022"]
attendance_data[YEAR=="2022-23", YEAR:="2022_2023"]

attendance_data[,GRADE:=as.factor(GRADE)]
setattr(attendance_data$GRADE, "levels", c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "KF", "PF", "PK"))
attendance_data[,GRADE:=as.character(GRADE)]

attendance_data[,c("TOWN", "SCHOOL_CODE_OUT", "LAST_NAME", "FIRST_NAME"):=NULL]

attendance_data[,ADM_CALCULATED:=as.numeric(ADM_CALCULATED)]
attendance_data[,ABS_TOTAL:=as.numeric(ABS_TOTAL)]
attendance_data[,ABSENTEEISM:=as.numeric(ABSENTEEISM)]

attendance_data[,VALID_CASE:="VALID_CASE"]

grouping.variables <- c("VALID_CASE", "YEAR", "GRADE", "ID", "SCHOOL_NUMBER", "DISTRICT_NAME")
attendance_data <- attendance_data[,list(ADM_CALCULATED=sum(ADM_CALCULATED, na.rm=TRUE), ABS_TOTAL=sum(ABS_TOTAL, na.rm=TRUE), ABSENTEEISM=sum(ABSENTEEISM, na.rm=TRUE)), keyby=grouping.variables]

grouping.variables <- c("VALID_CASE", "YEAR", "GRADE", "ID")
attendance_data <- attendance_data[,list(ADM_CALCULATED=sum(ADM_CALCULATED, na.rm=TRUE), ABS_TOTAL=sum(ABS_TOTAL, na.rm=TRUE), ABSENTEEISM=sum(ABSENTEEISM, na.rm=TRUE), NUMBER_OF_SCHOOLS=.N), keyby=grouping.variables]

attendance_data[,NUMBER_OF_SCHOOLS_CHRONICALLY_ABSENT:=ABSENTEEISM]
attendance_data[ABSENTEEISM >= 1, ABSENTEEISM:=1]

### Investigate duplicates
tmp.dups <- attendance_data[unique(attendance_data[duplicated(attendance_data, by=key(attendance_data))][,key(attendance_data), with=FALSE])]
table(duplicated(attendance_data, by=key(attendance_data)))

### Merge with @Data slot
tmp <- attendance_data[Rhode_Island_SGP@Data, on=key(attendance_data)]
setcolorder(tmp, c(1:4, 10:90, 5:9))
setkey(tmp, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
Rhode_Island_SGP@Data <- tmp

### Save results
save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")

