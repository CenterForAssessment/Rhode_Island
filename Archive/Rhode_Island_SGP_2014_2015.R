#####################################################################################
###
### Rhode Island analyses for 2014-2015
###
#####################################################################################

### Load SGP Package

require(SGP)
options(error=recover)


### Load data

load("Data/Rhode_Island_SGP.Rdata")
load("Data/Rhode_Island_Data_LONG_2014_2015.Rdata")


### Load configurations

source("SGP_CONFIG/2014_2015/READING.R")
source("SGP_CONFIG/2014_2015/MATHEMATICS.R")


RI_CONFIG <- c(READING_2014_2015.config, MATHEMATICS_2014_2015.config)


### updateSGP

Rhode_Island_SGP <- updateSGP(
			Rhode_Island_SGP,
			Rhode_Island_Data_LONG_2014_2015,
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			sgp.percentiles.equated=TRUE,
			sgp.percentiles.equating.method=c("identity", "mean", "linear", "equipercentile"),
			sgp.config=RI_CONFIG,
			sgp.target.scale.scores=TRUE,
			plot.types="studentGrowthPlot",
			sgPlot.demo.report=TRUE,
			save.intermediate.results=FALSE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=2, PROJECTIONS=2, LAGGED_PROJECTIONS=2, SGP_SCALE_SCORE_TARGETS=2, SG_PLOTS=1)))


### Save results

L#save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")
