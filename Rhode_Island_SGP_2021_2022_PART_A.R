###############################################################################
###                                                                         ###
###          Rhode_Island 2019 consecutive-year BASELINE SGP analyses       ###
###          NOTE: Doing this in 2022 thus the file name                    ###
###                                                                         ###
###############################################################################

###   Load packages
require(SGP)
require(data.table)
require(SGPmatrices)

###   Load data
load("Data/Rhode_Island_SGP.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("RI", "2022")
SGPstateData[["RI"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL
SGPstateData[["RI"]][["SGP_Configuration"]][["print.other.gp"]] <- TRUE

###   Rename the skip-year SGP variables and objects

##    We can simply rename the BASELINE variables. We only have 2019/21 skip yr
# table(Rhode_Island_SGP@Data[!is.na(SGP_BASELINE),
#         .(CONTENT_AREA, YEAR), GRADE], exclude = NULL)
baseline.names <- grep("BASELINE", names(Rhode_Island_SGP@Data), value = TRUE)
setnames(Rhode_Island_SGP@Data,
         baseline.names,
         paste0(baseline.names, "_SKIP_YEAR"))

sgps.2018_2019 <- grep(".2018_2019.BASELINE", names(Rhode_Island_SGP@SGP[["SGPercentiles"]]))
names(Rhode_Island_SGP@SGP[["SGPercentiles"]])[sgps.2018_2019] <-
    gsub(".2018_2019.BASELINE",
         ".2018_2019.SKIP_YEAR_BASELINE",
         names(Rhode_Island_SGP@SGP[["SGPercentiles"]])[sgps.2018_2019])


###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2021_2022/PART_A/ELA_RICAS.R")
source("SGP_CONFIG/2021_2022/PART_A/ELA_SAT.R")
source("SGP_CONFIG/2021_2022/PART_A/MATHEMATICS_RICAS.R")
source("SGP_CONFIG/2021_2022/PART_A/MATHEMATICS_SAT.R")

RI_Baseline_Config_2018_2019 <- c(
  ELA_RICAS_2018_2019.config,
  ELA_SAT_2018_2019.config,

  MATHEMATICS_RICAS_2018_2019.config,
  MATHEMATICS_SAT_2018_2019.config
)

###   Parallel Config
parallel.config <- list(BACKEND = "PARALLEL",
                        WORKERS = list(BASELINE_PERCENTILES = 4))


#####
###   Run abcSGP analysis
#####

Rhode_Island_SGP <-
    abcSGP(sgp_object = Rhode_Island_SGP,
           years = "2018_2019",
           steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
           sgp.config = RI_Baseline_Config_2018_2019,
           sgp.percentiles = FALSE,
           sgp.projections = FALSE,
           sgp.projections.lagged = FALSE,
           sgp.percentiles.baseline = TRUE,
           sgp.projections.baseline = FALSE,
           sgp.projections.lagged.baseline = FALSE,
           simulate.sgps = FALSE,
           parallel.config = parallel.config)

###   Save results
save(Rhode_Island_SGP, file = "Data/Rhode_Island_SGP.Rdata")
