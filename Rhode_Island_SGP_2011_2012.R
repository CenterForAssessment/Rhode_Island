############################################################################
###
### Rhode Island 2011_2012 SGP update
###
############################################################################

### Load SGP Package

require(SGP)
options(error=recover)


### Load Rhode_Island_SGP and 2012 long data

#load("Data/Rhode_Island_SGP.Rdata")

Rhode_Island_SGP@Summary <- NULL


#### Calculate SGPs

Rhode_Island_SGP <- abcSGP(
			Rhode_Island_SGP, 
			years="2011_2012", 
			steps=c("prepareSGP", "analyzeSGP", "combineSGP", "summarizeSGP", "visualizeSGP", "outputSGP")[4:6], 
			save.intermediate.results=TRUE,
			sgPlot.demo.report=TRUE)
#			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=30, BASELINE_PERCENTILES=30, PROJECTIONS=24, LAGGED_PROJECTIONS=24, SUMMARY=30, GA_PLOTS=10, SG_PLOTS=1)))


### Save results

save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")


### Update projections and lagged.projections

Rhode_Island_SGP <- analyzeSGP(
			Rhode_Island_SGP,
			years=c("2007_2008", "2008_2009", "2009_2010", "2010_2011", "2011_2012"),
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=TRUE,
			sgp.projections.baseline=TRUE,
			sgp.projections.lagged.baseline=TRUE,
			sgp.use.my.coefficient.matrices=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=30, BASELINE_PERCENTILES=30, PROJECTIONS=24, LAGGED_PROJECTIONS=24, SUMMARY=30, GA_PLOTS=10, SG_PLOTS=1)))

### Combine results

Rhode_Island_SGP <- combineSGP(Rhode_Island_SGP, update.all.years=TRUE)


### Create summary tables

Rhode_Island_SGP <- summarizeSGP(Rhode_Island_SGP, parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SUMMARY=30)))


### Create student growth reports

visualizeSGP(Rhode_Island_SGP, plot.types="studentGrowthPlot", parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SG_PLOTS=30)))


### Output results

outputSGP(Rhode_Island_SGP, output.types=c("LONG_Data", "WIDE_Data", "SchoolView"))
