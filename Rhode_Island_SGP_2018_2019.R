################################################################################
###                                                                          ###
###                   Rhode Island analyses for 2018-2019                    ###
###                                                                          ###
################################################################################

###   Load Required Packages

require(SGP)
require(data.table)


###   Load data

load("Data/Rhode_Island_SGP.Rdata")
load("Data/Rhode_Island_Data_LONG_2018_2019.Rdata")


###   Load configurations

source("SGP_CONFIG/2018_2019/ELA_RICAS.R")
source("SGP_CONFIG/2018_2019/ELA_SAT.R")
source("SGP_CONFIG/2018_2019/MATHEMATICS_RICAS.R")
source("SGP_CONFIG/2018_2019/MATHEMATICS_SAT.R")

#RI_CONFIG <- c(ELA_SAT_2018_2019.config, ELA_RICAS_2018_2019.config, MATHEMATICS_SAT_2018_2019.config, MATHEMATICS_RICAS_2018_2019.config) 
RI_CONFIG <- c(ELA_SAT_2018_2019.config, MATHEMATICS_SAT_2018_2019.config)


###  updateSGP

Rhode_Island_SGP <- updateSGP(
		what_sgp_object=Rhode_Island_SGP,
		with_sgp_data=Rhode_Island_Data_LONG_2018_2019, 
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
