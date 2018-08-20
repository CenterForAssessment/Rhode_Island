################################################################################
###                                                                          ###
###                   Rhode Island analyses for 2017-2018                    ###
###                                                                          ###
################################################################################

###   Load SGP Package

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
