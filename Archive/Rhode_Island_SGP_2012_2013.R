###########################################################
###
### Rhode Island SGP Analysis for 2012_2013
###
###########################################################

### Load SGP Package

require(SGP)
options(error=recover)


### Load previous SGP object and 2012_2013 data

load("Data/Rhode_Island_SGP.Rdata")
load("Data/Rhode_Island_Data_LONG_2012_2013.Rdata")


### Update SGPs

Rhode_Island_SGP <- updateSGP(
			Rhode_Island_SGP,
			Rhode_Island_Data_LONG_2012_2013,
			sgPlot.demo.report=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SUMMARY=4, GA_PLOTS=4, SG_PLOTS=1)))


### Save results

save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")
