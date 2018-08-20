################################################################################
###                                                                          ###
###                   Rhode Island analyses for 2016-2017                    ###
###                                                                          ###
################################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load data

load("Data/Rhode_Island_SGP.Rdata")
load("Data/Rhode_Island_Data_LONG_2016_2017.Rdata")


### Load configurations

source("SGP_CONFIG/2016_2017/ELA.R")
source("SGP_CONFIG/2016_2017/MATHEMATICS.R")

RI_CONFIG <- c(
	ELA_2016_2017.config,
	PSAT_EBRW_2016_2017.config,

	MATHEMATICS_2016_2017.config,
	ALGEBRA_I_2016_2017.config,
	GEOMETRY_2016_2017.config,
	PSAT_MATH_2016_2017.config)


###  updateSGP

Rhode_Island_SGP <- updateSGP(
			what_sgp_object = Rhode_Island_SGP,
			with_sgp_data_LONG = Rhode_Island_Data_LONG_2016_2017,
			steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
#			steps=c("prepareSGP", "analyzeSGP", "combineSGP", "summarizeSGP", "visualizeSGP", "outputSGP"),
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			simulate.sgps=FALSE,
			save.intermediate.results=FALSE,
			sgp.config=RI_CONFIG,
			sgp.target.scale.scores=FALSE,
			sgPlot.demo.report=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=2, PROJECTIONS=2, LAGGED_PROJECTIONS=2, SGP_SCALE_SCORE_TARGETS=2, SUMMARY=2, SG_PLOTS=1)))


### Save results

save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")


### Edit the SGP Long Data for future analyses

load("./Data/ARCHIVE/PARCC 2015 to 2017/Rhode_Island_Data_LONG_2016_2017.Rdata")

Rhode_Island_Data_LONG_2016_2017[CONTENT_AREA == "PSAT_EBRW", CONTENT_AREA := "ELA_PSAT_10"]
Rhode_Island_Data_LONG_2016_2017[CONTENT_AREA == "PSAT_MATH", CONTENT_AREA := "MATHEMATICS_PSAT_10"]

Rhode_Island_Data_LONG_2016_2017 <- SGP:::getAchievementLevel(
	Rhode_Island_Data_LONG_2016_2017, state="RI",
	content_area = c("ELA_PSAT_10", "MATHEMATICS_PSAT_10"),
	achievement.level.name="ACHIEVEMENT_LEVEL", scale.score.name="SCALE_SCORE")
# table(Rhode_Island_Data_LONG_2016_2017[, ACHIEVEMENT_LEVEL, CONTENT_AREA], exclude=NULL)

save(Rhode_Island_Data_LONG_2016_2017, file = "./Data/ARCHIVE/PARCC 2015 to 2017/Rhode_Island_Data_LONG_2016_2017.Rdata")
