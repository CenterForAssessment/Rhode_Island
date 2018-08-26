################################################################################
###                                                                          ###
###                   Rhode Island analyses for 2017-2018                    ###
###                                                                          ###
################################################################################

###   Load Required Packages
require(SGP)
require(data.table)


####
##    PSAT/SAT Analyses
####

###   Load data

load("Data/ARCHIVE/PARCC 2015 to 2017/Rhode_Island_Data_LONG_2015_2016.Rdata")
load("Data/ARCHIVE/PARCC 2015 to 2017/Rhode_Island_Data_LONG_2016_2017.Rdata")
load("Data/Rhode_Island_Data_LONG_SAT_2017_2018.Rdata")

Rhode_Island_Data_LONG <- rbindlist(
	list(
		 Rhode_Island_Data_LONG_2015_2016,
		 Rhode_Island_Data_LONG_2016_2017,
		 Rhode_Island_Data_LONG_SAT_2017_2018), fill = TRUE)

###   Load configurations

source("SGP_CONFIG/2017_2018/ELA.R")
source("SGP_CONFIG/2017_2018/MATHEMATICS.R")

RI_CONFIG <- c(
	ELA_PSAT_10_2017_2018.config,
	ELA_SAT_2017_2018.config,

	MATHEMATICS_PSAT_10_2017_2018.config,
	MATHEMATICS_SAT_2017_2018.config)


###  abcSGP

Rhode_Island_SGP <- abcSGP(
		sgp_object = Rhode_Island_Data_LONG,
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
		sgp.percentiles=TRUE,
		sgp.projections=FALSE,
		sgp.projections.lagged=FALSE,
		sgp.percentiles.baseline=FALSE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		sgp.percentiles.equated=FALSE,
		simulate.sgps=FALSE,
		save.intermediate.results=FALSE,
		sgp.config=RI_CONFIG,
		sgp.target.scale.scores=FALSE,
		outputSGP.output.type = "LONG_FINAL_YEAR_Data"
	)


### Save results
save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")


####
##    RICAS Analyses
####

###   Load Required Packages
require(SGP)
require(data.table)

###   Load existing SGP object and RICAS LONG Data
load("~/Dropbox (SGP)/SGP/Rhode_Island/Data/Rhode_Island_SGP.Rdata")
load("~/Dropbox (SGP)/SGP/Rhode_Island/Data/Rhode_Island_Data_LONG_2017_2018.Rdata")

Rhode_Island_SGP <- updateSGP(
  what_sgp_object=Rhode_Island_SGP,
  with_sgp_data_LONG=Rhode_Island_Data_LONG_2017_2018,
  content_areas = c("ELA", "MATHEMATICS"),
	overwrite.existing.data=FALSE,
	output.updated.data=FALSE,
  steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"), # , "summarizeSGP"
  sgp.percentiles = TRUE,
  sgp.projections = FALSE,
  sgp.projections.lagged = FALSE,
  sgp.percentiles.baseline = FALSE,
  sgp.projections.baseline = FALSE,
  sgp.projections.lagged.baseline = FALSE,
  sgp.percentiles.equated = FALSE,
  simulate.sgps = TRUE,
	calculate.simex = list(
		state="RI", lambda=seq(0,2,0.5), simulation.iterations=25, simex.sample.size=2500, extrapolation="linear", save.matrices=TRUE, verbose=TRUE),
  # calculate.simex = TRUE, #  Could potentially do SIMEX ...
  goodness.of.fit.print=TRUE,
  save.intermediate.results=FALSE,
	parallel.config = list(
				BACKEND="PARALLEL", WORKERS=list(TAUS=6, SIMEX=6, SUMMARY=6)))

save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")


# SGPstateData[["RI"]][["SGP_Configuration"]][["state.multiple.year.summary"]] <- 1

Rhode_Island_SGP <- summarizeSGP(
	Rhode_Island_SGP,
	years = "2017_2018",
	content_areas = c("ELA", "ELA_PSAT_10", "ELA_SAT", "MATHEMATICS", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
	parallel.config=list(
		BACKEND="PARALLEL", WORKERS=list(SUMMARY=6))
)


###  Equated SGPs and PROJECTIONS

Not an option at this point because of missing 9th grade test/analog to ELA 9 and ALGEBRA_I
Could put in skip year to the progressions?
