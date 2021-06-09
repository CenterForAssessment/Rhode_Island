################################################################################
###                                                                          ###
###                   Rhode Island analyses for 2016-2017                    ###
###                                                                          ###
################################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load data

# load("Data/Rhode_Island_SGP_LONG_Data.Rdata")
# Rhode_Island_Data_LONG <- Rhode_Island_SGP_LONG_Data[CONTENT_AREA %in% c("ALGEBRA_I", "PSAT_MATH")]

load("Data/Rhode_Island_Data_LONG_2014_2015.Rdata")
load("Data/Rhode_Island_Data_LONG_2015_2016.Rdata")
load("Data/Rhode_Island_Data_LONG_2016_2017.Rdata")

Rhode_Island_Data_LONG <- rbindlist(list(
  Rhode_Island_Data_LONG_2014_2015,
  Rhode_Island_Data_LONG_2015_2016,
  Rhode_Island_Data_LONG_2016_2017), fill=TRUE)[CONTENT_AREA %in% c("ALGEBRA_I", "PSAT_MATH") & VALID_CASE == "VALID_CASE"]

### Modify Data

# Rhode_Island_Data_LONG[, SGP_ORIGINAL := SGP]
Rhode_Island_Data_LONG[, YEAR_ACTUAL := YEAR]
Rhode_Island_Data_LONG[YEAR != "2016_2017", YEAR := "2015_2016"]

ids_15 <- Rhode_Island_Data_LONG[YEAR_ACTUAL == "2014_2015", ID]
ids_16 <- Rhode_Island_Data_LONG[YEAR_ACTUAL == "2015_2016", ID]
dup_ids <- intersect(ids_15, ids_16)  #  length(intersect(ids_15, ids_16))

Rhode_Island_Data_LONG[, COHORT := ""]
Rhode_Island_Data_LONG[YEAR_ACTUAL == "2016_2017" & ID %in% ids_15, COHORT := "2015"]
Rhode_Island_Data_LONG[YEAR_ACTUAL == "2016_2017" & ID %in% ids_16, COHORT := "2016"]
Rhode_Island_Data_LONG[YEAR_ACTUAL == "2016_2017" & ID %in% dup_ids,COHORT := "2015 & 2016"]


### Set up configurations

PSAT_MATH_2016_2017.config <- list(
	PSAT_MATH.2016_2017 = list(
		sgp.content.areas=c('ALGEBRA_I', 'PSAT_MATH'),
		sgp.panel.years=c('2015_2016', '2016_2017'),
		sgp.grade.sequences=list(c('EOCT', 'EOCT'))))


setwd("~/RI/Charlie")

Rhode_Island_SGP <- abcSGP(
			Rhode_Island_Data_LONG, # [COHORT != "2015 & 2016"],  excluding duplicates doesn't make a difference.
			steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
			sgp.percentiles=TRUE,
			sgp.projections=FALSE,
			sgp.projections.lagged=FALSE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			simulate.sgps=FALSE,
			sgp.config=PSAT_MATH_2016_2017.config,
			sgp.target.scale.scores=FALSE,
			sgPlot.demo.report=FALSE)


table(Rhode_Island_SGP@Data[, is.na(SGP), YEAR])



Rhode_Island_SGP@Data[!is.na(SGP), as.list(summary(SGP)), keyby="COHORT"]
Rhode_Island_SGP@Data[!is.na(SGP), list(Mean = mean(SGP), Median= median(SGP), N = .N), keyby="COHORT"]


#         COHORT Min. 1st Qu. Median     Mean 3rd Qu. Max.
# 1:        2015    1      33     59 56.82676   82.00   99
# 2: 2015 & 2016    1      22     49 48.30986   73.25   99
# 3:        2016    1      20     42 44.03210   67.00   99

###
# COHORT     Mean Median    N
# 1:   2015 56.67897     59 4716
# 2:   2016 43.99011     42 5359
