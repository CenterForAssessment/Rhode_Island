#####################################################################################
###
### Rhode Island analyses for 2015-2016
###
#####################################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load data

load("Data/Rhode_Island_Data_LONG_2014_2015.Rdata")
load("Data/Rhode_Island_Data_LONG_2015_2016.Rdata")
Rhode_Island_Data_LONG <- rbindlist(list(Rhode_Island_Data_LONG_2014_2015, Rhode_Island_Data_LONG_2015_2016), fill=TRUE)


### Load configurations

source("SGP_CONFIG/2015_2016/ELA.R")
source("SGP_CONFIG/2015_2016/MATHEMATICS.R")

RI_CONFIG <- c(ELA_2015_2016.config, MATHEMATICS_2015_2016.config)


### updateSGP

Rhode_Island_SGP <- abcSGP(
			Rhode_Island_Data_LONG,
			steps=c("prepareSGP", "analyzeSGP", "combineSGP", "summarizeSGP", "outputSGP"),
#			steps=c("prepareSGP", "analyzeSGP", "combineSGP", "summarizeSGP", "visualizeSGP", "outputSGP"),
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			simulate.sgps=FALSE,
			sgp.config=RI_CONFIG,
			sgp.target.scale.scores=TRUE,
			sgPlot.demo.report=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=2, PROJECTIONS=2, LAGGED_PROJECTIONS=2, SGP_SCALE_SCORE_TARGETS=2, SG_PLOTS=1)))


### Save results

save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")
