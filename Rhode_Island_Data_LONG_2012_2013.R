##############################################################
###
### Script for creating Rhode_Island_Data_LONG_2012_2013
###
##############################################################

### Load SGP and data.table

require(SGP)
require(data.table)
require(foreign)


### Load data

tmp.data <- read.spss("Data/Base_Files/2013 NECAP.sav", to.data.frame=TRUE, use.value.labels=FALSE)
school.codes.2013 <- read.spss("Data/Base_Files/2013 scodes-snames.sav", to.data.frame=TRUE, use.value.labels=FALSE)
district.codes.2013 <- read.spss("Data/Base_Files/2013 dcodes-dnames.sav", to.data.frame=TRUE, use.value.labels=FALSE)

### Load Rhode_Island_SGP for name ordering

load("Data/Rhode_Island_SGP.Rdata")


##########################################################
### Clean up 2012 2013 data
##########################################################

names(tmp.data) <- toupper(names(tmp.data))
tmp.variables <- c("RPTSTUDID", "LNAME", "FNAME", "GRADE", "DISCODE", "SCHCODE", "SPRDISCODE", "SPRSCHCODE",
                   "GENDER", "ETHNIC", "LEP", "IEP", "SES", "REASCALEDSCORE", "REAAL", "MATSCALEDSCORE", "MATAL", "SENDDISCODE", 
		   "REATESTSTATUS", "MATTESTSTATUS", "SPRCONTSCH", "SPRCONTDIS", "STUSTATUS", "IEPEXITSTATUS")
tmp.data <- subset(tmp.data, select=intersect(tmp.variables, names(tmp.data)))

attach(tmp.data)

read_1213 <- data.frame(ID=RPTSTUDID,
                        YEAR="2012_2013",
                        CONTENT_AREA="READING",
                        LAST_NAME=LNAME,
                        FIRST_NAME=FNAME,
                        GRADE=GRADE, 
                        DISTRICT_NUMBER=SPRDISCODE,
                        SCHOOL_NUMBER=SPRSCHCODE,
			DISTRICT_NUMBER_CURRENT=DISCODE,
			SCHOOL_NUMBER_CURRENT=SCHCODE,
                        GENDER=GENDER,
                        ETHNICITY=ETHNIC,
                        IEP_STATUS=IEP,
#                        IEP_EXIT_STATUS=IEPEXITSTATUS,
                        ELL_STATUS=LEP,
                        FREE_REDUCED_LUNCH_STATUS=SES,
                        SCALE_SCORE=REASCALEDSCORE,
                        ACHIEVEMENT_LEVEL=REAAL,
			SENDDISCODE=SENDDISCODE,
			TEST_STATUS=REATESTSTATUS,
			STUDENT_STATUS=STUSTATUS,
			CONTINUOUS_SCHOOL_SPRING=SPRCONTSCH,
			CONTINUOUS_DISTRICT_SPRING=SPRCONTDIS)

math_1213 <- data.frame(ID=RPTSTUDID,
                        YEAR="2012_2013",
                        CONTENT_AREA="MATHEMATICS",
                        LAST_NAME=LNAME,
                        FIRST_NAME=FNAME,
                        GRADE=GRADE, 
                        DISTRICT_NUMBER=SPRDISCODE,
                        SCHOOL_NUMBER=SPRSCHCODE,
			DISTRICT_NUMBER_CURRENT=DISCODE,
			SCHOOL_NUMBER_CURRENT=SCHCODE,
                        GENDER=GENDER,
                        ETHNICITY=ETHNIC,
                        IEP_STATUS=IEP,
#                        IEP_EXIT_STATUS=IEPEXITSTATUS,
                        ELL_STATUS=LEP,
                        FREE_REDUCED_LUNCH_STATUS=SES,
                        SCALE_SCORE=MATSCALEDSCORE,
                        ACHIEVEMENT_LEVEL=MATAL,
			SENDDISCODE=SENDDISCODE,
			TEST_STATUS=MATTESTSTATUS,
			STUDENT_STATUS=STUSTATUS,
			CONTINUOUS_SCHOOL_SPRING=SPRCONTSCH,
			CONTINUOUS_DISTRICT_SPRING=SPRCONTDIS)

detach(tmp.data)

Rhode_Island_Data_LONG_2012_2013 <- rbind(read_1213, math_1213)


#############################################################################
### Tidy up data
#############################################################################

# ID

levels(Rhode_Island_Data_LONG_2012_2013$ID) <- gsub(' +$', '', levels(Rhode_Island_Data_LONG_2012_2013$ID))
Rhode_Island_Data_LONG_2012_2013$ID[Rhode_Island_Data_LONG_2012_2013$ID==""] <- NA
Rhode_Island_Data_LONG_2012_2013 <- subset(Rhode_Island_Data_LONG_2012_2013, !is.na(ID))
Rhode_Island_Data_LONG_2012_2013$ID <- as.character(Rhode_Island_Data_LONG_2012_2013$ID)

