######################################################################################
###                                                                                ###
###                Rhode Island COVID Skip-year SGP analyses for 2021              ###
###                                                                                ###
######################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Rhode_Island_SGP.Rdata"))
load("Data/Rhode_Island_Data_LONG_2021.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("RI", "2020_2021")

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2020_2021/PART_A/ELA.R")
source("SGP_CONFIG/2020_2021/PART_A/ELA_PSAT_10.R")
source("SGP_CONFIG/2020_2021/PART_A/MATHEMATICS.R")
source("SGP_CONFIG/2020_2021/PART_A/MATHEMATICS_PSAT_10.R")

RI_CONFIG <- c(ELA_2020_2021.config, ELA_PSAT_10_2020_2021.config, MATHEMATICS_2020_2021.config, MATHEMATICS_PSAT_10_2020_2021.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

#####
###   Run updateSGP analysis
#####

Rhode_Island_SGP <- updateSGP(
        what_sgp_object = Rhode_Island_SGP,
        with_sgp_data_LONG = Rhode_Island_Data_LONG_2021,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = MA_CONFIG,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)

###   Save results
save(Rhode_Island_SGP, file="Rhode_Island_SGP.Rdata"))
