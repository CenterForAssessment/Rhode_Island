################################################################################
###                                                                          ###
###                Rhode_Island SGP analyses for 2024                        ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Rhode_Island_SGP.Rdata")
load("Data/Rhode_Island_Data_LONG_2023_2024.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("RI", "2023_2024")
SGPstateData[["RI"]][["SGP_Configuration"]][["print.other.gp"]] <- TRUE
#quantile(Rhode_Island_Data_LONG_2023_2024[VALID_CASE=="VALID_CASE" & CONTENT_AREA=="ELA" & GRADE=="3"]$SCALE_SCORE, probs=c(0.0, 0.2, 0.4, 0.6, 0.8, 1.0)) #c(-1.677, -0.780, -0.087, 0.646)
SGPstateData$RI$Achievement$Knots_Boundaries$ELA$knots_3 <- c(-1.1, -0.20, 0.20, 0.70)
#quantile(Rhode_Island_Data_LONG_2023_2024[VALID_CASE=="VALID_CASE" & CONTENT_AREA=="ELA" & GRADE=="7"]$SCALE_SCORE, probs=c(0.0, 0.2, 0.4, 0.6, 0.8, 1.0)) 
SGPstateData$RI$Achievement$Knots_Boundaries$ELA$knots_7 <- quantile(Rhode_Island_Data_LONG_2023_2024[VALID_CASE=="VALID_CASE" & CONTENT_AREA=="ELA" & GRADE=="7"]$SCALE_SCORE, probs=c(0.1, 0.2, 0.4, 0.6, 0.8))
#quantile(Rhode_Island_Data_LONG_2023_2024[VALID_CASE=="VALID_CASE" & CONTENT_AREA=="MATHEMATICS" & GRADE=="7"]$SCALE_SCORE, probs=c(0.2, 0.4, 0.6, 0.8)) 
SGPstateData$RI$Achievement$Knots_Boundaries$MATHEMATICS$knots_7 <- quantile(Rhode_Island_Data_LONG_2023_2024[VALID_CASE=="VALID_CASE" & CONTENT_AREA=="MATHEMATICS" & GRADE=="7"]$SCALE_SCORE, probs=c(0.2, 0.4, 0.6, 0.8))
#quantile(Rhode_Island_Data_LONG_2023_2024[VALID_CASE=="VALID_CASE" & CONTENT_AREA=="ELA_PSAT_10"]$SCALE_SCORE, probs=c(0.2, 0.4, 0.6, 0.8)) c(360, 410, 470, 540)
SGPstateData$RI$Achievement$Knots_Boundaries$ELA_PSAT_10$knots_EOCT <- c(400, 540, 580, 680)
#quantile(Rhode_Island_Data_LONG_2023_2024[VALID_CASE=="VALID_CASE" & CONTENT_AREA=="MATHEMATICS_PSAT_10"]$SCALE_SCORE, probs=c(0.2, 0.4, 0.6, 0.8))  c(370, 410, 450, 500)
SGPstateData$RI$Achievement$Knots_Boundaries$MATHEMATICS_PSAT_10$knots_EOCT <- c(320, 360, 600, 650)
#quantile(Rhode_Island_Data_LONG_2023_2024[VALID_CASE=="VALID_CASE" & CONTENT_AREA=="ELA_SAT"]$SCALE_SCORE, probs=c(0.2, 0.4, 0.6, 0.8)) c(390, 440, 500, 580)
SGPstateData$RI$Achievement$Knots_Boundaries$ELA_SAT$knots_EOCT <- c(390, 440, 500, 580)
#quantile(Rhode_Island_Data_LONG_2023_2024[VALID_CASE=="VALID_CASE" & CONTENT_AREA=="MATHEMATICS_SAT"]$SCALE_SCORE, probs=c(0.2, 0.4, 0.6, 0.8)) c(370, 420, 480, 540)
SGPstateData$RI$Achievement$Knots_Boundaries$MATHEMATICS_SAT$knots_EOCT <- c(370, 420, 480, 540)

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2023_2024/ELA_RICAS.R")
source("SGP_CONFIG/2023_2024/ELA_SAT.R")
source("SGP_CONFIG/2023_2024/MATHEMATICS_RICAS.R")
source("SGP_CONFIG/2023_2024/MATHEMATICS_SAT.R")

RI_Config_2023_2024 <- c(
  ELA_RICAS_2023_2024.config,
  ELA_SAT_2023_2024.config,

  MATHEMATICS_RICAS_2023_2024.config,
  MATHEMATICS_SAT_2023_2024.config
)

RI_Baseline_Config_2023_2024 <- c(
  ELA_RICAS_Baseline_2023_2024.config,
  ELA_SAT_2023_2024.config,

  MATHEMATICS_RICAS_Baseline_2023_2024.config,
  MATHEMATICS_SAT_2023_2024.config
)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

#####
###   Run updateSGP analysis for cohort referenced SGPs
#####

Rhode_Island_SGP <- updateSGP(
        what_sgp_object = Rhode_Island_SGP,
        with_sgp_data_LONG = Rhode_Island_Data_LONG_2023_2024,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = RI_Config_2023_2024,
        sgp.percentiles = TRUE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        sgp.use.my.coefficient.matrices=TRUE, ## (Added for missing 8 students)
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)

#####
###   Run abcSGP analysis for baseline referenced SGPs
#####

Rhode_Island_SGP <- abcSGP(
        sgp_object = Rhode_Island_SGP,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = RI_Baseline_Config_2023_2024,
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
print(Rhode_Island_SGP@Data[YEAR=="2023_2024", list(MEAN_SGP=mean(SGP, na.rm=TRUE), MEDIAN_SGP=median(SGP, na.rm=TRUE)), keyby=c("CONTENT_AREA", "GRADE")])
print(Rhode_Island_SGP@Data[YEAR=="2023_2024", list(MEAN_SGP_BASELINE=mean(SGP_BASELINE, na.rm=TRUE), MEDIAN_SGP_BASELINE=median(SGP_BASELINE, na.rm=TRUE)), keyby=c("CONTENT_AREA", "GRADE")])

###   Save results
save(Rhode_Island_SGP, file="Data/Rhode_Island_SGP.Rdata")
