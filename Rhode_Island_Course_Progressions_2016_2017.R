################################################################################
###                                                                          ###
###                Identify Fall 2017 Progressions for PARCC                 ###
###                                                                          ###
################################################################################

library(SGP)
library(data.table)

load("Data/Rhode_Island_Data_LONG_2014_2015.Rdata")
load("Data/Rhode_Island_Data_LONG_2015_2016.Rdata")

###  Create LONG data subset

Rhode_Island_Data_LONG <- rbindlist(list(Rhode_Island_Data_LONG_2014_2015, Rhode_Island_Data_LONG_2015_2016, Rhode_Island_Data_LONG_2016_2017, Rhode_Island_Data_LONG_PSAT_2017), fill = TRUE)[,
  list(ID, YEAR, CONTENT_AREA, GRADE, SCALE_SCORE, VALID_CASE)]

###  Run courseProgressionSGP by content area subsets of the Rhode_Island_Data_LONG
ela.subjects <- c("AAELA", "AAMAT", "ELA", "PSAT_TOTAL", "PSAT_EBRW")
math.prog<- courseProgressionSGP(Rhode_Island_Data_LONG[!CONTENT_AREA %in% ela.subjects], lag.direction="BACKWARD", year='2016_2017')
ela.prog <- courseProgressionSGP(Rhode_Island_Data_LONG[CONTENT_AREA %in% c("PSAT_EBRW", "ELA")], lag.direction="BACKWARD", year='2016_2017')


####
####     Mathematics
####

###  Find out which Math related content areas are present in the data
names(math.prog$BACKWARD[['2016_2017']])

###
###   Algebra I (No Repeaters or Regression)
###

ALG1 <- math.prog$BACKWARD[['2016_2017']]$ALGEBRA_I.EOCT[!CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 %in% c("ALGEBRA_I.EOCT", "ALGEBRA_II.EOCT") | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks

table(ALG1$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
ALG1[COUNT > 100]  #  Major progressions

###   Viable 1 Prior ALGEBRA_I Progressions
ALG1[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

###   Viable 2 Prior ALGEBRA_I Progressions
ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.08", list(Total=sum(COUNT))] #  6089
ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.08", ] # MATHEMATICS.07 second prior is viable :: 5366

ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.07", list(Total=sum(COUNT))] #  2815
ALG1[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS.07", ] # MATHEMATICS.06 second prior is viable :: 2614


###
###   Geometry (No Repeaters)
###

GEOM <- math.prog$BACKWARD[['2016_2017']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "GEOMETRY.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks

table(GEOM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
GEOM[COUNT > 100]  #  Major progressions

###   Viable 1 Prior GEOMETRY Progressions
GEOM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

###   Viable 2 Prior GEOMETRY Progressions
GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT", list(Total=sum(COUNT))] #  1998
GEOM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT", ] # MATHEMATICS.07 second prior is viable :: 1788


###
###   Algebra II (No Repeaters)
###

ALG2 <- math.prog$BACKWARD[['2016_2017']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_II.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
ALG2[COUNT > 100]  #  Major progressions (((NONE)))

###   Viable 1 Prior ALGEBRA_II Progressions
ALG2[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
###   (((NONE)))


###
###   PSAT Math
###

PSATM <- math.prog$BACKWARD[['2016_2017']]$PSAT_MATH.EOCT

table(PSATM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
PSATM[COUNT > 100]  #  Major progressions

###   Viable 1 Prior PSAT MATH Progressions
PSATM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

###   Viable 2 Prior PSAT MATH Progressions
PSATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT", list(Total=sum(COUNT))] #  5643
PSATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT", ] # MATHEMATICS.08 second prior is viable :: 4338

PSATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.EOCT", list(Total=sum(COUNT))]  #  5070
PSATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.EOCT", ]  # ALGEBRA_I.EOCT second prior is viable :: 4139



####
####     ELA
####


###  Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[['2016_2017']])


###  Grade Level ELA
sum(ela.prog$BACKWARD[['2016_2017']]$ELA.08[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.07"]$COUNT)   #  9747
sum(ela.prog$BACKWARD[['2016_2017']]$ELA.08[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   #    33 (repeaters)

sum(ela.prog$BACKWARD[['2016_2017']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   #  9561
sum(ela.prog$BACKWARD[['2016_2017']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #    40 (repeaters)


###
###   PSAT ELA
###

PSATE <- ela.prog$BACKWARD[['2016_2017']]$PSAT_EBRW.EOCT

table(PSATE$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
PSATE[COUNT > 100]  #  Major progressions

###   Viable 1 Prior PSAT ELA Progressions
PSATE[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

###   Viable 2 Prior PSAT ELA Progressions
PSATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09", list(Total=sum(COUNT))] #  7824
PSATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09", ] # ELA.08 second prior is viable :: 6629

PSATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10", list(Total=sum(COUNT))]  #  4867
PSATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.10", ]  # ELA.09 second prior is viable :: 4136

###   Viable skip year Prior PSAT MATH Progressions
PSATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.08", list(Total=sum(COUNT))] #  6845
PSATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.08", ] # 3 pathways
