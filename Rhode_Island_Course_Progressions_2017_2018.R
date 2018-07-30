################################################################################
###                                                                          ###
###                Identify Fall 2017 Progressions for PARCC                 ###
###                                                                          ###
################################################################################

library(SGP)
library(data.table)

load("~/Dropbox (SGP)/SGP/Rhode_Island/Data/Rhode_Island_Data_LONG_2015_2016.Rdata")
load("~/Dropbox (SGP)/SGP/Rhode_Island/Data/Rhode_Island_Data_LONG_2016_2017.Rdata")
load("Data/Rhode_Island_Data_LONG_SAT_2017_2018.Rdata")

###  Create LONG data subset

Rhode_Island_Data_LONG <- rbindlist(list(Rhode_Island_Data_LONG_2015_2016, Rhode_Island_Data_LONG_2016_2017, Rhode_Island_Data_LONG_SAT_2017_2018), fill = TRUE)[,
  list(ID, YEAR, CONTENT_AREA, GRADE, SCALE_SCORE, VALID_CASE)]

###  Run courseProgressionSGP by content area subsets of the Rhode_Island_Data_LONG
ela.subjects <- c("AAELA", "AAMAT", "ELA", "ELA_PSAT_10", "ELA_SAT")
math.prog<- courseProgressionSGP(Rhode_Island_Data_LONG[!CONTENT_AREA %in% ela.subjects], lag.direction="BACKWARD", year='2017_2018')
ela.prog <- courseProgressionSGP(Rhode_Island_Data_LONG[CONTENT_AREA %in% c("ELA_SAT", "ELA_PSAT_10", "ELA")], lag.direction="BACKWARD", year='2017_2018')


####
####     Mathematics
####

###  Find out which Math related content areas are present in the data
names(math.prog$BACKWARD[['2017_2018']])

###
###   Algebra I (No Repeaters or Regression)
###

ALG1 <- math.prog$BACKWARD[['2017_2018']]$ALGEBRA_I.EOCT[!CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 %in% c("ALGEBRA_I.EOCT", "ALGEBRA_II.EOCT") | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks

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

GEOM <- math.prog$BACKWARD[['2017_2018']]$GEOMETRY.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "GEOMETRY.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)] #  Keep NA's for Fall to Fall checks

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

ALG2 <- math.prog$BACKWARD[['2017_2018']]$ALGEBRA_II.EOCT[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1 != "ALGEBRA_II.EOCT" | is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
ALG2[COUNT > 100]  #  Major progressions (((NONE)))

###   Viable 1 Prior ALGEBRA_II Progressions
ALG2[, list(Total=sum(COUNT)), keyby=c("CONTENT_AREA_by_GRADE_PRIOR_YEAR.1")][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]
###   (((NONE)))


###
###   PSAT Math
###

PSATM <- math.prog$BACKWARD[['2017_2018']]$MATHEMATICS_PSAT_10.EOCT

table(PSATM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
PSATM[COUNT > 100]  #  Major progressions

###   Viable 1 Prior PSAT MATH Progressions
PSATM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

###   Viable 2 Prior PSAT MATH Progressions
PSATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT", list(Total=sum(COUNT))] #  6254
PSATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ALGEBRA_I.EOCT", ] # MATHEMATICS.08 second prior is viable :: 5366

PSATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.EOCT", list(Total=sum(COUNT))]  #  2050
PSATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="GEOMETRY.EOCT", ]  # ALGEBRA_I.EOCT second prior is viable :: 1848

PSATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS_PSAT_10.EOCT", list(Total=sum(COUNT))]  #  17


###
###   SAT Math
###

SATM <- math.prog$BACKWARD[['2017_2018']]$MATHEMATICS_SAT.EOCT

table(SATM$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
SATM[COUNT > 100]  #  Major progressions

###   Viable 1 Prior SAT MATH Progressions
SATM[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

###   Viable 2 Prior SAT MATH Progressions
SATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS_PSAT_10.EOCT", list(Total=sum(COUNT))]  #  7392
SATM[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="MATHEMATICS_PSAT_10.EOCT", ]  # ALGEBRA_I.EOCT second prior is viable :: 4688


####
####     ELA
####


###  Find out which grades are present in the Fall ELA data
names(ela.prog$BACKWARD[['2017_2018']])


###  Grade Level ELA
sum(ela.prog$BACKWARD[['2017_2018']]$ELA.08[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.07"]$COUNT)   #  9747
sum(ela.prog$BACKWARD[['2017_2018']]$ELA.08[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   #    33 (repeaters)

sum(ela.prog$BACKWARD[['2017_2018']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.08"]$COUNT)   #  9561
sum(ela.prog$BACKWARD[['2017_2018']]$ELA.09[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09"]$COUNT)   #    40 (repeaters)


###
###   PSAT ELA
###

PSATE <- ela.prog$BACKWARD[['2017_2018']]$ELA_PSAT_10.EOCT

table(PSATE$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
PSATE[COUNT > 100]  #  Major progressions

###   Viable 1 Prior PSAT ELA Progressions
PSATE[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

###   Viable 2 Prior PSAT ELA Progressions
PSATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09", list(Total=sum(COUNT))] #  9172
PSATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA.09", ] # ELA.08 second prior is viable :: 8338

###   Viable skip year Prior PSAT MATH Progressions
PSATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.08", list(Total=sum(COUNT))] #  8481
PSATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.08", ] # 3 pathways


###
###   SAT ELA
###

SATE <- ela.prog$BACKWARD[['2017_2018']]$ELA_SAT.EOCT

table(SATE$CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)
SATE[COUNT > 100]  #  Major progressions

###   Viable 1 Prior SAT ELA Progressions
SATE[, list(Total=sum(COUNT)), keyby="CONTENT_AREA_by_GRADE_PRIOR_YEAR.1"][!is.na(CONTENT_AREA_by_GRADE_PRIOR_YEAR.1)]

###   Viable 2 Prior SAT ELA Progressions
SATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA_PSAT_10.EOCT", list(Total=sum(COUNT))] #  7390
SATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.1=="ELA_PSAT_10.EOCT", ] # ELA.08 second prior is viable :: 6956

###   Viable skip year Prior SAT MATH Progressions
SATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09", list(Total=sum(COUNT))] #  8313
SATE[CONTENT_AREA_by_GRADE_PRIOR_YEAR.2=="ELA.09", ] # 3 pathways
