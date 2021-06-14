##########################################################################################
###                                                                                    ###
###   Rhode_Island Learning Loss Analyses -- 2018-2019 Baseline Growth Projections     ###
###                                                                                    ###
##########################################################################################

###   Load packages
require(SGP)

###   Load data from baseline SGP analyses
load("Data/Rhode_Island_SGP.Rdata")

###   Add single-cohort baseline matrices to SGPstateData
SGPstateData <- SGPmatrices::addBaselineMatrices("RI", "2020_2021")

### NULL out assessment transition in 2019 (since already dealth with)
SGPstateData[["RI"]][["Assessment_Program_Information"]][["Assessment_Transition"]] <- NULL
SGPstateData[["RI"]][["Assessment_Program_Information"]][["Scale_Change"]] <- NULL

###   Update SGPstateData with grade/course/lag progression information
source("SGP_CONFIG/2018_2019/BASELINE/Projections/Skip_Year_Projections_MetaData.R")

###   Read in BASELINE projections configuration scripts and combine
source("SGP_CONFIG/2018_2019/BASELINE/Projections/ELA.R")
source("SGP_CONFIG/2018_2019/BASELINE/Projections/ELA_PSAT_10.R")
source("SGP_CONFIG/2018_2019/BASELINE/Projections/MATHEMATICS.R")
source("SGP_CONFIG/2018_2019/BASELINE/Projections/MATHEMATICS_PSAT_10.R")

RI_2018_2019_Baseline_Config <- c(
	ELA_2018_2019.config,
	ELA_PSAT_10_2018_2019.config,
	MATHEMATICS_2018_2019.config,
	MATHEMATICS_PSAT_10_2018_2019.config
)

#####
###   Run projections analysis - run abcSGP on object from BASELINE SGP analysis
#####

Rhode_Island_SGP <- abcSGP(
        sgp_object = Rhode_Island_SGP,
        steps = c("prepareSGP", "analyzeSGP"), # no changes to @Data - don't combine or output
        sgp.config = RI_2018_2019_Baseline_Config,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = TRUE, # Need P50_PROJ_YEAR_1_CURRENT for Ho's Fair Trend/Equity Check metrics
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = list(
					BACKEND = "PARALLEL",
          WORKERS=list(PROJECTIONS=8))
)

###   Save results
save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")