# YEAR

Rhode_Island_Data_LONG_2012_2013$YEAR <- as.character(Rhode_Island_Data_LONG_2012_2013$YEAR)


# CONTENT_AREA

Rhode_Island_Data_LONG_2012_2013$CONTENT_AREA <- as.character(Rhode_Island_Data_LONG_2012_2013$CONTENT_AREA)


# LAST_NAME/FIRST_NAME

levels(Rhode_Island_Data_LONG_2012_2013$LAST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2012_2013$LAST_NAME), capwords))
levels(Rhode_Island_Data_LONG_2012_2013$FIRST_NAME) <- as.character(sapply(levels(Rhode_Island_Data_LONG_2012_2013$FIRST_NAME), capwords))


# GRADE

Rhode_Island_Data_LONG_2012_2013$GRADE <- as.character(as.numeric(as.character(Rhode_Island_Data_LONG_2012_2013$GRADE)))

# DISTRICT_NUMBER/SCHOOL_NUMBER/DISTRICT_NUMBER_CURRENT/SCHOOL_NUMBER_CURRENT/SENDDISCODE

levels(Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER) <- as.character(gsub(' +$', '', levels(Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER)))
Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER[Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER==""] <- NA
Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER <- as.character(Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER)

levels(Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER_CURRENT) <- as.character(gsub(' +$', '', levels(Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER_CURRENT)))
Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER_CURRENT[Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER_CURRENT==""] <- NA
Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER_CURRENT <- as.character(Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER_CURRENT)

levels(Rhode_Island_Data_LONG_2012_2013$SCHOOL_NUMBER) <- as.character(gsub(' +$', '', levels(Rhode_Island_Data_LONG_2012_2013$SCHOOL_NUMBER)))
Rhode_Island_Data_LONG_2012_2013$SCHOOL_NUMBER[Rhode_Island_Data_LONG_2012_2013$SCHOOL_NUMBER==""] <- NA
Rhode_Island_Data_LONG_2012_2013$SCHOOL_NUMBER <- as.character(Rhode_Island_Data_LONG_2012_2013$SCHOOL_NUMBER)

levels(Rhode_Island_Data_LONG_2012_2013$SCHOOL_NUMBER_CURRENT) <- as.character(gsub(' +$', '', levels(Rhode_Island_Data_LONG_2012_2013$SCHOOL_NUMBER_CURRENT)))
Rhode_Island_Data_LONG_2012_2013$SCHOOL_NUMBER_CURRENT[Rhode_Island_Data_LONG_2012_2013$SCHOOL_NUMBER_CURRENT==""] <- NA
Rhode_Island_Data_LONG_2012_2013$SCHOOL_NUMBER_CURRENT <- as.character(Rhode_Island_Data_LONG_2012_2013$SCHOOL_NUMBER_CURRENT)

levels(Rhode_Island_Data_LONG_2012_2013$SENDDISCODE) <- as.character(gsub(' +$', '', levels(Rhode_Island_Data_LONG_2012_2013$SENDDISCODE)))
Rhode_Island_Data_LONG_2012_2013$SENDDISCODE[Rhode_Island_Data_LONG_2012_2013$SENDDISCODE==""] <- NA
Rhode_Island_Data_LONG_2012_2013$SENDDISCODE <- as.character(Rhode_Island_Data_LONG_2012_2013$SENDDISCODE)

# GENDER

Rhode_Island_Data_LONG_2012_2013$GENDER[Rhode_Island_Data_LONG_2012_2013$GENDER=="X"] <- NA
Rhode_Island_Data_LONG_2012_2013$GENDER <- factor(Rhode_Island_Data_LONG_2012_2013$GENDER)
levels(Rhode_Island_Data_LONG_2012_2013$GENDER) <- c("Female", "Male")

# ETHNICITY

Rhode_Island_Data_LONG_2012_2013$ETHNICITY[Rhode_Island_Data_LONG_2012_2013$ETHNICITY==0] <- NA
Rhode_Island_Data_LONG_2012_2013$ETHNICITY <- as.integer(as.character(Rhode_Island_Data_LONG_2012_2013$ETHNICITY))
Rhode_Island_Data_LONG_2012_2013$ETHNICITY <- factor(Rhode_Island_Data_LONG_2012_2013$ETHNICITY, levels=1:7, 
	labels=c("American Indian or Alaskan Native", "Asian", "African American", "Hispanic or Latino", "Native Hawaiian or Pacific Islander", "White", "Multiple Ethnicities Reported"))

# IEP_STATUS

levels(Rhode_Island_Data_LONG_2012_2013$IEP_STATUS) <- c("Students without Disabilities (Non-IEP)", "Students with Disabilities (IEP)")

