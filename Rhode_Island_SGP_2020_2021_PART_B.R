#####################################################################################
###                                                                               ###
###          SGP STRAIGHT projections for skip year SGP analyses for 2020-2021    ###
###                                                                               ###
#####################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)
#debug(SGP:::getSGPConfig)
#debug(analyzeSGP)
#debug(SGP:::getsplineMatrices)

###   Load data
load("Data/Rhode_Island_SGP.Rdata")

###   Load configurations
source("SGP_CONFIG/2020_2021/PART_B/ELA.R")
source("SGP_CONFIG/2020_2021/PART_B/MATHEMATICS.R")

RI_CONFIG <- c(ELA_2020_2021.config, MATHEMATICS_2020_2021.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("RI", "2020_2021")
SGPstateData[["RI"]][["SGP_Configuration"]][["sgp.target.scale.scores.merge"]] <- NULL

#  Establish required meta-data for STRAIGHT projection sequences
SGPstateData[["RI"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
    ELA_GRADE_3=c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT"),
    ELA_GRADE_4=c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT"),
    ELA_GRADE_5=c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT"),
    ELA_GRADE_6=c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT"),
    ELA_GRADE_7=c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT"),
    ELA_GRADE_8=c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT"),
    MATHEMATICS_GRADE_3=c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT"),
    MATHEMATICS_GRADE_4=c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT"),
    MATHEMATICS_GRADE_5=c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT"),
    MATHEMATICS_GRADE_6=c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT"),
    MATHEMATICS_GRADE_7=c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT"),
    MATHEMATICS_GRADE_8=c(3, 4, 5, 6, 7, 8, "EOCT", "EOCT"))
SGPstateData[["RI"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
    ELA_GRADE_3=c(rep("ELA", 6), "ELA_PSAT_10", "ELA_SAT"),
    ELA_GRADE_4=c(rep("ELA", 6),  "ELA_PSAT_10", "ELA_SAT"),
    ELA_GRADE_5=c(rep("ELA", 6),  "ELA_PSAT_10", "ELA_SAT"),
    ELA_GRADE_6=c(rep("ELA", 6),  "ELA_PSAT_10", "ELA_SAT"),
    ELA_GRADE_7=c(rep("ELA", 6),  "ELA_PSAT_10", "ELA_SAT"),
    ELA_GRADE_8=c(rep("ELA", 6),  "ELA_PSAT_10", "ELA_SAT"),
    ELA_PSAT_GRADE_EOCT=c(rep("ELA", 6),  "ELA_PSAT_10", "ELA_SAT"),
    MATHEMATICS_GRADE_3=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    MATHEMATICS_GRADE_4=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    MATHEMATICS_GRADE_5=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    MATHEMATICS_GRADE_6=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    MATHEMATICS_GRADE_7=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    MATHEMATICS_GRADE_8=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    MATHEMATICS_PSAT_GRADE_EOCT=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"))
SGPstateData[["RI"]][["SGP_Configuration"]][["year_lags.projection.sequence"]] <- list(
    ELA_GRADE_3=c(1, 1, 1, 1, 1, 2, 1),
    ELA_GRADE_4=c(1, 1, 1, 1, 1, 2, 1),
    ELA_GRADE_5=c(1, 1, 1, 1, 1, 2, 1),
    ELA_GRADE_6=c(1, 1, 1, 1, 1, 2, 1),
    ELA_GRADE_7=c(1, 1, 1, 1, 1, 2, 1),
    ELA_GRADE_8=c(1, 1, 1, 1, 1, 2, 1),
    ELA_PSAT_GRADE_EOCT=c(1, 1, 1, 1, 1, 2, 1),
    MATHEMATICS_GRADE_3=c(1, 1, 1, 1, 1, 2, 1),
    MATHEMATICS_GRADE_4=c(1, 1, 1, 1, 1, 2, 1),
    MATHEMATICS_GRADE_5=c(1, 1, 1, 1, 1, 2, 1),
    MATHEMATICS_GRADE_6=c(1, 1, 1, 1, 1, 2, 1),
    MATHEMATICS_GRADE_7=c(1, 1, 1, 1, 1, 2, 1),
    MATHEMATICS_GRADE_8=c(1, 1, 1, 1, 1, 2, 1),
    MATHEMATICS_PSAT_GRADE_EOCT=c(1, 1, 1, 1, 1, 2, 1))
SGPstateData[["RI"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <- list(
    ELA_GRADE_3=3,
    ELA_GRADE_4=3,
    ELA_GRADE_5=3,
    ELA_GRADE_6=3,
    ELA_GRADE_7=3,
    ELA_GRADE_8=3,
    ELA_PSAT_GRADE_EOCT=3,
    MATHEMATICS_GRADE_3=3,
    MATHEMATICS_GRADE_4=3,
    MATHEMATICS_GRADE_5=3,
    MATHEMATICS_GRADE_6=3,
    MATHEMATICS_GRADE_7=3,
    MATHEMATICS_GRADE_8=3,
    MATHEMATICS_PSAT_GRADE_EOCT=3)

###   Run analysis

Rhode_Island_SGP <- abcSGP(
        Rhode_Island_SGP,
        years = "2020_2021", # need to add years now (after adding 2019 baseline projections).  Why?
        steps=c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config=RI_CONFIG,
        sgp.percentiles=FALSE,
        sgp.projections=FALSE,
        sgp.projections.lagged=FALSE,
        sgp.percentiles.baseline=FALSE,
        sgp.projections.baseline=TRUE,
        sgp.projections.lagged.baseline=FALSE,
        sgp.target.scale.scores=TRUE,
        parallel.config=parallel.config
)

###   Save results
#save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")
