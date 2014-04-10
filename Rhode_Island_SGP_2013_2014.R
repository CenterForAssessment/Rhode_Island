###########################################################
###
### Rhode Island SGP Analysis for 2013_2014
###
###########################################################

### Load SGP Package

require(SGP)
options(error=recover)


### Load previous SGP object and 2013_2014 data

load("Data/Rhode_Island_SGP.Rdata")
load("Data/Rhode_Island_Data_LONG_2013_2014.Rdata")


### Update SGPs

Rhode_Island_SGP <- updateSGP(
			Rhode_Island_SGP,
			Rhode_Island_Data_LONG_2013_2014,
			sgPlot.demo.report=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SUMMARY=4, GA_PLOTS=4, SG_PLOTS=1)))


### Save results

save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")