# LEP STATUS

Rhode_Island_Data_LONG_2012_2013$ELL_STATUS[Rhode_Island_Data_LONG_2012_2013$ELL_STATUS %in% 1:3] <- 1
Rhode_Island_Data_LONG_2012_2013$ELL_STATUS <- factor(Rhode_Island_Data_LONG_2012_2013$ELL_STATUS)
levels(Rhode_Island_Data_LONG_2012_2013$ELL_STATUS) <- c("Non-English Language Learners (ELL)", "English Language Learners (ELL)")
Rhode_Island_Data_LONG_2012_2013$ELL_STATUS <- factor(as.character(Rhode_Island_Data_LONG_2012_2013$ELL_STATUS))


# FREE_REDUCED_LUNCH_STATUS

levels(Rhode_Island_Data_LONG_2012_2013$FREE_REDUCED_LUNCH_STATUS) <- c("Not Economically Disadvanted", "Economically Disadvantaged")
Rhode_Island_Data_LONG_2012_2013$FREE_REDUCED_LUNCH_STATUS <- as.character(Rhode_Island_Data_LONG_2012_2013$FREE_REDUCED_LUNCH_STATUS)
Rhode_Island_Data_LONG_2012_2013$FREE_REDUCED_LUNCH_STATUS <- factor(Rhode_Island_Data_LONG_2012_2013$FREE_REDUCED_LUNCH_STATUS)


# ACHIEVEMENT_LEVEL

Rhode_Island_Data_LONG_2012_2013$ACHIEVEMENT_LEVEL[Rhode_Island_Data_LONG_2012_2013$ACHIEVEMENT_LEVEL %in%
        c("A", "E", "N", "S", "W", "L")] <- NA
Rhode_Island_Data_LONG_2012_2013$ACHIEVEMENT_LEVEL <- droplevels(Rhode_Island_Data_LONG_2012_2013$ACHIEVEMENT_LEVEL)
levels(Rhode_Island_Data_LONG_2012_2013$ACHIEVEMENT_LEVEL) <-
	        c("Substantially Below Proficient", "Partially Proficient", "Proficient", "Proficient with Distinction")

# VALID_CASE

Rhode_Island_Data_LONG_2012_2013$VALID_CASE <- "VALID_CASE"

# ENROLLMENT_STATUS

Rhode_Island_Data_LONG_2012_2013$STATE_ENROLLMENT_STATUS <- factor(2, levels=1:2, labels=c("Enrolled State: No", "Enrolled State: Yes"))
Rhode_Island_Data_LONG_2012_2013$DISTRICT_ENROLLMENT_STATUS <- factor(2, levels=1:2, labels=c("Enrolled District: No", "Enrolled District: Yes"))
Rhode_Island_Data_LONG_2012_2013$SCHOOL_ENROLLMENT_STATUS <- factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))

# OTHER VARIABLES

Rhode_Island_Data_LONG_2012_2013$ELL_MULTI_CATEGORY_STATUS <- Rhode_Island_Data_LONG_2012_2013$ELL_STATUS
Rhode_Island_Data_LONG_2012_2013$ELL_STATUS <- NULL
Rhode_Island_Data_LONG_2012_2013$ELL_STATUS <- factor(1, levels=1:2, labels=c("Non-English Language Learners (ELL)", "English Language Learners (ELL)"))
Rhode_Island_Data_LONG_2012_2013$ELL_STATUS[Rhode_Island_Data_LONG_2012_2013$ELL_MULTI_CATEGORY_STATUS != "Non-English Language Learners (ELL)"] <- "English Language Learners (ELL)"

Rhode_Island_Data_LONG_2012_2013$CONSOLIDATED_PROGRAM_SUBGROUP <- factor(1, levels=1:2, labels=c("Consolidated Program Subgroup: No", "Consolidated Program Subgroup: Yes"))
Rhode_Island_Data_LONG_2012_2013$CONSOLIDATED_PROGRAM_SUBGROUP[
	Rhode_Island_Data_LONG_2012_2013$IEP_STATUS=="Students with Disabilities (IEP)" |
	Rhode_Island_Data_LONG_2012_2013$ELL_STATUS=="English Language Learners (ELL)"] <- "Consolidated Program Subgroup: Yes"

Rhode_Island_Data_LONG_2012_2013$CONSOLIDATED_MINORITY_POVERTY_SUBGROUP <- factor(1, levels=1:2, labels=c("Consolidated Minority/Poverty Subgroup: No", "Consolidated Minority/Poverty Subgroup: Yes"))
Rhode_Island_Data_LONG_2012_2013$CONSOLIDATED_MINORITY_POVERTY_SUBGROUP[
	Rhode_Island_Data_LONG_2012_2013$ETHNICITY!="White" &
	Rhode_Island_Data_LONG_2012_2013$FREE_REDUCED_LUNCH_STATUS!="Not Economically Disadvanted"] <- "Consolidated Minority/Poverty Subgroup: Yes"

