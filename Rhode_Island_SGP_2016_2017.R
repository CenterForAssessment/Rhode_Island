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
