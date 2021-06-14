##########################################################################################
###                                                                                    ###
###   Rhode_Island Learning Loss Analyses -- 2018-2019 Baseline Growth Percentiles     ###
###                                                                                    ###
##########################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data and remove years that will not be used.
load("Data/Rhode_Island_SGP_LONG_Data.Rdata")

###   Add single-cohort baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("RI", "2020_2021")

### NULL out assessment transition in 2019 (since already dealth with)
SGPstateData[["RI"]][["Assessment_Program_Information"]][["Assessment_Transition"]] <- NULL
SGPstateData[["RI"]][["Assessment_Program_Information"]][["Scale_Change"]] <- NULL

###   Read in BASELINE percentiles configuration scripts and combine
source("SGP_CONFIG/2018_2019/BASELINE/Percentiles/ELA.R")
source("SGP_CONFIG/2018_2019/BASELINE/Percentiles/ELA_PSAT_10.R")
source("SGP_CONFIG/2018_2019/BASELINE/Percentiles/MATHEMATICS.R")
source("SGP_CONFIG/2018_2019/BASELINE/Percentiles/MATHEMATICS_PSAT_10.R")

RI_2018_2019_Baseline_Config <- c(
	ELA_2018_2019.config,
	ELA_PSAT_10_2018_2019.config,
	MATHEMATICS_2018_2019.config,
	MATHEMATICS_PSAT_10_2018_2019.config
)

#####
###   Run BASELINE SGP analysis - create new Rhode_Island_SGP object with historical data
#####

###   Temporarily set names of prior scores from sequential/cohort analyses
data.table::setnames(Rhode_Island_SGP_LONG_Data,
	c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"),
	c("SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"))

SGPstateData[["RI"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL

Rhode_Island_SGP <- abcSGP(
        sgp_object = Rhode_Island_SGP_LONG_Data,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = RI_2018_2019_Baseline_Config,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,  #  Skip year SGPs for 2021 comparisons
        sgp.projections.baseline = FALSE, #  Calculated in next step
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = list(
					BACKEND = "PARALLEL",
					WORKERS=list(BASELINE_PERCENTILES=8))
)

###   Re-set and rename prior scores (one set for sequential/cohort, another for skip-year/baseline)
data.table::setnames(Rhode_Island_SGP@Data,
  c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"),
  c("SCALE_SCORE_PRIOR_BASELINE", "SCALE_SCORE_PRIOR_STANDARDIZED_BASELINE", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"))

###   Save results
save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")
