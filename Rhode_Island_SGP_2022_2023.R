################################################################################
###                                                                          ###
###                Rhode_Island SGP analyses for 2023                        ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Rhode_Island_SGP.Rdata")
load("Data/Rhode_Island_Data_LONG_2022_2023.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("RI", "2022_2023")
SGPstateData[["RI"]][["SGP_Configuration"]][["print.other.gp"]] <- TRUE
#quantile(Rhode_Island_Data_LONG_2022_2023[VALID_CASE=="VALID_CASE" & CONTENT_AREA=="ELA_PSAT_10"]$SCALE_SCORE, probs=c(0.2, 0.4, 0.6, 0.8)) c(360, 410, 470, 540)
SGPstateData$RI$Achievement$Knots_Boundaries$ELA_PSAT_10$knots_EOCT <- c(400, 540, 580, 680)
#quantile(Rhode_Island_Data_LONG_2022_2023[VALID_CASE=="VALID_CASE" & CONTENT_AREA=="MATHEMATICS_PSAT_10"]$SCALE_SCORE, probs=c(0.2, 0.4, 0.6, 0.8))  c(370, 410, 450, 500)
SGPstateData$RI$Achievement$Knots_Boundaries$MATHEMATICS_PSAT_10$knots_EOCT <- c(320, 360, 600, 650)
#quantile(Rhode_Island_Data_LONG_2022_2023[VALID_CASE=="VALID_CASE" & CONTENT_AREA=="ELA_SAT"]$SCALE_SCORE, probs=c(0.2, 0.4, 0.6, 0.8)) c(390, 440, 500, 580)
SGPstateData$RI$Achievement$Knots_Boundaries$ELA_SAT$knots_EOCT <- c(390, 440, 500, 580)
#quantile(Rhode_Island_Data_LONG_2022_2023[VALID_CASE=="VALID_CASE" & CONTENT_AREA=="MATHEMATICS_SAT"]$SCALE_SCORE, probs=c(0.2, 0.4, 0.6, 0.8)) c(370, 420, 480, 540)
SGPstateData$RI$Achievement$Knots_Boundaries$MATHEMATICS_SAT$knots_EOCT <- c(370, 420, 480, 540)

SGPstateData[["RI"]][["Growth"]][["System_Type"]] <- "Baseline Referenced"

###   Read in SGP Configuration Scripts and Combine
#source("SGP_CONFIG/2022_2023/ELA_RICAS.R")
source("SGP_CONFIG/2022_2023/ELA_SAT.R")
#source("SGP_CONFIG/2022_2023/MATHEMATICS_RICAS.R")
source("SGP_CONFIG/2022_2023/MATHEMATICS_SAT.R")

RI_Config_2022_2023 <- c(
#  ELA_RICAS_2022_2023.config,
  ELA_SAT_2022_2023.config,

#  MATHEMATICS_RICAS_2022_2023.config,
  MATHEMATICS_SAT_2022_2023.config
)

RI_Baseline_Config_2022_2023 <- c(
#  ELA_RICAS_Baseline_2022_2023.config,
  ELA_SAT_2022_2023.config,

#  MATHEMATICS_RICAS_Baseline_2022_2023.config,
  MATHEMATICS_SAT_2022_2023.config
)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

#####
###   Run updateSGP analysis for cohort referenced SGPs
#####

Rhode_Island_SGP <- updateSGP(
        what_sgp_object = Rhode_Island_SGP,
        with_sgp_data_LONG = Rhode_Island_Data_LONG_2022_2023,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = RI_Config_2022_2023,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)


#####
###   Run abcSGP analysis for baseline referenced SGPs
#####

Rhode_Island_SGP <- abcSGP(
        sgp_object = Rhode_Island_SGP,
#        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = RI_Baseline_Config_2022_2023,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)

### Test
print(Rhode_Island_SGP@Data[YEAR=="2022_2023", list(MEAN_SGP=mean(SGP, na.rm=TRUE), MEDIAN_SGP=median(SGP, na.rm=TRUE)), keyby=c("CONTENT_AREA", "GRADE")])

###   Save results
#save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")
