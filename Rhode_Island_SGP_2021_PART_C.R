#####################################################################################
###                                                                               ###
###           SGP LAGGED projections for skip year SGP analyses for 2020-2021     ###
###                                                                               ###
#####################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Rhode_Island_SGP.Rdata"))

###   Load configurations
source("SGP_CONFIG/2020_2021/PART_C/ELA.R")
source("SGP_CONFIG/2020_2021/PART_C/MATHEMATICS.R")

RI_CONFIG <- c(ELA_2020_2021.config, MATHEMATICS_2020_2021.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

###   Add Baseline matrices to SGPstateData and update SGPstateData
SGPstateData <- addBaselineMatrices("RI", "2020_2021")
SGPstateData[["RI"]][["Growth"]][["System_Type"]] <- "Baseline Referenced"

#  Establish required meta-data for LAGGED projection sequences
SGPstateData[["RI"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
    ELA_GRADE_3=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT"),
    ELA_GRADE_4=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT"),
    ELA_GRADE_5=c("3", "5", "6", "7", "8", "EOCT", "EOCT"),
    ELA_GRADE_6=c("3", "4", "6", "7", "8", "EOCT", "EOCT"),
    ELA_GRADE_7=c("3", "4", "5", "7", "8", "EOCT", "EOCT"),
    ELA_GRADE_8=c("3", "4", "5", "6", "8", "EOCT", "EOCT"),
    ELA_GRADE_10=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT"),
    MATHEMATICS_GRADE_3=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT"),
    MATHEMATICS_GRADE_4=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT"),
    MATHEMATICS_GRADE_5=c("3", "5", "6", "7", "8", "EOCT", "EOCT"),
    MATHEMATICS_GRADE_6=c("3", "4", "6", "7", "8", "EOCT", "EOCT"),
    MATHEMATICS_GRADE_7=c("3", "4", "5", "7", "8", "EOCT", "EOCT"),
    MATHEMATICS_GRADE_8=c("3", "4", "5", "6", "8", "EOCT", "EOCT"),
    MATHEMATICS_GRADE_10=c("3", "4", "5", "6", "7", "8", "EOCT", "EOCT"))
SGPstateData[["RI"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
    ELA_GRADE_3=c(rep("ELA", 6), "ELA_PSAT_10", "ELA_SAT"),
    ELA_GRADE_4=c(rep("ELA", 6), "ELA_PSAT_10", "ELA_SAT"),
    ELA_GRADE_5=c(rep("ELA", 5), "ELA_PSAT_10", "ELA_SAT"),
    ELA_GRADE_6=c(rep("ELA", 5), "ELA_PSAT_10", "ELA_SAT"),
    ELA_GRADE_7=c(rep("ELA", 5), "ELA_PSAT_10", "ELA_SAT"),
    ELA_GRADE_8=c(rep("ELA", 5), "ELA_PSAT_10", "ELA_SAT"),
    ELA_GRADE_10=c(rep("ELA", 6), "ELA_PSAT_10", "ELA_SAT"),
    MATHEMATICS_GRADE_3=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    MATHEMATICS_GRADE_4=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    MATHEMATICS_GRADE_5=c(rep("MATHEMATICS", 5), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    MATHEMATICS_GRADE_6=c(rep("MATHEMATICS", 5), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    MATHEMATICS_GRADE_7=c(rep("MATHEMATICS", 5), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    MATHEMATICS_GRADE_8=c(rep("MATHEMATICS", 5), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"),
    MATHEMATICS_GRADE_10=c(rep("MATHEMATICS", 6), "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT"))
SGPstateData[["RI"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <- list(
    ELA_GRADE_3=3,
    ELA_GRADE_4=3,
    ELA_GRADE_5=3,
    ELA_GRADE_6=3,
    ELA_GRADE_7=3,
    ELA_GRADE_8=3,
    ELA_GRADE_10=3,
    MATHEMATICS_GRADE_3=3,
    MATHEMATICS_GRADE_4=3,
    MATHEMATICS_GRADE_5=3,
    MATHEMATICS_GRADE_6=3,
    MATHEMATICS_GRADE_7=3,
    MATHEMATICS_GRADE_8=3,
    MATHEMATICS_GRADE_10=3)


### Run analysis

Rhode_Island_SGP <- abcSGP(
        Rhode_Island_SGP,
        steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config=MA_CONFIG,
        sgp.percentiles=FALSE,
        sgp.projections=FALSE,
        sgp.projections.lagged=FALSE,
        sgp.percentiles.baseline=FALSE,
        sgp.projections.baseline=FALSE,
        sgp.projections.lagged.baseline=TRUE,
        sgp.target.scale.scores=TRUE,
        outputSGP.directory=output.directory,
        parallel.config=parallel.config
)


###  Save results
save(Rhode_Island_SGP, "Data/Rhode_Island_SGP.Rdata"))
