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

Rhode_Island_Data_LONG[is.na(SCALE_SCORE_ACTUAL), SCALE_SCORE_ACTUAL := SCALE_SCORE]
setnames(Rhode_Island_Data_LONG,  c("SCALE_SCORE_ACTUAL", "SCALE_SCORE"), c("SCALE_SCORE", "SCALE_SCORE_THETA"))

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

###   Load existing SGP object and RICAS LONG Data
load("Data/Rhode_Island_SGP.Rdata")
load("Data/Rhode_Island_Data_LONG_2017_2018.Rdata")

# setnames(Rhode_Island_Data_LONG_2017_2018, c("SCALE_SCORE_ACTUAL", "SCALE_SCORE_ACTUAL_CSEM", "SCALE_SCORE", "SCALE_SCORE_CSEM"), c("SCALE_SCORE", "SCALE_SCORE_CSEM", "SCALE_SCORE_THETA", "SCALE_SCORE_THETA_CSEM"))

###  Establish (prelimimary) Knots and Boundaries for Simulated_SGPs/SGP_STANDARD_ERROR

kbs <- createKnotsBoundaries(Rhode_Island_Data_LONG_2017_2018)
SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["ELA.2017_2018"]] <- kbs[["ELA"]]
SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2017_2018"]] <- kbs[["MATHEMATICS"]]

###  updateSGP

Rhode_Island_SGP <- updateSGP(
  what_sgp_object=Rhode_Island_SGP,
  with_sgp_data_LONG=Rhode_Island_Data_LONG_2017_2018,
  content_areas = c("ELA", "MATHEMATICS"),
	overwrite.existing.data=FALSE,
	output.updated.data=FALSE,
  steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP", "summarizeSGP"),
  sgp.percentiles = TRUE,
  sgp.projections = FALSE,
  sgp.projections.lagged = FALSE,
  sgp.percentiles.baseline = FALSE,
  sgp.projections.baseline = FALSE,
  sgp.projections.lagged.baseline = FALSE,
  sgp.percentiles.equated = FALSE,
  simulate.sgps = TRUE,
	# calculate.simex = list(
	# 	state="RI", lambda=seq(0,2,0.5), simulation.iterations=5, simex.sample.size=1500, extrapolation="linear", save.matrices=TRUE),
  calculate.simex = TRUE,
  goodness.of.fit.print=TRUE,
  save.intermediate.results=FALSE,
	parallel.config = list(
				BACKEND="PARALLEL", WORKERS=list(TAUS=15, SIMEX=15, SUMMARY=15)))

save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")