Rhode_Island_Data_LONG_2012_2013$SCHOOL_ENROLLMENT_STATUS[Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER==88] <- "Enrolled School: No"
Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER[which(Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER==88)] <- Rhode_Island_Data_LONG_2012_2013$SENDDISCODE[which(Rhode_Island_Data_LONG_2012_2013$DISTRICT_NUMBER==88)]

Rhode_Island_Data_LONG_2012_2013$SENDDISCODE <- NULL

Rhode_Island_Data_LONG_2012_2013$SCHOOL_ENROLLMENT_STATUS[Rhode_Island_Data_LONG_2012_2013$CONTINUOUS_SCHOOL_SPRING==0] <- "Enrolled School: No"
Rhode_Island_Data_LONG_2012_2013$DISTRICT_ENROLLMENT_STATUS[Rhode_Island_Data_LONG_2012_2013$CONTINUOUS_DISTRICT_SPRING==0] <- "Enrolled District: No"


### VALIDATE cases

Rhode_Island_Data_LONG_2012_2013$VALID_CASE[Rhode_Island_Data_LONG_2012_2013$GRADE==11] <- "INVALID_CASE"
Rhode_Island_Data_LONG_2012_2013$VALID_CASE[is.na(Rhode_Island_Data_LONG_2012_2013$ID)] <- "INVALID_CASE"
Rhode_Island_Data_LONG_2012_2013$VALID_CASE[Rhode_Island_Data_LONG_2012_2013$TEST_STATUS!="A"] <- "INVALID_CASE"
Rhode_Island_Data_LONG_2012_2013$VALID_CASE[Rhode_Island_Data_LONG_2012_2013$STUDENT_STATUS!=0] <- "INVALID_CASE"

# Convert to data.table

Rhode_Island_Data_LONG_2012_2013 <- as.data.table(Rhode_Island_Data_LONG_2012_2013)
setkeyv(Rhode_Island_Data_LONG_2012_2013, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))



# Tidy up district.codes.2013 and school.codes.2013

names(school.codes.2013)[1:5] <- c("EMH_LEVEL", "DISTRICT_NUMBER", "DISTRICT_NAME", "SCHOOL_NUMBER", "SCHOOL_NAME")
school.codes.2013 <- school.codes.2013[,1:5]
levels(school.codes.2013$EMH_LEVEL) <- c("Elementary", "High", "Middle")
school.codes.2013$DISTRICT_NUMBER <- as.character(school.codes.2013$DISTRICT_NUMBER)
levels(school.codes.2013$DISTRICT_NAME) <- sapply(school.codes.2013$DISTRICT_NAME, capwords)
school.codes.2013$SCHOOL_NUMBER <- as.character(school.codes.2013$SCHOOL_NUMBER)
levels(school.codes.2013$SCHOOL_NAME) <- sapply(school.codes.2013$SCHOOL_NAME, capwords)
school.codes.2013 <- as.data.table(school.codes.2013)
setkey(school.codes.2013, DISTRICT_NUMBER, SCHOOL_NUMBER)
Rhode_Island_District_and_School_Names <- school.codes.2013


#############################################################################
###
### Create Long file and save result
###
#############################################################################


### Fix up Rhode_Island District and School Names

Rhode_Island_Data_LONG_2012_2013 <- as.data.table(Rhode_Island_Data_LONG_2012_2013)
setkeyv(Rhode_Island_Data_LONG_2012_2013, c("DISTRICT_NUMBER", "SCHOOL_NUMBER"))
Rhode_Island_Data_LONG_2012_2013 <- Rhode_Island_District_and_School_Names[Rhode_Island_Data_LONG_2012_2013]

## Identify duplicates

setkey(Rhode_Island_Data_LONG_2012_2013, VALID_CASE, CONTENT_AREA, YEAR, ID)
dups <- Rhode_Island_Data_LONG_2012_2013[Rhode_Island_Data_LONG_2012_2013[J("VALID_CASE")][duplicated(Rhode_Island_Data_LONG_2012_2013[J("VALID_CASE")])][,list(VALID_CASE, YEAR, CONTENT_AREA, ID)]]


### Convert to data.frame and save results

Rhode_Island_Data_LONG_2012_2013 <- as.data.frame(Rhode_Island_Data_LONG_2012_2013)
Rhode_Island_Data_LONG_2012_2013 <- Rhode_Island_Data_LONG_2012_2013[,names(sort(sapply(names(Rhode_Island_Data_LONG_2012_2013), function(x) match(x, names(Rhode_Island_SGP@Data)))))]
save(Rhode_Island_Data_LONG_2012_2013, file="Data/Rhode_Island_Data_LONG_2012_2013.Rdata")
